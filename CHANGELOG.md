# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] - 2026-06-03

### Added

- **TW Core IG 1.0.0 完整實作**：全部 33 個 Resource 均提供 `.twCore` namespace API
- **`validateTWCore()`**：依 FHIR RFC 2119 驗證 SHALL 必填欄位，缺失回傳 `.failure(TWCoreValidationError)`
- **`declareProfile()`**：自動設定 `meta.profile` 為對應 TW Core IG Profile URL

#### 支援的 Resource

| Resource | validateTWCore() |
|---|:---:|
| Patient | ✅ |
| Practitioner | ✅ |
| PractitionerRole | ✅ |
| Organization（含 Company / Government / Hospital 子型別）| ✅ |
| Encounter | ✅ |
| Condition | ✅ |
| AllergyIntolerance | ✅ |
| Observation（含 24 種 VitalSigns / LaboratoryResult 子型別）| ✅ |
| Medication | ✅ |
| MedicationRequest | ✅ |
| MedicationDispense | ✅ |
| MedicationStatement | ✅ |
| Procedure | ✅ |
| DiagnosticReport | ✅ |
| Immunization | ✅ |
| Coverage | ✅ |
| Specimen | ✅ |
| Location | ✅ |
| RelatedPerson | ✅ |
| Bundle（含 Document / Message 子型別）| ✅ |
| Composition | ✅ |
| DocumentReference | ✅ |
| MessageHeader | ✅ |
| Provenance | ✅ |
| CarePlan | ✅ |
| CareTeam | ✅ |
| Goal | ✅ |
| ServiceRequest | ✅ |
| ImagingStudy | ✅ |
| Media | ✅ |
| Device | ✅ |
| QuestionnaireResponse | ✅ |
| Address | — |

#### 常數與工具

- `TWCoreURL` enum：所有 Profile URL、CodeSystem URL、ValueSet URL 常數
- `makeIdentifier()`、`declareProfile()` 共用 helpers（`Internal/FHIRHelpers.swift`）
- `String+FHIR`：`.fhirString`、`.fhirURI` 便利轉換

#### 測試

- 206 unit tests 涵蓋所有 Resource 的 SHALL 驗證（成功 / 失敗路徑）及 SHOULD 欄位讀寫

---

[1.0.0]: https://github.com/shinrenpan/TWCoreFHIRModels/releases/tag/1.0.0
