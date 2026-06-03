import Foundation
import ModelsR4

extension Media {
    public var twCore: TWCoreMediaNamespace {
        get { TWCoreMediaNamespace(self) }
        set { self = newValue.media }
    }
}

public struct TWCoreMediaNamespace {
    var media: Media
    public init(_ media: Media) { self.media = media }

    public func identifier(system: String) -> String? {
        media.identifier?.first { $0.system?.absoluteString == system }?.value?.value?.string
    }

    public mutating func setIdentifier(_ value: String?, system: String) {
        if let value {
            let newId = makeIdentifier(value: value, system: system, typeCode: "FILL", typeText: "媒體識別碼")
            if let idx = media.identifier?.firstIndex(where: { $0.system?.absoluteString == system }) {
                media.identifier?[idx] = newId
            } else {
                if media.identifier == nil { media.identifier = [newId] }
                else { media.identifier?.append(newId) }
            }
        } else {
            media.identifier?.removeAll { $0.system?.absoluteString == system }
        }
    }

    public mutating func declareProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.media, on: &media.meta)
    }
}

extension Media {
    public func validateTWCore() -> Result<Void, TWCoreValidationError> { .success(()) }
}
