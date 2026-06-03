# TWCoreFHIRModels

[![CI](https://github.com/shinrenpan/TWCoreFHIRModels/actions/workflows/ci.yml/badge.svg)](https://github.com/shinrenpan/TWCoreFHIRModels/actions/workflows/ci.yml)
[![Swift](https://img.shields.io/badge/Swift-6.2-orange)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-16%2B-blue)](https://developer.apple.com/ios/)
[![TW Core IG](https://img.shields.io/badge/TW%20Core%20IG-1.0.0-blue)](https://twcore.mohw.gov.tw/ig/twcore/)
[![FHIR](https://img.shields.io/badge/FHIR-R4%204.0.1-lightgrey)](https://hl7.org/fhir/R4/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

為台灣 iOS / Swift 開發者設計的 **TW Core IG** 擴充庫。

---

## Why

直接使用 [Apple FHIRModels](https://github.com/apple/FHIRModels) 產出符合台灣衛福部規範的 FHIR 資料，需要手動查閱 TW Core IG 規格、自行 hardcode Profile URL 與 CodeSystem URL、以及自己撰寫必填欄位驗證邏輯。

本套件在 `ModelsR4` 之上提供強型別的 `.twCore` namespace API，讓你直接操作台灣特定欄位，並透過 `validateTWCore()` 驗證 SHALL 必填欄位是否齊全。

```swift
// 沒有本套件
var id = Identifier()
id.system = FHIRPrimitive(FHIRURI(string: "http://www.moi.gov.tw"))
id.value = FHIRPrimitive(FHIRString("A123456789"))
// ... 還要自己組 type、suffix extension、validate ...

// 有本套件
patient.twCore.idCardNumber = "A123456789"
patient.validateTWCore()    // 自動驗 SHALL 欄位
```

---

## How

### 安裝

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/shinrenpan/TWCoreFHIRModels.git", from: "1.0.0")
],
targets: [
    .target(name: "YourTarget", dependencies: ["TWCoreFHIRModels"])
]
```

### 快速開始

```swift
import ModelsR4
import TWCoreFHIRModels

// 1. 建立資源
var patient = Patient()

// 2. 填入台灣專屬欄位
patient.twCore.idCardNumber = "A123456789"
patient.gender    = FHIRPrimitive(.female)
patient.birthDate = FHIRPrimitive(FHIRDate(year: 1990, month: 6, day: 15))

// 3. 宣告 TW Core Profile
patient.twCore.declareProfile()
// → meta.profile = ["https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Patient-twcore"]

// 4. 驗證 SHALL 欄位
switch patient.validateTWCore() {
case .success:
    // 送出 FHIR 請求
case .failure(let error):
    print(error)  // 缺少哪個必填欄位
}
```

### 遵從度策略

本套件依 FHIR RFC 2119 分層處理：

| 動詞 | 本套件行為 |
|---|---|
| **SHALL**（必填）| `validateTWCore()` 驗證，缺失回傳 `.failure` |
| **SHOULD**（建議）| Namespace 提供 API，不影響 validation 結果 |
| **MAY**（可選）| 視需求提供 |

---

## 支援的 Resource

TW Core IG 1.0.0 全部 33 個 Resource 均已實作。

| Resource | validateTWCore() | 說明 |
|---|:---:|---|
| `Patient` | ✅ | 身分證／護照／居留證／病歷號、姓名 |
| `Practitioner` | ✅ | 身分證／護照／居留證／醫師執照 |
| `Organization` | ✅ | 名稱、識別碼；含公司／政府／醫院科別子型別 |
| `Encounter` | ✅ | 就診識別碼 |
| `Condition` | ✅ | clinicalStatus、category |
| `AllergyIntolerance` | ✅ | code |
| `Observation` | ✅ | VitalSigns / LaboratoryResult；含 24 種子型別 |
| `Address` | — | 村里／鄰／段／巷／弄／號／樓／室 |
| `Medication` | ✅ | FDA／NHI／RxNorm／ATC／SNOMED CT |
| `MedicationRequest` | ✅ | 藥品代碼、識別碼 |
| `MedicationDispense` | ✅ | subject、藥品代碼、識別碼 |
| `MedicationStatement` | ✅ | 藥品代碼、識別碼 |
| `Procedure` | ✅ | ICD-10-PCS／SNOMED CT |
| `DiagnosticReport` | ✅ | LOINC／健保服務碼／ICD-10-PCS |
| `Immunization` | ✅ | CVX／NDC 疫苗代碼 |
| `Coverage` | ✅ | relationship、memberId／subscriberId |
| `Specimen` | ✅ | 識別碼 |
| `Location` | ✅ | 名稱、識別碼 |
| `PractitionerRole` | ✅ | 科別代碼、識別碼 |
| `RelatedPerson` | ✅ | active、name or relationship |
| `Bundle` | ✅ | 含文件包／訊息包子型別 |
| `Composition` | ✅ | 臨床文件組成 |
| `DocumentReference` | ✅ | 文件參照 |
| `MessageHeader` | ✅ | 訊息標頭 |
| `Provenance` | ✅ | 資料來源追蹤 |
| `CarePlan` | ✅ | category[AssessPlan] |
| `CareTeam` | ✅ | participant、role、member |
| `Goal` | ✅ | 照護目標 |
| `ServiceRequest` | ✅ | code |
| `ImagingStudy` | ✅ | 影像檢查 |
| `Media` | ✅ | 媒體資料 |
| `Device` | ✅ | 裝置 |
| `QuestionnaireResponse` | ✅ | 問卷回覆 |

各 Resource 的完整 API 說明請見 **[Wiki](https://github.com/shinrenpan/TWCoreFHIRModels/wiki)**。

---

## 版本相容性

| 項目 | 版本 |
|---|---|
| 依據規範 | [TW Core IG 1.0.0](https://twcore.mohw.gov.tw/ig/twcore/)（2025-12-10） |
| FHIR | R4（4.0.1） |
| Apple FHIRModels | 0.9.2+ |
| Swift | 6.2+ |
| iOS / macOS / watchOS / tvOS | 16+ / 13+ / 9+ / 16+ |

### 已知限制

| 限制 | 說明 |
|---|---|
| `validateTWCore()` 只驗 SHALL | SHOULD／MAY 欄位不納入驗證 |
| 不驗值集合法性 | LOINC 代碼是否存在於官方值集，本套件不檢查 |
| Profile URL 與 IG 版綁定 | 對應 TW Core IG 1.0.0；升版時請確認相容性 |

---

## 參考資源

- [TW Core IG 官方網站](https://twcore.mohw.gov.tw/ig/twcore/)
- [Apple FHIRModels](https://github.com/apple/FHIRModels)
- [HL7 FHIR R4](https://hl7.org/fhir/R4/)
