import Foundation
import ModelsR4

// MARK: - Namespace 注入

extension Observation {
    public var twCore: TWCoreObservationNamespace {
        get { TWCoreObservationNamespace(self) }
        set { self = newValue.observation }
    }
}

// MARK: - TWCoreObservationNamespace

public struct TWCoreObservationNamespace {

    var observation: Observation

    public init(_ observation: Observation) {
        self.observation = observation
    }

    // MARK: 分類

    /// 是否已包含生命徵象分類（vital-signs）
    public var hasVitalSignsCategory: Bool {
        hasCategory(code: TWCoreURL.ObservationCategory.vitalSignsCode)
    }

    /// 是否已包含實驗室分類（laboratory）
    public var hasLaboratoryCategory: Bool {
        hasCategory(code: TWCoreURL.ObservationCategory.laboratoryCode)
    }

    /// 加入生命徵象分類 category（若尚未存在）
    public mutating func setVitalSignsCategory() {
        setCategory(code: TWCoreURL.ObservationCategory.vitalSignsCode, display: "Vital Signs")
    }

    /// 加入實驗室分類 category（若尚未存在）
    public mutating func setLaboratoryCategory() {
        setCategory(code: TWCoreURL.ObservationCategory.laboratoryCode, display: "Laboratory")
    }

    // MARK: Profile — 通用

    /// 宣告生命徵象 Profile
    public mutating func declareVitalSignsProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.observationVitalSigns, on: &observation.meta)
    }

    /// 宣告實驗室結果 Profile
    public mutating func declareLaboratoryResultProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.observationLaboratoryResult, on: &observation.meta)
    }

    // MARK: Profile — 生命徵象子型別

    /// 宣告血壓 Profile（LOINC 85354-9）
    public mutating func declareBloodPressureProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.observationBloodPressure, on: &observation.meta)
    }

    /// 宣告 BMI Profile（LOINC 39156-5）
    public mutating func declareBMIProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.observationBMI, on: &observation.meta)
    }

    /// 宣告身高 Profile（LOINC 8302-2）
    public mutating func declareBodyHeightProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.observationBodyHeight, on: &observation.meta)
    }

    /// 宣告體溫 Profile（LOINC 8310-5）
    public mutating func declareBodyTemperatureProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.observationBodyTemperature, on: &observation.meta)
    }

    /// 宣告體重 Profile（LOINC 29463-7）
    public mutating func declareBodyWeightProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.observationBodyWeight, on: &observation.meta)
    }

    /// 宣告心跳 Profile（LOINC 8867-4）
    public mutating func declareHeartRateProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.observationHeartRate, on: &observation.meta)
    }

    /// 宣告呼吸速率 Profile（LOINC 9279-1）
    public mutating func declareRespiratoryRateProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.observationRespiratoryRate, on: &observation.meta)
    }

    /// 宣告脈搏血氧 Profile（LOINC 59408-5）
    public mutating func declarePulseOximetryProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.observationPulseOximetry, on: &observation.meta)
    }

    /// 宣告平均血壓 Profile（LOINC 96607-7）
    public mutating func declareAverageBloodPressureProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.observationAverageBloodPressure, on: &observation.meta)
    }

    /// 宣告頭圍 Profile（LOINC 9843-4）
    public mutating func declareHeadCircumferenceProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.observationHeadCircumference, on: &observation.meta)
    }

    /// 宣告兒童 BMI 百分位 Profile（LOINC 59576-9）
    public mutating func declarePediatricBMIforAgeProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.observationPediatricBMIforAge, on: &observation.meta)
    }

    /// 宣告兒童頭圍百分位 Profile（LOINC 8289-1）
    public mutating func declarePediatricHeadCircumferenceProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.observationPediatricHeadCircumference, on: &observation.meta)
    }

    // MARK: Profile — 其他觀察子型別

    /// 宣告吸菸狀態 Profile
    public mutating func declareSmokingStatusProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.observationSmokingStatus, on: &observation.meta)
    }

    /// 宣告職業 Profile（LOINC 11341-5）
    public mutating func declareOccupationProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.observationOccupation, on: &observation.meta)
    }

    /// 宣告臨床檢驗檢查 Profile
    public mutating func declareClinicalResultProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.observationClinicalResult, on: &observation.meta)
    }

    /// 宣告治療介入偏好 Profile（LOINC 75773-2）
    public mutating func declareTreatmentInterventionPreferenceProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.observationTreatmentInterventionPreference, on: &observation.meta)
    }

    /// 宣告照護經驗偏好 Profile（LOINC 95541-9）
    public mutating func declareCareExperiencePreferenceProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.observationCareExperiencePreference, on: &observation.meta)
    }

    // MARK: Profile — 1.0.0 新增子型別

    /// 宣告心電圖 Profile（LOINC 11524-6）
    public mutating func declareECGProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.observationECG, on: &observation.meta)
    }

    /// 宣告兒童體重身高百分位 Profile（LOINC 77606-2）
    public mutating func declarePediatricWeightHeightProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.observationPediatricWeightHeight, on: &observation.meta)
    }

    /// 宣告懷孕意向 Profile（LOINC 86645-9）
    public mutating func declarePregnancyIntentProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.observationPregnancyIntent, on: &observation.meta)
    }

    /// 宣告懷孕狀態 Profile（LOINC 82810-3）
    public mutating func declarePregnancyStatusProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.observationPregnancyStatus, on: &observation.meta)
    }

    /// 宣告篩檢評估 Profile
    public mutating func declareScreeningAssessmentProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.observationScreeningAssessment, on: &observation.meta)
    }

    /// 宣告性取向 Profile（LOINC 76690-7）
    public mutating func declareSexualOrientationProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.observationSexualOrientation, on: &observation.meta)
    }

    /// 宣告簡單觀察 Profile
    public mutating func declareSimpleObservationProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.observationSimple, on: &observation.meta)
    }
}

