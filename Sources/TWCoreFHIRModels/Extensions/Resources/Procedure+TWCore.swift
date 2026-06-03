import Foundation
import ModelsR4

// MARK: - Namespace 注入

extension Procedure {
    public var twCore: TWCoreProcedureNamespace {
        get { TWCoreProcedureNamespace(self) }
        set { self = newValue.procedure }
    }
}

// MARK: - TWCoreProcedureNamespace

public struct TWCoreProcedureNamespace {

    var procedure: Procedure

    public init(_ procedure: Procedure) {
        self.procedure = procedure
    }

    // MARK: 處置代碼（SHALL 1..1，各 slice 為 SHOULD）

    /// 讀取指定 system 的處置代碼
    public func codeValue(system: String) -> String? {
        procedure.code?.coding?.first { $0.system?.absoluteString == system }?.code?.value?.string
    }

    /// 寫入指定 system 的處置代碼；會自動建立 code 若尚未存在
    public mutating func setCodeValue(_ value: String?, system: String, text: String? = nil) {
        if procedure.code == nil { procedure.code = CodeableConcept() }
        if let value, let systemURI = system.fhirURI {
            let coding = Coding(code: value.fhirString, system: systemURI)
            if let idx = procedure.code?.coding?.firstIndex(where: { $0.system?.absoluteString == system }) {
                procedure.code?.coding?[idx] = coding
            } else {
                if procedure.code?.coding == nil { procedure.code?.coding = [coding] }
                else { procedure.code?.coding?.append(coding) }
            }
        } else {
            procedure.code?.coding?.removeAll { $0.system?.absoluteString == system }
        }
        if let text { procedure.code?.text = text.fhirString }
    }

    /// 處置代碼文字（code.text）（SHOULD）
    public var codeText: String? {
        get { procedure.code?.text?.value?.string }
        set {
            if procedure.code == nil { procedure.code = CodeableConcept() }
            procedure.code?.text = newValue?.fhirString
        }
    }

    // MARK: 識別碼（SHOULD）

    /// 讀取識別碼
    public func identifier(system: String) -> String? {
        procedure.identifier?.first { $0.system?.absoluteString == system }?.value?.value?.string
    }

    /// 寫入識別碼
    public mutating func setIdentifier(_ value: String?, system: String) {
        if let value {
            let newId = makeIdentifier(value: value, system: system, typeCode: "FILL", typeText: "處置識別碼")
            if let idx = procedure.identifier?.firstIndex(where: { $0.system?.absoluteString == system }) {
                procedure.identifier?[idx] = newId
            } else {
                if procedure.identifier == nil { procedure.identifier = [newId] }
                else { procedure.identifier?.append(newId) }
            }
        } else {
            procedure.identifier?.removeAll { $0.system?.absoluteString == system }
        }
    }

    // MARK: Profile

    public mutating func declareProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.procedure, on: &procedure.meta)
    }
}

// MARK: - Validation

extension Procedure {
    /// 驗證是否符合 TW Core Procedure 必填欄位規範
    ///
    /// - `code` 1..1（TW Core SHALL；base FHIR R4 為 0..1）
    public func validateTWCore() -> Result<Void, TWCoreValidationError> {
        guard code != nil else {
            return .failure(.missingRequiredField("Procedure.code"))
        }
        return .success(())
    }
}
