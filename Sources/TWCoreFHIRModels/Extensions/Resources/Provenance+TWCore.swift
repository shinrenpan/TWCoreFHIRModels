import Foundation
import ModelsR4

extension Provenance {
    public var twCore: TWCoreProvenanceNamespace {
        get { TWCoreProvenanceNamespace(self) }
        set { self = newValue.provenance }
    }
}

public struct TWCoreProvenanceNamespace {
    var provenance: Provenance
    public init(_ provenance: Provenance) { self.provenance = provenance }

    public mutating func declareProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.provenance, on: &provenance.meta)
    }
}

extension Provenance {
    public func validateTWCore() -> Result<Void, TWCoreValidationError> { .success(()) }
}
