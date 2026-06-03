import Foundation
import ModelsR4

// MARK: - Namespace 注入

extension PractitionerRole {
    public var twCore: TWCorePractitionerRoleNamespace {
        get { TWCorePractitionerRoleNamespace(self) }
        set { self = newValue.role }
    }
}

// MARK: - TWCorePractitionerRoleNamespace

public struct TWCorePractitionerRoleNamespace {

    var role: PractitionerRole

    public init(_ role: PractitionerRole) {
        self.role = role
    }

    // MARK: 科別代碼（SHOULD）

    /// 讀取指定 system 的科別代碼
    public func specialty(system: String) -> String? {
        role.specialty?.flatMap { $0.coding ?? [] }
            .first { $0.system?.absoluteString == system }?.code?.value?.string
    }

    /// 寫入指定 system 的科別代碼（若 specialty 陣列為空則建立第一筆）
    public mutating func setSpecialty(_ value: String?, system: String) {
        if role.specialty == nil { role.specialty = [CodeableConcept()] }
        if let value, let systemURI = system.fhirURI {
            let coding = Coding(code: value.fhirString, system: systemURI)
            if let ccIdx = role.specialty?.indices.first(where: {
                role.specialty?[$0].coding?.contains { $0.system?.absoluteString == system } ?? false
            }) {
                if let codingIdx = role.specialty?[ccIdx].coding?.firstIndex(where: { $0.system?.absoluteString == system }) {
                    role.specialty?[ccIdx].coding?[codingIdx] = coding
                }
            } else {
                if role.specialty?[0].coding == nil { role.specialty?[0].coding = [coding] }
                else { role.specialty?[0].coding?.append(coding) }
            }
        } else {
            for idx in role.specialty?.indices ?? [].indices {
                role.specialty?[idx].coding?.removeAll { $0.system?.absoluteString == system }
            }
        }
    }

    // MARK: 識別碼（SHOULD）

    /// 讀取識別碼
    public func identifier(system: String) -> String? {
        role.identifier?.first { $0.system?.absoluteString == system }?.value?.value?.string
    }

    /// 寫入識別碼
    public mutating func setIdentifier(_ value: String?, system: String) {
        if let value {
            let newId = makeIdentifier(value: value, system: system, typeCode: "FILL", typeText: "角色識別碼")
            if let idx = role.identifier?.firstIndex(where: { $0.system?.absoluteString == system }) {
                role.identifier?[idx] = newId
            } else {
                if role.identifier == nil { role.identifier = [newId] }
                else { role.identifier?.append(newId) }
            }
        } else {
            role.identifier?.removeAll { $0.system?.absoluteString == system }
        }
    }

    // MARK: Profile

    public mutating func declareProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.practitionerRole, on: &role.meta)
    }
}

// MARK: - Validation

extension PractitionerRole {
    /// PractitionerRole 在 TW Core IG 中無額外 SHALL 欄位
    public func validateTWCore() -> Result<Void, TWCoreValidationError> {
        .success(())
    }
}
