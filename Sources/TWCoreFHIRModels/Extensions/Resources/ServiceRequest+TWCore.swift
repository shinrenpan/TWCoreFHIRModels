import Foundation
import ModelsR4

// MARK: - Namespace 注入

extension ServiceRequest {
    public var twCore: TWCoreServiceRequestNamespace {
        get { TWCoreServiceRequestNamespace(self) }
        set { self = newValue.request }
    }
}

// MARK: - TWCoreServiceRequestNamespace

public struct TWCoreServiceRequestNamespace {

    var request: ServiceRequest

    public init(_ request: ServiceRequest) {
        self.request = request
    }

    // MARK: 服務代碼（SHOULD）

    public func codeValue(system: String) -> String? {
        request.code?.coding?.first { $0.system?.absoluteString == system }?.code?.value?.string
    }

    public mutating func setCodeValue(_ value: String?, system: String, text: String? = nil) {
        if let value, let systemURI = system.fhirURI {
            let coding = Coding(code: value.fhirString, system: systemURI)
            if request.code == nil { request.code = CodeableConcept() }
            if let idx = request.code?.coding?.firstIndex(where: { $0.system?.absoluteString == system }) {
                request.code?.coding?[idx] = coding
            } else {
                if request.code?.coding == nil { request.code?.coding = [coding] }
                else { request.code?.coding?.append(coding) }
            }
            if let text { request.code?.text = text.fhirString }
        } else {
            request.code?.coding?.removeAll { $0.system?.absoluteString == system }
        }
    }

    // MARK: 識別碼（SHOULD）

    public func identifier(system: String) -> String? {
        request.identifier?.first { $0.system?.absoluteString == system }?.value?.value?.string
    }

    public mutating func setIdentifier(_ value: String?, system: String) {
        if let value {
            let newId = makeIdentifier(value: value, system: system, typeCode: "FILL", typeText: "服務請求識別碼")
            if let idx = request.identifier?.firstIndex(where: { $0.system?.absoluteString == system }) {
                request.identifier?[idx] = newId
            } else {
                if request.identifier == nil { request.identifier = [newId] }
                else { request.identifier?.append(newId) }
            }
        } else {
            request.identifier?.removeAll { $0.system?.absoluteString == system }
        }
    }

    // MARK: Profile

    public mutating func declareProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.serviceRequest, on: &request.meta)
    }
}

// MARK: - Validation

extension ServiceRequest {
    /// 驗證是否符合 TW Core ServiceRequest 必填欄位規範
    ///
    /// - `code` 1..1（TW Core SHALL；base FHIR R4 為 0..1）
    public func validateTWCore() -> Result<Void, TWCoreValidationError> {
        guard code != nil else {
            return .failure(.missingRequiredField("ServiceRequest.code"))
        }
        return .success(())
    }
}
