import Foundation
import ModelsR4

// MARK: - Namespace 注入

extension Encounter {
    public var twCore: TWCoreEncounterNamespace {
        get { TWCoreEncounterNamespace(self) }
        set { self = newValue.encounter }
    }
}

// MARK: - TWCoreEncounterNamespace

public struct TWCoreEncounterNamespace {

    var encounter: Encounter

    public init(_ encounter: Encounter) {
        self.encounter = encounter
    }

    // MARK: 識別碼（各院自訂 system）

    /// 讀取就診識別碼；需傳入機構 system URL
    public func identifier(system: String) -> String? {
        encounter.identifier?.first { $0.system?.absoluteString == system }?.value?.value?.string
    }

    /// 寫入就診識別碼；需傳入機構 system URL
    public mutating func setIdentifier(_ value: String?, system: String, typeText: String = "就診識別碼") {
        if let value {
            let newId = makeIdentifier(value: value, system: system,
                                       typeCode: "VN", typeText: typeText)
            if let idx = encounter.identifier?.firstIndex(where: { $0.system?.absoluteString == system }) {
                encounter.identifier?[idx] = newId
            } else {
                if encounter.identifier == nil { encounter.identifier = [newId] }
                else { encounter.identifier?.append(newId) }
            }
        } else {
            encounter.identifier?.removeAll { $0.system?.absoluteString == system }
        }
    }

    // MARK: Profile

    public mutating func declareProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.encounter, on: &encounter.meta)
    }
}

// MARK: - Validation

extension Encounter {
    /// 驗證是否符合 TW Core Encounter 必填欄位規範
    ///
    /// 檢查項目：
    /// - `identifier` 1..*
    /// - 每個 `identifier.system` 1..1
    /// - 每個 `identifier.value` 1..1
    public func validateTWCore() -> Result<Void, TWCoreValidationError> {
        guard let identifiers = identifier, !identifiers.isEmpty else {
            return .failure(.missingRequiredField("Encounter.identifier"))
        }
        for id in identifiers {
            guard id.system != nil else { return .failure(.invalidIdentifier("Encounter.identifier.system")) }
            guard id.value != nil else { return .failure(.invalidIdentifier("Encounter.identifier.value")) }
        }
        return .success(())
    }
}
