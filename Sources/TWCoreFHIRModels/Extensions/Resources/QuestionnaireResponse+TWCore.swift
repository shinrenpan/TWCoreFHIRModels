import Foundation
import ModelsR4

extension QuestionnaireResponse {
    public var twCore: TWCoreQuestionnaireResponseNamespace {
        get { TWCoreQuestionnaireResponseNamespace(self) }
        set { self = newValue.response }
    }
}

public struct TWCoreQuestionnaireResponseNamespace {
    var response: QuestionnaireResponse
    public init(_ response: QuestionnaireResponse) { self.response = response }

    public mutating func declareProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.questionnaireResponse, on: &response.meta)
    }
}

extension QuestionnaireResponse {
    public func validateTWCore() -> Result<Void, TWCoreValidationError> { .success(()) }
}
