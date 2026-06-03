# TWCoreFHIRModels 專案規範

## 專案定位

本專案為 **台灣核心實作指引 (TW Core IG)** 與 **Apple FHIRModels (`ModelsR4`)** 的整合擴充庫，提供 iOS / Swift 開發者在 HL7® FHIR® R4 標準下快速接入台灣衛福部規範的工具。開放原始碼，MIT License。

## 版本基準

| 項目 | 版本 |
|---|---|
| TW Core IG | **1.0.0**（2025-12-10，官方：https://twcore.mohw.gov.tw/ig/twcore/） |
| FHIR | R4（4.0.1） |
| Apple FHIRModels | 0.9.2+ |

> 所有 Profile URL、CodeSystem URL、驗證規則均以 TW Core IG **1.0.0** 為準。
> 升版時需逐一比對 StructureDefinition ID 是否異動。

## 實作狀態

TW Core IG 1.0.0 全部 33 個 Resource 及所有子型別（Observation 24 種、Organization 3 種、Bundle 2 種）均已完成。新增 Resource 前請先查閱下方 checklist。

---

## 遵從度策略（Conformance Language）

依 FHIR RFC 2119 遵從度動詞，本套件採**分層處理**原則：

| 層次 | 原則 |
|---|---|
| `validateTWCore()` | **只驗證 SHALL 欄位**；SHOULD/MAY 缺失不報錯 |
| Namespace API | 提供 SHALL + 常用 SHOULD 欄位的 getter/setter |
| MAY 欄位 | 暫時略過，有明確需求再補 |

- **SHALL**：必填，驗證器缺失直接回傳 `.failure`
- **SHOULD**：建議填寫，Namespace 提供 API 但不擋 validation
- **MAY**：完全可選，不實作或按需補充

---

## 關鍵技術事實

FHIRModels 0.9.2 的型別設計（**每次新增 Resource 前必確認**）：

| 型別 | 種類 | 屬性 | 備註 |
|---|---|---|---|
| 所有 Resource（Patient 等）| `struct` | `var` | 可直接賦值 |
| `Identifier` | `final class` | `let` | 須用 designated init 一次建構 |
| `Coding`、`CodeableConcept`、`Extension`、`Meta`、`Address` 等 | `struct` | `var` | 可直接賦值 |
| `FHIRPrimitive<T>` | `struct` | `var` | 含 `extension: [Extension]?` |

---

## 架構規則

### Namespace 模式（所有 Resource 必須遵循）

因 Resource 是 struct，namespace 的 `twCore` property 必須同時有 `get` 與 `set`：

```swift
extension SomeResource {
    public var twCore: TWCoreSomeResourceNamespace {
        get { TWCoreSomeResourceNamespace(self) }
        set { self = newValue.resource }          // ← 寫回是關鍵
    }
}
```

### 共用 helpers（禁止重複實作）

- `makeIdentifier(value:system:typeCode:typeCodeSuffix:typeText:)` → `Internal/FHIRHelpers.swift`
- `declareProfile(_:on:)` → `Internal/FHIRHelpers.swift`

### 常數管理

- 所有 TW Core IG URL **必須定義在 `TWCoreURL` enum**，禁止 hardcode 字串

### 原始型別轉換

| 操作 | 方法 |
|---|---|
| `String` → `FHIRPrimitive<FHIRString>` | `.fhirString` |
| `String` → `FHIRPrimitive<FHIRURI>` | `.fhirURI`（Optional） |
| `FHIRPrimitive<FHIRString>` → `String?` | `.string` |
| `FHIRPrimitive<FHIRURI>` → `String?` | `.absoluteString` |

### 名稱衝突

- `Bundle` 與 `Foundation.Bundle` 衝突，一律使用 `ModelsR4.Bundle`

---

## TW Core IG 關鍵知識

### Patient / Practitioner 識別碼 system URL

| 識別碼 | identifier.system | type code |
|---|---|---|
| 身分證字號 | `http://www.moi.gov.tw` | `NNxxx` + suffix `TWN` |
| 護照號碼 | `http://hl7.org/fhir/sid/passport-TWN` | `PPN` |
| 居留證號碼 | `http://www.immigration.gov.tw` | `PRC` |
| 病歷號 | 醫院自訂 | `MR` |
| 醫師執照 | 核發機構自訂 | `MD` |

type.coding.system 固定為 `http://terminology.hl7.org/CodeSystem/v2-0203`

### Organization 子型別識別碼系統

| 子型別 | identifier.type.coding.system | code |
|---|---|---|
| co（公司）| `https://twcore.mohw.gov.tw/ig/twcore/CodeSystem/v2-0203` | `UBN` |
| govt（政府）| 同上 | `GOI` |
| hosp（醫院）| `http://terminology.hl7.org/CodeSystem/v2-0203` | `PRN` |

### 實作新 Resource 的 checklist

1. 查 FSH：`ITRI-BDL-D/MOHW_TWCoreIG` → `input/fsh/profiles/profiles_xxx.fsh`
2. 記錄：Profile URL、identifier.system（若有）、extension URL（若有）
3. 區分欄位遵從度：
   - **SHALL** → namespace API + validateTWCore() 驗證
   - **SHOULD** → namespace API（不加入 validation）
   - **MAY** → 視需求決定是否提供 API
4. 在 `TWCoreURL` 補上相關常數
5. 建立 `XXX+TWCore.swift`（namespace + validateTWCore）
6. 在 `Tests/` 補測試（SHALL 驗證失敗、SHALL 驗證通過、SHOULD 欄位讀寫）
7. `swift test` 全綠才算完成

---

## 檔案組織

```
Sources/TWCoreFHIRModels/
├── Constants/TWCoreURL.swift          # 所有 TW Core IG URL 常數
├── Internal/FHIRHelpers.swift         # makeIdentifier / declareProfile
├── Extensions/
│   ├── Primitives/String+FHIR.swift
│   └── Resources/                     # 33 個 XXX+TWCore.swift
└── Validators/TWCoreValidationError.swift

Tests/TWCoreFHIRModelsTests/           # 7 個測試檔，206 tests
```

---

## 參考資源

- [TW Core IG 官方網站](https://twcore.mohw.gov.tw/ig/twcore/)
- [TW Core IG FSH 原始碼（ITRI fork）](https://github.com/ITRI-BDL-D/MOHW_TWCoreIG)
- [Apple FHIRModels GitHub](https://github.com/apple/FHIRModels)
- [HL7 v2-0203 Identifier Type Codes](http://terminology.hl7.org/CodeSystem/v2-0203)
