import Foundation

/// TW Core IG 所有官方 URL 常數
public enum TWCoreURL {

    // MARK: - Profile URL

    /// FHIR Profile URL
    public enum Profile {
        public static let patient             = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Patient-twcore"
        public static let practitioner        = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Practitioner-twcore"
        public static let organization        = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Organization-twcore"
        public static let encounter           = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Encounter-twcore"
        public static let condition           = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Condition-twcore"
        public static let allergyIntolerance  = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/AllergyIntolerance-twcore"
        public static let observationVitalSigns       = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Observation-vitalSigns-twcore"
        public static let observationLaboratoryResult = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Observation-laboratoryResult-twcore"
        public static let addressTW           = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Address-tw"
        public static let medication          = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Medication-twcore"
        public static let medicationRequest   = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/MedicationRequest-twcore"
        public static let medicationDispense  = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/MedicationDispense-twcore"
        public static let medicationStatement = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/MedicationStatement-twcore"
        public static let procedure           = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Procedure-twcore"
        public static let diagnosticReport    = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/DiagnosticReport-twcore"
        public static let immunization        = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Immunization-twcore"
        public static let coverage            = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Coverage-twcore"
        public static let specimen            = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Specimen-twcore"
        public static let location            = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Location-twcore"
        public static let practitionerRole    = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/PractitionerRole-twcore"
        public static let relatedPerson           = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/RelatedPerson-twcore"
        public static let bundle                  = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Bundle-twcore"
        public static let composition             = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Composition-twcore"
        public static let documentReference       = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/DocumentReference-twcore"
        public static let messageHeader           = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/MessageHeader-twcore"
        public static let provenance              = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Provenance-twcore"
        public static let carePlan                = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/CarePlan-twcore"
        public static let careTeam                = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/CareTeam-twcore"
        public static let goal                    = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Goal-twcore"
        public static let serviceRequest          = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/ServiceRequest-twcore"
        public static let imagingStudy            = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/ImagingStudy-twcore"
        public static let media                   = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Media-twcore"
        public static let device                  = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Device-twcore"
        public static let questionnaireResponse   = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/QuestionnaireResponse-twcore"

        // MARK: Observation 子型別
        public static let observationBloodPressure           = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Observation-bloodPressure-twcore"
        public static let observationBMI                     = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Observation-bmi-twcore"
        public static let observationBodyHeight              = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Observation-body-height-twcore"
        public static let observationBodyTemperature         = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Observation-body-temperature-twcore"
        public static let observationBodyWeight              = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Observation-body-weight-twcore"
        public static let observationHeartRate               = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Observation-heart-rate-twcore"
        public static let observationRespiratoryRate         = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Observation-respiratory-rate-twcore"
        public static let observationPulseOximetry           = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Observation-pulse-oximetry-twcore"
        public static let observationAverageBloodPressure    = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Observation-averageBloodPressure-twcore"
        public static let observationHeadCircumference       = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Observation-head-circumference-twcore"
        public static let observationPediatricBMIforAge      = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Observation-pediatric-bmi-age-twcore"
        public static let observationPediatricHeadCircumference = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Observation-pediatric-head-circumference-twcore"
        public static let observationSmokingStatus           = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Observation-smoking-status-twcore"
        public static let observationOccupation              = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Observation-occupation-twcore"
        public static let observationClinicalResult          = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Observation-clinical-result-twcore"
        public static let observationTreatmentInterventionPreference = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Observation-treatment-intervention-preference-twcore"
        public static let observationCareExperiencePreference = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Observation-careExperiencePreference-twcore"

        // MARK: Observation 子型別（1.0.0 新增）
        public static let observationECG                          = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Observation-ecg-twcore"
        public static let observationPediatricWeightHeight        = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Observation-pediatric-weight-height-twcore"
        public static let observationPregnancyIntent              = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Observation-pregnancy-intent-twcore"
        public static let observationPregnancyStatus              = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Observation-pregnancy-status-twcore"
        public static let observationScreeningAssessment          = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Observation-screening-assessment-twcore"
        public static let observationSexualOrientation            = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Observation-sexual-orientation-twcore"
        public static let observationSimple                       = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Observation-simple-twcore"

        // MARK: Bundle 子型別（1.0.0 新增）
        public static let bundleDocument = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Bundle-document-twcore"
        public static let bundleMessage  = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Bundle-message-twcore"

        // MARK: Organization 子型別（1.0.0 新增）
        public static let organizationCompany     = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Organization-co-twcore"
        public static let organizationGovernment  = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Organization-govt-twcore"
        public static let organizationHospital    = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Organization-hosp-twcore"
    }

    // MARK: - CarePlan Category Code System URL

    /// CarePlan 照護計畫類別代碼
    public enum CarePlanCategory {
        public static let system      = "https://twcore.mohw.gov.tw/ig/twcore/CodeSystem/careplan-category-tw"
        public static let assessPlan  = "assess-plan"
    }

