import Foundation
import ModelsR4

extension MessageHeader {
    public var twCore: TWCoreMessageHeaderNamespace {
        get { TWCoreMessageHeaderNamespace(self) }
        set { self = newValue.header }
    }
}

public struct TWCoreMessageHeaderNamespace {
    var header: MessageHeader
    public init(_ header: MessageHeader) { self.header = header }

    public mutating func declareProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.messageHeader, on: &header.meta)
    }
}

extension MessageHeader {
    public func validateTWCore() -> Result<Void, TWCoreValidationError> { .success(()) }
}
