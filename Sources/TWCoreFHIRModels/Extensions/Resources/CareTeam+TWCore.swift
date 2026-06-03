import Foundation
import ModelsR4

// MARK: - Namespace 注入

extension CareTeam {
    public var twCore: TWCoreCareTeamNamespace {
        get { TWCoreCareTeamNamespace(self) }
        set { self = newValue.careTeam }
    }
}

// MARK: - TWCoreCareTeamNamespace

public struct TWCoreCareTeamNamespace {

    var careTeam: CareTeam

    public init(_ careTeam: CareTeam) {
        self.careTeam = careTeam
    }

    // MARK: 識別碼（SHOULD）

    public func identifier(system: String) -> String? {
        careTeam.identifier?.first { $0.system?.absoluteString == system }?.value?.value?.string
    }

    public mutating func setIdentifier(_ value: String?, system: String) {
        if let value {
            let newId = makeIdentifier(value: value, system: system, typeCode: "FILL", typeText: "照護團隊識別碼")
            if let idx = careTeam.identifier?.firstIndex(where: { $0.system?.absoluteString == system }) {
                careTeam.identifier?[idx] = newId
            } else {
                if careTeam.identifier == nil { careTeam.identifier = [newId] }
                else { careTeam.identifier?.append(newId) }
            }
        } else {
            careTeam.identifier?.removeAll { $0.system?.absoluteString == system }
        }
    }

    // MARK: Profile

    public mutating func declareProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.careTeam, on: &careTeam.meta)
    }
}

// MARK: - Validation

extension CareTeam {
    /// 驗證是否符合 TW Core CareTeam 必填欄位規範
    ///
    /// - `participant` 1..（TW Core SHALL；base FHIR R4 為 0..*）
    /// - `participant.role` 1..1（每個參與者必須有角色）
    /// - `participant.member` 1..（每個參與者必須有成員）
    public func validateTWCore() -> Result<Void, TWCoreValidationError> {
        guard let participants = participant, !participants.isEmpty else {
            return .failure(.missingRequiredField("CareTeam.participant"))
        }
        for p in participants {
            guard let roles = p.role, !roles.isEmpty else {
                return .failure(.missingRequiredField("CareTeam.participant.role"))
            }
            guard p.member != nil else {
                return .failure(.missingRequiredField("CareTeam.participant.member"))
            }
        }
        return .success(())
    }
}