    // MARK: - Identifier System URL

    /// Identifier system URL（identifier.system 欄位填入此處）
    public enum IdentifierSystem {
        /// 身分證字號 — 內政部
        public static let idCard       = "http://www.moi.gov.tw"
        /// 護照號碼 — 外交部
        public static let passport     = "http://hl7.org/fhir/sid/passport-TWN"
        /// 居留證號碼 — 移民署
        public static let residentCard = "http://www.immigration.gov.tw"
    }

    // MARK: - Identifier Type

    /// Identifier type.coding.system（固定使用 HL7 v2-0203）
    public enum IdentifierType {
        public static let system           = "http://terminology.hl7.org/CodeSystem/v2-0203"
        /// 身分證字號 type code（NNxxx，xxx 為 ISO 3166 國碼，台灣為 TWN）
        public static let idCardCode       = "NNxxx"
        /// 護照 type code
        public static let passportCode     = "PPN"
        /// 居留證 type code
        public static let residentCardCode = "PRC"
        /// 病歷號 type code
        public static let medicalRecordCode = "MR"
        /// 醫師執照 type code
        public static let practitionerLicenseCode = "MD"
    }

    // MARK: - Extension URL

    /// Extension URL
    public enum Extension {
        /// 年齡擴充
        public static let personAge        = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/person-age"
        /// 國籍擴充
        public static let nationality      = "http://hl7.org/fhir/StructureDefinition/patient-nationality"
        /// Identifier suffix（用於 NNxxx code 的國碼後綴，如 TWN）
        public static let identifierSuffix = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/identifier-suffix"
    }

    // MARK: - Address Extension URL

    /// TW Core 台灣地址細部元素 Extension URL
    public enum AddressExtension {
        /// 郵遞區號（CodeableConcept，附加在 postalCode primitive 上）
        public static let postalCode    = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/tw-postal-code"
        /// 村里
        public static let village       = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/tw-village"
        /// 鄰
        public static let neighborhood  = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/tw-neighborhood"
        /// 段
        public static let section       = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/tw-section"
        /// 巷
        public static let lane          = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/tw-lane"
        /// 弄
        public static let alley         = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/tw-alley"
        /// 號
        public static let number        = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/tw-number"
        /// 樓
        public static let floor         = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/tw-floor"
        /// 室
        public static let room          = "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/tw-room"
    }

    // MARK: - Observation

    /// Observation 分類相關常數
    public enum ObservationCategory {
        /// HL7 observation-category code system
        public static let system          = "http://terminology.hl7.org/CodeSystem/observation-category"
        /// 生命徵象
        public static let vitalSignsCode  = "vital-signs"
        /// 實驗室檢驗
        public static let laboratoryCode  = "laboratory"
    }

    // MARK: - Medication Code System URL

    /// 藥品代碼 system URL
    public enum MedicationCode {
        /// 台灣食品藥物管理署 (FDA) 藥品許可證代碼
        public static let fda       = "https://twcore.mohw.gov.tw/ig/twcore/CodeSystem/medication-fda-tw"
        /// 台灣健保署健保用藥品項代碼
        public static let nhi       = "https://twcore.mohw.gov.tw/ig/twcore/CodeSystem/medication-nhi-tw"
        /// 台灣健保署中藥用藥品項代碼
        public static let nhiChHerb = "https://twcore.mohw.gov.tw/ig/twcore/CodeSystem/nhi-medication-ch-herb-tw"
        /// RxNorm (美國 UMLS)
        public static let rxNorm    = "http://www.nlm.nih.gov/research/umls/rxnorm"
        /// 台灣食藥署 ATC 碼（含未被 WHO ATC 定義之代碼）
        public static let atcTW     = "https://twcore.mohw.gov.tw/ig/twcore/CodeSystem/medcation-atc-tw"
        /// SNOMED CT
        public static let snomedCT  = "http://snomed.info/sct"
        /// 健保署給藥途徑代碼
        public static let path      = "https://twcore.mohw.gov.tw/ig/twcore/CodeSystem/medication-path-tw"
    }

    // MARK: - Procedure / DiagnosticReport Code System URL

    /// ICD-10-PCS 及相關處置代碼 system URL
    public enum ProcedureCode {
        /// 臺灣健保署 2014 年中文版 ICD-10-PCS
        public static let icd10pcs2014 = "https://twcore.mohw.gov.tw/ig/twcore/CodeSystem/icd-10-pcs-2014-tw"
        /// 臺灣健保署 2021 年中文版 ICD-10-PCS
        public static let icd10pcs2021 = "https://twcore.mohw.gov.tw/ig/twcore/CodeSystem/icd-10-pcs-2021-tw"
        /// 臺灣健保署 2023 年中文版 ICD-10-PCS
        public static let icd10pcs2023 = "https://twcore.mohw.gov.tw/ig/twcore/CodeSystem/icd-10-pcs-2023-tw"
        /// SNOMED CT 處置代碼
        public static let snomedCT     = "http://snomed.info/sct"
        /// LOINC 處置代碼
        public static let loinc        = "http://loinc.org"
    }

