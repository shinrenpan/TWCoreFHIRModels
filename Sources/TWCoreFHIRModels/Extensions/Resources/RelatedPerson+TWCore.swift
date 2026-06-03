import Foundation
import ModelsR4

// MARK: - Namespace 注入

extension RelatedPerson {
    public var twCore: TWCoreRelatedPersonNamespace {
        get { TWCoreRelatedPersonNamespace(self) }
        set { self = newValue.person }
    }
}

// MARK: - TWCoreRelatedPersonNamespace

public struct TWCoreRelatedPersonNamespace {

    var person: RelatedPerson

    public init(_ person: RelatedPerson) {
        self.person = person
    }

    // MARK: 姓名（SHOULD）

    /// 常用姓名（name.use = usual）
    public var usualName: HumanName? {
        person.name?.first { $0.use?.value == .usual }
    }

    /// 護照／官方姓名（name.use = official）
    public var officialName: HumanName? {
        person.name?.first { $0.use?.value == .official }
    }

    // MARK: 識別碼（base FHIR 支援）

    /// 讀取識別碼
    public func identifier(system: String) -> String? {
        person.identifier?.first { $0.system?.absoluteString == system }?.value?.value?.string
    }

    /// 寫入識別碼
    public mutating func setIdentifier(_ value: String?, system: String) {
        if let value {
            let newId = makeIdentifier(value: value, system: system, typeCode: "FILL", typeText: "關係人識別碼")
            if let idx = person.identifier?.firstIndex(where: { $0.system?.absoluteString == system }) {
                person.identifier?[idx] = newId
            } else {
                if person.identifier == nil { person.identifier = [newId] }
                else { person.identifier?.append(newId) }
            }
        } else {
            person.identifier?.removeAll { $0.system?.absoluteString == system }
        }
    }

    // MARK: Profile

    public mutating func declareProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.relatedPerson, on: &person.meta)
    }
}

// MARK: - Validation

extension RelatedPerson {
    /// 驗證是否符合 TW Core RelatedPerson 必填欄位規範
    ///
    /// - `active` 1..（TW Core SHALL；base FHIR R4 為 0..1）
    /// - `tw-core-6`（severity #error）：name 或 relationship 至少填一項
    public func validateTWCore() -> Result<Void, TWCoreValidationError> {
        guard active != nil else {
            return .failure(.missingRequiredField("RelatedPerson.active"))
        }
        let hasName = !(name?.isEmpty ?? true)
        let hasRelationship = !(relationship?.isEmpty ?? true)
        guard hasName || hasRelationship else {
            return .failure(.missingRequiredField("RelatedPerson.name 或 RelatedPerson.relationship 至少填一項"))
        }
        return .success(())
    }
}
