import Foundation
import ModelsR4

// MARK: - Namespace 注入

extension MedicationRequest {
    public var twCore: TWCoreMedicationRequestNamespace {
        get { TWCoreMedicationRequestNamespace(self) }
        set { self = newValue.request }
    }
}

// MARK: - TWCoreMedicationRequestNamespace

public struct TWCoreMedicationRequestNamespace {

    var request: MedicationRequest

    public init(_ request: MedicationRequest) {
        self.request = request
    }

    // MARK: 藥品代碼（SHOULD，僅當 medication[x] 為 CodeableConcept 時有效）

    /// 讀取 medication[x] 中指定 system 的藥品代碼
    public func medicationCode(system: String) -> String? {
        guard case .codeableConcept(let cc) = request.medication else { return nil }
        return cc.coding?.first { $0.system?.absoluteString == system }?.code?.value?.string
    }

    /// 以 CodeableConcept 設定 medication[x] 中指定 system 的藥品代碼
    public mutating func setMedicationCode(_ value: String?, system: String, text: String? = nil) {
        var cc: CodeableConcept
        if case .codeableConcept(let existing) = request.medication {
            cc = existing
        } else {
            cc = CodeableConcept()
        }
        if let value, let systemURI = system.fhirURI {
            let coding = Coding(code: value.fhirString, system: systemURI)
            if let idx = cc.coding?.firstIndex(where: { $0.system?.absoluteString == system }) {
                cc.coding?[idx] = coding
            } else {
                if cc.coding == nil { cc.coding = [coding] }
                else { cc.coding?.append(coding) }
            }
        } else {
            cc.coding?.removeAll { $0.system?.absoluteString == system }
        }
        if let text { cc.text = text.fhirString }
        request.medication = .codeableConcept(cc)
    }

    // MARK: 識別碼（SHOULD）

    /// 讀取就診識別碼
    public func identifier(system: String) -> String? {
        request.identifier?.first { $0.system?.absoluteString == system }?.value?.value?.string
    }

    /// 寫入就診識別碼
    public mutating func setIdentifier(_ value: String?, system: String) {
        if let value {
            let newId = makeIdentifier(value: value, system: system, typeCode: "FILL", typeText: "藥品請求識別碼")
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
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.medicationRequest, on: &request.meta)
    }
}

// MARK: - Validation

extension MedicationRequest {
    /// MedicationRequest 在 TW Core IG 中無額外 SHALL 欄位（base FHIR 已要求 status/intent/medication/subject）
    public func validateTWCore() -> Result<Void, TWCoreValidationError> {
        .success(())
    }
}
