import Foundation
import ModelsR4

// MARK: - Namespace 注入

extension Location {
    public var twCore: TWCoreLocationNamespace {
        get { TWCoreLocationNamespace(self) }
        set { self = newValue.location }
    }
}

// MARK: - TWCoreLocationNamespace

public struct TWCoreLocationNamespace {

    var location: Location

    public init(_ location: Location) {
        self.location = location
    }

    // MARK: 名稱（SHOULD）

    /// 地點名稱
    public var name: String? {
        get { location.name?.value?.string }
        set { location.name = newValue?.fhirString }
    }

    // MARK: 識別碼（base FHIR 支援，方便存取）

    /// 讀取識別碼
    public func identifier(system: String) -> String? {
        location.identifier?.first { $0.system?.absoluteString == system }?.value?.value?.string
    }

    /// 寫入識別碼
    public mutating func setIdentifier(_ value: String?, system: String) {
        if let value {
            let newId = makeIdentifier(value: value, system: system, typeCode: "FILL", typeText: "地點識別碼")
            if let idx = location.identifier?.firstIndex(where: { $0.system?.absoluteString == system }) {
                location.identifier?[idx] = newId
            } else {
                if location.identifier == nil { location.identifier = [newId] }
                else { location.identifier?.append(newId) }
            }
        } else {
            location.identifier?.removeAll { $0.system?.absoluteString == system }
        }
    }

    // MARK: Profile

    public mutating func declareProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.location, on: &location.meta)
    }
}

// MARK: - Validation

extension Location {
    /// Location 在 TW Core IG 中無額外 SHALL 欄位
    public func validateTWCore() -> Result<Void, TWCoreValidationError> {
        .success(())
    }
}