// MARK: - Validation

extension Observation {
    /// 驗證是否符合 TW Core Observation VitalSigns 規範
    ///
    /// 檢查項目：
    /// - category 包含 vital-signs
    /// - `effective` 1..1
    public func validateTWCoreVitalSigns() -> Result<Void, TWCoreValidationError> {
        guard twCore.hasVitalSignsCategory else {
            return .failure(.missingRequiredField("Observation.category[vital-signs]"))
        }
        guard effective != nil else {
            return .failure(.missingRequiredField("Observation.effective"))
        }
        return .success(())
    }

    /// 驗證是否符合 TW Core Observation LaboratoryResult 規範
    ///
    /// 檢查項目：
    /// - category 包含 laboratory
    /// - `effective` 1..1
    /// - `code.coding` 包含 LOINC
    public func validateTWCoreLaboratoryResult() -> Result<Void, TWCoreValidationError> {
        guard twCore.hasLaboratoryCategory else {
            return .failure(.missingRequiredField("Observation.category[laboratory]"))
        }
        guard effective != nil else {
            return .failure(.missingRequiredField("Observation.effective"))
        }
        let hasLOINC = code.coding?.contains {
            $0.system?.value?.url.absoluteString == TWCoreURL.ObservationCode.loinc
        } ?? false
        guard hasLOINC else {
            return .failure(.missingRequiredField("Observation.code.coding[LOINC]"))
        }
        return .success(())
    }
}

// MARK: - Private Helpers

private extension TWCoreObservationNamespace {

    func hasCategory(code: String) -> Bool {
        observation.category?.contains { concept in
            concept.coding?.contains {
                $0.system?.value?.url.absoluteString == TWCoreURL.ObservationCategory.system
                && $0.code?.value?.string == code
            } ?? false
        } ?? false
    }

    mutating func setCategory(code: String, display: String) {
        guard !hasCategory(code: code) else { return }
        let coding = Coding(
            code: code.fhirString,
            display: display.fhirString,
            system: TWCoreURL.ObservationCategory.system.fhirURI
        )
        let category = CodeableConcept(coding: [coding])
        if observation.category == nil { observation.category = [category] }
        else { observation.category?.append(category) }
    }
}
