import Foundation
import ModelsR4

// MARK: - Namespace 注入

extension MedicationDispense {
    public var twCore: TWCoreMedicationDispenseNamespace {
        get { TWCoreMedicationDispenseNamespace(self) }
        set { self = newValue.dispense }
    }
}

// MARK: - TWCoreMedicationDispenseNamespace

public struct TWCoreMedicationDispenseNamespace {

    var dispense: MedicationDispense

    public init(_ dispense: MedicationDispense) {
        self.dispense = dispense
    }

    // MARK: 藥品代碼（SHOULD，僅當 medication[x] 為 CodeableConcept 時有效）

    /// 讀取 medication[x] 中指定 system 的藥品代碼
    public func medicationCode(system: String) -> String? {
        guard case .codeableConcept(let cc) = dispense.medication else { return nil }
        return cc.coding?.first { $0.system?.absoluteString == system }?.code?.value?.string
    }

    /// 以 CodeableConcept 設定 medication[x] 中指定 system 的藥品代碼
    public mutating func setMedicationCode(_ value: String?, system: String, text: String? = nil) {
        var cc: CodeableConcept
        if case .codeableConcept(let existing) = dispense.medication {
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
        dispense.medication = .codeableConcept(cc)
    }

    // MARK: 識別碼（SHOULD）

    /// 讀取識別碼
    public func identifier(system: String) -> String? {
        dispense.identifier?.first { $0.system?.absoluteString == system }?.value?.value?.string
    }

    /// 寫入識別碼
    public mutating func setIdentifier(_ value: String?, system: String) {
        if let value {
            let newId = makeIdentifier(value: value, system: system, typeCode: "FILL", typeText: "配藥識別碼")
            if let idx = dispense.identifier?.firstIndex(where: { $0.system?.absoluteString == system }) {
                dispense.identifier?[idx] = newId
            } else {
                if dispense.identifier == nil { dispense.identifier = [newId] }
                else { dispense.identifier?.append(newId) }
            }
        } else {
            dispense.identifier?.removeAll { $0.system?.absoluteString == system }
        }
    }

    // MARK: Profile

    public mutating func declareProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.medicationDispense, on: &dispense.meta)
    }
}

// MARK: - Validation

extension MedicationDispense {
    /// 驗證是否符合 TW Core MedicationDispense 必填欄位規範
    ///
    /// - `subject` 1..（TW Core SHALL；base FHIR R4 為 0..1）
    public func validateTWCore() -> Result<Void, TWCoreValidationError> {
        guard subject != nil else {
            return .failure(.missingRequiredField("MedicationDispense.subject"))
        }
        return .success(())
    }
}
