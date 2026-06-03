import Foundation
import ModelsR4

// MARK: - Namespace 注入

extension Organization {
    public var twCore: TWCoreOrganizationNamespace {
        get { TWCoreOrganizationNamespace(self) }
        set { self = newValue.organization }
    }
}

// MARK: - TWCoreOrganizationNamespace

public struct TWCoreOrganizationNamespace {

    var organization: Organization

    public init(_ organization: Organization) {
        self.organization = organization
    }

    // MARK: 名稱

    /// 機構名稱（直接對應 organization.name）
    public var name: String? {
        get { organization.name?.value?.string }
        set { organization.name = newValue.map { $0.fhirString } }
    }

    // MARK: 識別碼（各院自訂 system）

    /// 讀取識別碼；需傳入機構 system URL
    public func identifier(system: String) -> String? {
        organization.identifier?.first { $0.system?.absoluteString == system }?.value?.value?.string
    }

    /// 寫入識別碼；需傳入機構 system URL 及 typeCode
    public mutating func setIdentifier(_ value: String?, system: String, typeCode: String, typeText: String) {
        if let value {
            let newId = makeIdentifier(value: value, system: system, typeCode: typeCode, typeText: typeText)
            if let idx = organization.identifier?.firstIndex(where: { $0.system?.absoluteString == system }) {
                organization.identifier?[idx] = newId
            } else {
                if organization.identifier == nil { organization.identifier = [newId] }
                else { organization.identifier?.append(newId) }
            }
        } else {
            organization.identifier?.removeAll { $0.system?.absoluteString == system }
        }
    }

    // MARK: Profile

    public mutating func declareProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.organization, on: &organization.meta)
    }

    /// 宣告公司機構 Profile（Organization-co-twcore）
    public mutating func declareCompanyProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.organizationCompany, on: &organization.meta)
    }

    /// 宣告政府機構 Profile（Organization-govt-twcore）
    public mutating func declareGovernmentProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.organizationGovernment, on: &organization.meta)
    }

    /// 宣告醫院科別 Profile（Organization-hosp-twcore）
    public mutating func declareHospitalProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.organizationHospital, on: &organization.meta)
    }

    // MARK: Organization type（SHOULD）

    /// 讀取 organization.type 的第一個代碼（指定 system）
    public func organizationType(system: String) -> String? {
        organization.type?.flatMap { $0.coding ?? [] }
            .first { $0.system?.absoluteString == system }?.code?.value?.string
    }

    /// 設定 organization.type
    public mutating func setOrganizationType(_ code: String, system: String, display: String? = nil) {
        var coding = Coding(code: code.fhirString, system: system.fhirURI)
        if let display { coding.display = display.fhirString }
        let concept = CodeableConcept(coding: [coding])
        if organization.type == nil { organization.type = [concept] }
        else {
            if let idx = organization.type?.firstIndex(where: {
                $0.coding?.contains { $0.system?.absoluteString == system } ?? false
            }) {
                organization.type?[idx] = concept
            } else {
                organization.type?.append(concept)
            }
        }
    }
}

// MARK: - Validation

extension Organization {
    /// 驗證是否符合 TW Core Organization 規範
    ///
    /// TW Core 未強制要求必填欄位，但至少需要有 `name` 或 `identifier` 其一。
    public func validateTWCore() -> Result<Void, TWCoreValidationError> {
        let hasName = name?.value?.string != nil
        let hasIdentifier = !(identifier?.isEmpty ?? true)
        guard hasName || hasIdentifier else {
            return .failure(.missingRequiredField("Organization.name 或 Organization.identifier 至少填一項"))
        }
        return .success(())
    }

    /// 驗證是否符合公司機構（Organization-co-twcore）規範
    ///
    /// - `identifier.type` 含 UBN code（SHALL）
    /// - `type` 含 bus code（SHALL）
    public func validateTWCoreOrganizationCompany() -> Result<Void, TWCoreValidationError> {
        let hasUBN = identifier?.contains { id in
            id.type?.coding?.contains {
                $0.system?.absoluteString == TWCoreURL.OrganizationSubtype.coIdentifierTypeSystem &&
                $0.code?.value?.string == TWCoreURL.OrganizationSubtype.coIdentifierTypeCode
            } ?? false
        } ?? false
        guard hasUBN else {
            return .failure(.missingRequiredField("Organization.identifier.type[UBN]"))
        }
        let hasBus = type?.contains { cc in
            cc.coding?.contains {
                $0.system?.absoluteString == TWCoreURL.OrganizationSubtype.typeSystem &&
                $0.code?.value?.string == TWCoreURL.OrganizationSubtype.busTypeCode
            } ?? false
        } ?? false
        guard hasBus else {
            return .failure(.missingRequiredField("Organization.type[bus]"))
        }
        return .success(())
    }

    /// 驗證是否符合政府機構（Organization-govt-twcore）規範
    ///
    /// - `identifier.type` 含 GOI code（SHALL）
    /// - `type` 含 govt code（SHALL）
    public func validateTWCoreOrganizationGovernment() -> Result<Void, TWCoreValidationError> {
        let hasGOI = identifier?.contains { id in
            id.type?.coding?.contains {
                $0.system?.absoluteString == TWCoreURL.OrganizationSubtype.coIdentifierTypeSystem &&
                $0.code?.value?.string == TWCoreURL.OrganizationSubtype.govtIdentifierTypeCode
            } ?? false
        } ?? false
        guard hasGOI else {
            return .failure(.missingRequiredField("Organization.identifier.type[GOI]"))
        }
        let hasGovt = type?.contains { cc in
            cc.coding?.contains {
                $0.system?.absoluteString == TWCoreURL.OrganizationSubtype.typeSystem &&
                $0.code?.value?.string == TWCoreURL.OrganizationSubtype.govtTypeCode
            } ?? false
        } ?? false
        guard hasGovt else {
            return .failure(.missingRequiredField("Organization.type[govt]"))
        }
        return .success(())
    }

    /// 驗證是否符合醫院科別（Organization-hosp-twcore）規範
    ///
    /// - `identifier.type` 含 PRN code（SHALL）
    public func validateTWCoreOrganizationHospital() -> Result<Void, TWCoreValidationError> {
        let hasPRN = identifier?.contains { id in
            id.type?.coding?.contains {
                $0.system?.absoluteString == TWCoreURL.OrganizationSubtype.hospIdentifierTypeSystem &&
                $0.code?.value?.string == TWCoreURL.OrganizationSubtype.hospIdentifierTypeCode
            } ?? false
        } ?? false
        guard hasPRN else {
            return .failure(.missingRequiredField("Organization.identifier.type[PRN]"))
        }
        return .success(())
    }
}
