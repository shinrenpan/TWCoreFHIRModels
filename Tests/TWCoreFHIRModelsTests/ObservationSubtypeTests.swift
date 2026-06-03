import Testing
import ModelsR4
@testable import TWCoreFHIRModels

// MARK: - Helpers

private func makeObs() -> Observation {
    Observation(code: CodeableConcept(), status: FHIRPrimitive(.final))
}

// MARK: - 生命徵象子型別

@Suite("Observation 生命徵象子型別 Profile")
struct ObservationVitalSignsSubtypeTests {

    @Test("血壓 Profile URL 正確")
    func bloodPressureProfile() {
        var obs = makeObs()
        obs.twCore.declareBloodPressureProfile()
        #expect(obs.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.observationBloodPressure)
    }

    @Test("BMI Profile URL 正確")
    func bmiProfile() {
        var obs = makeObs()
        obs.twCore.declareBMIProfile()
        #expect(obs.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.observationBMI)
    }

    @Test("身高 Profile URL 正確")
    func bodyHeightProfile() {
        var obs = makeObs()
        obs.twCore.declareBodyHeightProfile()
        #expect(obs.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.observationBodyHeight)
    }

    @Test("體溫 Profile URL 正確")
    func bodyTemperatureProfile() {
        var obs = makeObs()
        obs.twCore.declareBodyTemperatureProfile()
        #expect(obs.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.observationBodyTemperature)
    }

    @Test("體重 Profile URL 正確")
    func bodyWeightProfile() {
        var obs = makeObs()
        obs.twCore.declareBodyWeightProfile()
        #expect(obs.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.observationBodyWeight)
    }

    @Test("心跳 Profile URL 正確")
    func heartRateProfile() {
        var obs = makeObs()
        obs.twCore.declareHeartRateProfile()
        #expect(obs.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.observationHeartRate)
    }

    @Test("呼吸速率 Profile URL 正確")
    func respiratoryRateProfile() {
        var obs = makeObs()
        obs.twCore.declareRespiratoryRateProfile()
        #expect(obs.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.observationRespiratoryRate)
    }

    @Test("脈搏血氧 Profile URL 正確")
    func pulseOximetryProfile() {
        var obs = makeObs()
        obs.twCore.declarePulseOximetryProfile()
        #expect(obs.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.observationPulseOximetry)
    }

    @Test("平均血壓 Profile URL 正確")
    func averageBloodPressureProfile() {
        var obs = makeObs()
        obs.twCore.declareAverageBloodPressureProfile()
        #expect(obs.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.observationAverageBloodPressure)
    }

    @Test("頭圍 Profile URL 正確")
    func headCircumferenceProfile() {
        var obs = makeObs()
        obs.twCore.declareHeadCircumferenceProfile()
        #expect(obs.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.observationHeadCircumference)
    }

    @Test("兒童 BMI 百分位 Profile URL 正確")
    func pediatricBMIforAgeProfile() {
        var obs = makeObs()
        obs.twCore.declarePediatricBMIforAgeProfile()
        #expect(obs.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.observationPediatricBMIforAge)
    }

    @Test("兒童頭圍百分位 Profile URL 正確")
    func pediatricHeadCircumferenceProfile() {
        var obs = makeObs()
        obs.twCore.declarePediatricHeadCircumferenceProfile()
        #expect(obs.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.observationPediatricHeadCircumference)
    }
}

// MARK: - 其他觀察子型別

@Suite("Observation 其他子型別 Profile")
struct ObservationOtherSubtypeTests {

    @Test("吸菸狀態 Profile URL 正確")
    func smokingStatusProfile() {
        var obs = makeObs()
        obs.twCore.declareSmokingStatusProfile()
        #expect(obs.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.observationSmokingStatus)
    }

    @Test("職業 Profile URL 正確")
    func occupationProfile() {
        var obs = makeObs()
        obs.twCore.declareOccupationProfile()
        #expect(obs.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.observationOccupation)
    }

    @Test("臨床檢驗檢查 Profile URL 正確")
    func clinicalResultProfile() {
        var obs = makeObs()
        obs.twCore.declareClinicalResultProfile()
        #expect(obs.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.observationClinicalResult)
    }

    @Test("治療介入偏好 Profile URL 正確")
    func treatmentInterventionPreferenceProfile() {
        var obs = makeObs()
        obs.twCore.declareTreatmentInterventionPreferenceProfile()
        #expect(obs.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.observationTreatmentInterventionPreference)
    }

    @Test("照護經驗偏好 Profile URL 正確")
    func careExperiencePreferenceProfile() {
        var obs = makeObs()
        obs.twCore.declareCareExperiencePreferenceProfile()
        #expect(obs.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.observationCareExperiencePreference)
    }
}

