import Foundation
import ModelsR4

extension Composition {
    public var twCore: TWCoreCompositionNamespace {
        get { TWCoreCompositionNamespace(self) }
        set { self = newValue.composition }
    }
}

public struct TWCoreCompositionNamespace {
    var composition: Composition
    public init(_ composition: Composition) { self.composition = composition }

    public mutating func declareProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.composition, on: &composition.meta)
    }
}

extension Composition {
    public func validateTWCore() -> Result<Void, TWCoreValidationError> { .success(()) }
}
