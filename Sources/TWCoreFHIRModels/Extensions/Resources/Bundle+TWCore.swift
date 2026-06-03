import Foundation
import ModelsR4

extension ModelsR4.Bundle {
    public var twCore: TWCoreBundleNamespace {
        get { TWCoreBundleNamespace(self) }
        set { self = newValue.bundle }
    }
}

public struct TWCoreBundleNamespace {
    var bundle: ModelsR4.Bundle
    public init(_ bundle: ModelsR4.Bundle) { self.bundle = bundle }

    /// 宣告通用 Bundle Profile
    public mutating func declareProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.bundle, on: &bundle.meta)
    }

    /// 宣告文件包 Profile（Bundle-document-twcore）
    public mutating func declareBundleDocumentProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.bundleDocument, on: &bundle.meta)
    }

    /// 宣告訊息包 Profile（Bundle-message-twcore）
    public mutating func declareBundleMessageProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.bundleMessage, on: &bundle.meta)
    }
}

extension ModelsR4.Bundle {
    public func validateTWCore() -> Result<Void, TWCoreValidationError> { .success(()) }

    /// 驗證文件包（Bundle-document-twcore）必填欄位
    ///
    /// - `identifier` 1..1
    /// - `timestamp` 1..1
    /// - `entry` 1..*（需含 Composition）
    public func validateTWCoreBundleDocument() -> Result<Void, TWCoreValidationError> {
        guard identifier != nil else {
            return .failure(.missingRequiredField("Bundle.identifier"))
        }
        guard timestamp != nil else {
            return .failure(.missingRequiredField("Bundle.timestamp"))
        }
        guard let entries = entry, !entries.isEmpty else {
            return .failure(.missingRequiredField("Bundle.entry"))
        }
        return .success(())
    }

    /// 驗證訊息包（Bundle-message-twcore）必填欄位
    ///
    /// - `identifier` 1..1
    /// - `timestamp` 1..1
    /// - `entry` 1..*（需含 MessageHeader）
    public func validateTWCoreBundleMessage() -> Result<Void, TWCoreValidationError> {
        guard identifier != nil else {
            return .failure(.missingRequiredField("Bundle.identifier"))
        }
        guard timestamp != nil else {
            return .failure(.missingRequiredField("Bundle.timestamp"))
        }
        guard let entries = entry, !entries.isEmpty else {
            return .failure(.missingRequiredField("Bundle.entry"))
        }
        return .success(())
    }
}
