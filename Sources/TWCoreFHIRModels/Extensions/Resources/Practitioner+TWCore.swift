import Foundation
import ModelsR4

// MARK: - Namespace 注入

extension Practitioner {
    public var twCore: TWCorePractitionerNamespace {
        get { TWCorePractitionerNamespace(self) }
        set { self = newValue.practitioner }
    }
}

// MARK: - TWCorePractitionerNamespace

public struct TWCorePractitionerNamespace {

    var practitioner: Practitioner

    public init(_ practitioner: Practitioner) {
        self.practitioner = practitioner
    }

    // MARK: 身分識別碼

    /// 身分證字號（identifier.system = "http://www.moi.gov.tw"）
    public var idCardNumber: String? {
        get { identifierValue(system: TWCoreURL.IdentifierSystem.idCard) }
        set { upsertIdentifier(newValue, system: TWCoreURL.IdentifierSystem.idCard,
                               typeCode: TWCoreURL.IdentifierType.idCardCode,
                               typeCodeSuffix: "TWN", typeText: "身分證字號") }
    }

    /// 護照號碼（identifier.system = "http://hl7.org/fhir/sid/passport-TWN"）
    public var passportNumber: String? {
        get { identifierValue(system: TWCoreURL.IdentifierSystem.passport) }
        set { upsertIdentifier(newValue, system: TWCoreURL.IdentifierSystem.passport,
                               typeCode: TWCoreURL.IdentifierType.passportCode,
                               typeText: "護照號碼") }
    }

    /// 居留證號碼（identifier.system = "http://www.immigration.gov.tw"）
    public var residentNumber: String? {
        get { identifierValue(system: TWCoreURL.IdentifierSystem.residentCard) }
        set { upsertIdentifier(newValue, system: TWCoreURL.IdentifierSystem.residentCard,
                               typeCode: TWCoreURL.IdentifierType.residentCardCode,
                               typeText: "居留證號碼") }
    }

    /// 讀取醫師執照號碼；需傳入各核發機構的 system URL
    public func medicalLicense(system: String) -> String? {
        identifierValue(system: system)
    }

    /// 寫入醫師執照號碼；需傳入各核發機構的 system URL
    public mutating func setMedicalLicense(_ value: String?, system: String) {
        upsertIdentifier(value, system: system,
                         typeCode: TWCoreURL.IdentifierType.practitionerLicenseCode,
                         typeText: "醫師執照號碼")
    }

    // MARK: 姓名

    /// 護照姓名（name.use = official）
    public var officialName: HumanName? {
        practitioner.name?.first { $0.use?.value == .official }
    }

    /// 常用姓名，通常為中文姓名（name.use = usual）
    public var usualName: HumanName? {
        practitioner.name?.first { $0.use?.value == .usual }
    }

    // MARK: Profile

    public mutating func declareProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.practitioner, on: &practitioner.meta)
    }
}

// MARK: - Validation

extension Practitioner {
    /// 驗證是否符合 TW Core Practitioner 必填欄位規範
    ///
    /// 檢查項目：
    /// - `identifier` 1..*
    /// - 每個 `identifier.system` 1..1
    /// - 每個 `identifier.value` 1..1
    public func validateTWCore() -> Result<Void, TWCoreValidationError> {
        guard let identifiers = identifier, !identifiers.isEmpty else {
            return .failure(.missingRequiredField("Practitioner.identifier"))
        }
        for id in identifiers {
            guard id.system != nil else { return .failure(.invalidIdentifier("Practitioner.identifier.system")) }
            guard id.value != nil else { return .failure(.invalidIdentifier("Practitioner.identifier.value")) }
        }
        return .success(())
    }
}

// MARK: - Private Helpers

private extension TWCorePractitionerNamespace {

    func identifierValue(system: String) -> String? {
        practitioner.identifier?.first { $0.system?.absoluteString == system }?.value?.value?.string
    }

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
            if let idx = practitioner.identifier?.firstIndex(where: { $0.system?.absoluteString == system }) {
                practitioner.identifier?[idx] = newId
            } else {
                if practitioner.identifier == nil { practitioner.identifier = [newId] }
                else { practitioner.identifier?.append(newId) }
            }
        } else {
            practitioner.identifier?.removeAll { $0.system?.absoluteString == system }
        }
    }
}