    // MARK: - PractitionerRole Specialty Code System URL

    /// 醫師科別代碼 system URL
    public enum SpecialtyCode {
        /// 健保署門診科別代碼
        public static let consultationDepartment = "https://twcore.mohw.gov.tw/ig/twcore/CodeSystem/medical-consultation-department-tw"
        /// 健保署住診科別代碼
        public static let treatmentDepartment    = "https://twcore.mohw.gov.tw/ig/twcore/CodeSystem/medical-treatment-department-tw"
        /// SNOMED CT 科別代碼
        public static let snomedCT               = "http://snomed.info/sct"
    }

    // MARK: - Vaccine Code System URL

    /// 疫苗代碼 system URL
    public enum VaccineCode {
        /// CVX 疫苗代碼（HL7）
        public static let cvx = "http://hl7.org/fhir/sid/cvx"
        /// NDC 藥品代碼（美國）
        public static let ndc = "http://hl7.org/fhir/sid/ndc"
    }

    /// Observation code system URL
    public enum ObservationCode {
        /// LOINC
        public static let loinc              = "http://loinc.org"
        /// 台灣健保醫療服務給付項目代碼
        public static let twLaboratoryCategory = "https://twcore.mohw.gov.tw/ig/twcore/CodeSystem/medical-service-payment-tw"
    }

    // MARK: - Vital Signs / Observation Subtype LOINC Codes

    /// 各 Observation 子型別對應的 LOINC 代碼
    public enum VitalSignsLOINC {
        /// 血壓 85354-9
        public static let bloodPressure        = "85354-9"
        /// 身體質量指數 39156-5
        public static let bmi                  = "39156-5"
        /// 身高 8302-2
        public static let bodyHeight           = "8302-2"
        /// 體溫 8310-5
        public static let bodyTemperature      = "8310-5"
        /// 體重 29463-7
        public static let bodyWeight           = "29463-7"
        /// 心跳 8867-4
        public static let heartRate            = "8867-4"
        /// 呼吸速率 9279-1
        public static let respiratoryRate      = "9279-1"
        /// 脈搏血氧 59408-5
        public static let pulseOximetry        = "59408-5"
        /// 周邊血氧飽和度 2708-6（PulseOximetry 次要代碼）
        public static let oxygenSaturation     = "2708-6"
        /// 平均血壓 96607-7
        public static let averageBloodPressure = "96607-7"
        /// 頭圍 9843-4
        public static let headCircumference    = "9843-4"
        /// 兒童 BMI 百分位 59576-9
        public static let pediatricBMIforAge   = "59576-9"
        /// 兒童頭圍百分位 8289-1
        public static let pediatricHeadCircumference = "8289-1"
        /// 職業 11341-5
        public static let occupation           = "11341-5"
        /// 治療介入偏好 75773-2
        public static let treatmentInterventionPreference = "75773-2"
        /// 照護經驗偏好 95541-9
        public static let careExperiencePreference = "95541-9"
        /// 心電圖 11524-6
        public static let ecg                      = "11524-6"
        /// 兒童體重身高百分位 77606-2
        public static let pediatricWeightHeight    = "77606-2"
        /// 懷孕意向 86645-9
        public static let pregnancyIntent          = "86645-9"
        /// 懷孕狀態 82810-3
        public static let pregnancyStatus          = "82810-3"
        /// 性取向 76690-7
        public static let sexualOrientation        = "76690-7"
    }

    // MARK: - Organization 子型別代碼常數

    /// Organization 子型別識別碼 type 與 organization type 代碼
    public enum OrganizationSubtype {
        /// 公司統一編號識別碼 type system（TW Core 自訂 v2-0203）
        public static let coIdentifierTypeSystem   = "https://twcore.mohw.gov.tw/ig/twcore/CodeSystem/v2-0203"
        /// 公司統一編號 type code
        public static let coIdentifierTypeCode     = "UBN"
        /// 政府機構識別碼 type code
        public static let govtIdentifierTypeCode   = "GOI"
        /// 醫院科別識別碼 type system（標準 HL7 v2-0203）
        public static let hospIdentifierTypeSystem = "http://terminology.hl7.org/CodeSystem/v2-0203"
        /// 醫院科別識別碼 type code
        public static let hospIdentifierTypeCode   = "PRN"
        /// Organization type system
        public static let typeSystem               = "http://terminology.hl7.org/CodeSystem/organization-type"
        /// 公司 type code
        public static let busTypeCode              = "bus"
        /// 政府機構 type code
        public static let govtTypeCode             = "govt"
        /// 醫療機構 type code
        public static let provTypeCode             = "prov"
    }
}
