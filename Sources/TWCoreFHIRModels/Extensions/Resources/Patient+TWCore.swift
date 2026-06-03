import Foundation
import ModelsR4

// MARK: - Namespace 注入

extension Patient {
    /// TW Core IG 專屬讀寫介面
    ///
    /// 透過 `patient.twCore.xxx` 存取台灣專屬欄位。
    /// 寫入時利用 Swift struct copy-on-write 語意將修改傳回原始 Patient。
    public var twCore: TWCorePatientNamespace {
        get { TWCorePatientNamespace(self) }
        set { self = newValue.patient }
    }
}

// MARK: - TWCorePatientNamespace

public struct TWCorePatientNamespace {

    var patient: Patient

    public init(_ patient: Patient) {
        self.patient = patient
    }

    // MARK: 身分識別碼

    /// 身分證字號（identifier.system = "http://www.moi.gov.tw"）
    public var idCardNumber: String? {
        get { patient.identifier?.first { $0.system?.absoluteString == TWCoreURL.IdentifierSystem.idCard }?.value?.value?.string }
        set { upsertIdentifier(newValue, system: TWCoreURL.IdentifierSystem.idCard,
                               typeCode: TWCoreURL.IdentifierType.idCardCode,
                               typeCodeSuffix: "TWN", typeText: "身分證字號") }
    }

    /// 護照號碼（identifier.system = "http://hl7.org/fhir/sid/passport-TWN"）
    public var passportNumber: String? {
        get { patient.identifier?.first { $0.system?.absoluteString == TWCoreURL.IdentifierSystem.passport }?.value?.value?.string }
        set { upsertIdentifier(newValue, system: TWCoreURL.IdentifierSystem.passport,
                               typeCode: TWCoreURL.IdentifierType.passportCode,
                               typeText: "護照號碼") }
    }

    /// 居留證號碼（identifier.system = "http://www.immigration.gov.tw"）
    public var residentNumber: String? {
        get { patient.identifier?.first { $0.system?.absoluteString == TWCoreURL.IdentifierSystem.residentCard }?.value?.value?.string }
        set { upsertIdentifier(newValue, system: TWCoreURL.IdentifierSystem.residentCard,
                               typeCode: TWCoreURL.IdentifierType.residentCardCode,
                               typeText: "居留證號碼") }
    }

    /// 讀取病歷號；因各院系統 URL 不同，需傳入 system
    public func medicalRecord(system: String) -> String? {
        patient.identifier?.first { $0.system?.absoluteString == system }?.value?.value?.string
    }

    /// 寫入病歷號；因各院系統 URL 不同，需傳入 system
    public mutating func setMedicalRecord(_ value: String?, system: String) {
        upsertIdentifier(value, system: system,
                         typeCode: TWCoreURL.IdentifierType.medicalRecordCode,
                         typeText: "病歷號")
    }

    // MARK: 姓名

    /// 護照姓名（name.use = official）
    public var officialName: HumanName? {
        patient.name?.first { $0.use?.value == .official }
    }

    /// 常用姓名，通常為中文姓名（name.use = usual）
    public var usualName: HumanName? {
        patient.name?.first { $0.use?.value == .usual }
    }

    // MARK: Profile

    public mutating func declareProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.patient, on: &patient.meta)
    }
}

// MARK: - Validation

extension Patient {
    /// 驗證是否符合 TW Core Patient 必填欄位規範
    ///
    /// 檢查項目：
    /// - `identifier` 1..*
    /// - 每個 `identifier.system` 1..1
    /// - 每個 `identifier.value` 1..1
    /// - `gender` 1..1
    /// - `birthDate` 1..1
    public func validateTWCore() -> Result<Void, TWCoreValidationError> {
        guard let identifiers = identifier, !identifiers.isEmpty else {
            return .failure(.missingRequiredField("Patient.identifier"))
        }
        for id in identifiers {
            guard id.system != nil else { return .failure(.invalidIdentifier("Patient.identifier.system")) }
            guard id.value != nil else { return .failure(.invalidIdentifier("Patient.identifier.value")) }
        }
        guard gender != nil else { return .failure(.missingRequiredField("Patient.gender")) }
        guard birthDate != nil else { return .failure(.missingRequiredField("Patient.birthDate")) }
        return .success(())
    }
}

// MARK: - Private Helpers

private extension TWCorePatientNamespace {

    mutating func upsertIdentifier(
        _ value: String?,
        system: String,
        typeCode: String,
        typeCodeSuffix: String? = nil,
        typeText: String
    ) {
        if let value {
            let newId = makeIdentifier(value: value, system: system,
                                       typeCode: typeCode, typeCodeSuffix: typeCodeSuffix,
                                       typeText: typeText)
            if let idx = patient.identifier?.firstIndex(where: { $0.system?.absoluteString == system }) {
                patient.identifier?[idx] = newId
            } else {
                if patient.identifier == nil { patient.identifier = [newId] }
                else { patient.identifier?.append(newId) }
            }
        } else {
            patient.identifier?.removeAll { $0.system?.absoluteString == system }
        }
    }
}
