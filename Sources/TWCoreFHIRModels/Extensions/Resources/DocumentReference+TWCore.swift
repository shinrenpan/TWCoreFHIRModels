import Foundation
import ModelsR4

extension DocumentReference {
    public var twCore: TWCoreDocumentReferenceNamespace {
        get { TWCoreDocumentReferenceNamespace(self) }
        set { self = newValue.reference }
    }
}

public struct TWCoreDocumentReferenceNamespace {
    var reference: DocumentReference
    public init(_ reference: DocumentReference) { self.reference = reference }

    public func identifier(system: String) -> String? {
        reference.identifier?.first { $0.system?.absoluteString == system }?.value?.value?.string
    }

    public mutating func setIdentifier(_ value: String?, system: String) {
        if let value {
            let newId = makeIdentifier(value: value, system: system, typeCode: "FILL", typeText: "文件參照識別碼")
            if let idx = reference.identifier?.firstIndex(where: { $0.system?.absoluteString == system }) {
                reference.identifier?[idx] = newId
            } else {
                if reference.identifier == nil { reference.identifier = [newId] }
                else { reference.identifier?.append(newId) }
            }
        } else {
            reference.identifier?.removeAll { $0.system?.absoluteString == system }
        }
    }

    public mutating func declareProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.documentReference, on: &reference.meta)
    }
}

extension DocumentReference {
    public func validateTWCore() -> Result<Void, TWCoreValidationError> { .success(()) }
}