// MARK: - LOINC 常數驗證

@Suite("VitalSignsLOINC 常數")
struct VitalSignsLOINCTests {

    @Test("血壓 LOINC 代碼正確")
    func bloodPressureLOINC() {
        #expect(TWCoreURL.VitalSignsLOINC.bloodPressure == "85354-9")
    }

    @Test("BMI LOINC 代碼正確")
    func bmiLOINC() {
        #expect(TWCoreURL.VitalSignsLOINC.bmi == "39156-5")
    }

    @Test("體重 LOINC 代碼正確")
    func bodyWeightLOINC() {
        #expect(TWCoreURL.VitalSignsLOINC.bodyWeight == "29463-7")
    }

    @Test("心跳 LOINC 代碼正確")
    func heartRateLOINC() {
        #expect(TWCoreURL.VitalSignsLOINC.heartRate == "8867-4")
    }

    @Test("脈搏血氧 LOINC 代碼正確")
    func pulseOximetryLOINC() {
        #expect(TWCoreURL.VitalSignsLOINC.pulseOximetry == "59408-5")
    }
}

// MARK: - 1.0.0 新增子型別

@Suite("Observation 1.0.0 新增子型別 Profile")
struct ObservationNewSubtypeTests {

    @Test("心電圖 Profile URL 正確")
    func ecgProfile() {
        var obs = makeObs()
        obs.twCore.declareECGProfile()
        #expect(obs.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.observationECG)
    }

    @Test("兒童體重身高百分位 Profile URL 正確")
    func pediatricWeightHeightProfile() {
        var obs = makeObs()
        obs.twCore.declarePediatricWeightHeightProfile()
        #expect(obs.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.observationPediatricWeightHeight)
    }

    @Test("懷孕意向 Profile URL 正確")
    func pregnancyIntentProfile() {
        var obs = makeObs()
        obs.twCore.declarePregnancyIntentProfile()
        #expect(obs.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.observationPregnancyIntent)
    }

    @Test("懷孕狀態 Profile URL 正確")
    func pregnancyStatusProfile() {
        var obs = makeObs()
        obs.twCore.declarePregnancyStatusProfile()
        #expect(obs.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.observationPregnancyStatus)
    }

    @Test("篩檢評估 Profile URL 正確")
    func screeningAssessmentProfile() {
        var obs = makeObs()
        obs.twCore.declareScreeningAssessmentProfile()
        #expect(obs.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.observationScreeningAssessment)
    }

    @Test("性取向 Profile URL 正確")
    func sexualOrientationProfile() {
        var obs = makeObs()
        obs.twCore.declareSexualOrientationProfile()
        #expect(obs.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.observationSexualOrientation)
    }

    @Test("簡單觀察 Profile URL 正確")
    func simpleObservationProfile() {
        var obs = makeObs()
        obs.twCore.declareSimpleObservationProfile()
        #expect(obs.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.observationSimple)
    }

    @Test("1.0.0 新增 LOINC 常數正確")
    func newLOINCConstants() {
        #expect(TWCoreURL.VitalSignsLOINC.ecg == "11524-6")
        #expect(TWCoreURL.VitalSignsLOINC.pediatricWeightHeight == "77606-2")
        #expect(TWCoreURL.VitalSignsLOINC.pregnancyIntent == "86645-9")
        #expect(TWCoreURL.VitalSignsLOINC.pregnancyStatus == "82810-3")
        #expect(TWCoreURL.VitalSignsLOINC.sexualOrientation == "76690-7")
    }
}

// MARK: - 多 Profile 並存

@Suite("Observation 多 Profile 並存")
struct ObservationMultipleProfileTests {

    @Test("可同時宣告子型別與 VitalSigns 基底 Profile")
    func multipleProfiles() {
        var obs = makeObs()
        obs.twCore.declareVitalSignsProfile()
        obs.twCore.declareBloodPressureProfile()
        let profileURLs = obs.meta?.profile?.compactMap { $0.value?.url.absoluteString } ?? []
        #expect(profileURLs.contains(TWCoreURL.Profile.observationVitalSigns))
        #expect(profileURLs.contains(TWCoreURL.Profile.observationBloodPressure))
        #expect(profileURLs.count == 2)
    }

    @Test("重複宣告同一 Profile 不重複加入")
    func idempotentProfile() {
        var obs = makeObs()
        obs.twCore.declareBloodPressureProfile()
        obs.twCore.declareBloodPressureProfile()
        let count = obs.meta?.profile?.filter {
            $0.value?.url.absoluteString == TWCoreURL.Profile.observationBloodPressure
        }.count ?? 0
        #expect(count == 1)
    }
}
