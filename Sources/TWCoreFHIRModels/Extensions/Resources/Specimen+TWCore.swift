import Foundation
import ModelsR4

// MARK: - Namespace 注入

extension Specimen {
    public var twCore: TWCoreSpecimenNamespace {
        get { TWCoreSpecimenNamespace(self) }
        set { self = newValue.specimen }
    }
}

// MARK: - TWCoreSpecimenNamespace

public struct TWCoreSpecimenNamespace {

    var specimen: Specimen

    public init(_ specimen: Specimen) {
        self.specimen = specimen
    }

    // MARK: 識別碼（SHOULD）

    /// 讀取識別碼
    public func identifier(system: String) -> String? {
        specimen.identifier?.first { $0.system?.absoluteString == system }?.value?.value?.string
    }

    /// 寫入識別碼
    public mutating func setIdentifier(_ value: String?, system: String) {
        if let value {
            let newId = makeIdentifier(value: value, system: system, typeCode: "FILL", typeText: "檢體識別碼")
            if let idx = specimen.identifier?.firstIndex(where: { $0.system?.absoluteString == system }) {
                specimen.identifier?[idx] = newId
            } else {
                if specimen.identifier == nil { specimen.identifier = [newId] }
                else { specimen.identifier?.append(newId) }
            }
        } else {
            specimen.identifier?.removeAll { $0.system?.absoluteString == system }
        }
    }

    // MARK: Profile

    public mutating func declareProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.specimen, on: &specimen.meta)
    }
}

// MARK: - Validation

extension Specimen {
    /// Specimen 在 TW Core IG 中無額外 SHALL 欄位
    public func validateTWCore() -> Result<Void, TWCoreValidationError> {
        .success(())
    }
}
