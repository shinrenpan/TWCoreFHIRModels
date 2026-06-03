import Foundation
import ModelsR4

extension ImagingStudy {
    public var twCore: TWCoreImagingStudyNamespace {
        get { TWCoreImagingStudyNamespace(self) }
        set { self = newValue.study }
    }
}

public struct TWCoreImagingStudyNamespace {
    var study: ImagingStudy
    public init(_ study: ImagingStudy) { self.study = study }

    public func identifier(system: String) -> String? {
        study.identifier?.first { $0.system?.absoluteString == system }?.value?.value?.string
    }

    public mutating func setIdentifier(_ value: String?, system: String) {
        if let value {
            let newId = makeIdentifier(value: value, system: system, typeCode: "FILL", typeText: "影像研究識別碼")
            if let idx = study.identifier?.firstIndex(where: { $0.system?.absoluteString == system }) {
                study.identifier?[idx] = newId
            } else {
                if study.identifier == nil { study.identifier = [newId] }
                else { study.identifier?.append(newId) }
            }
        } else {
            study.identifier?.removeAll { $0.system?.absoluteString == system }
        }
    }

    public mutating func declareProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.imagingStudy, on: &study.meta)
    }
}

extension ImagingStudy {
    public func validateTWCore() -> Result<Void, TWCoreValidationError> { .success(()) }
}
