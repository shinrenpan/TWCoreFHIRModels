import Foundation
import ModelsR4

// MARK: - Namespace 注入

extension MedicationStatement {
    public var twCore: TWCoreMedicationStatementNamespace {
        get { TWCoreMedicationStatementNamespace(self) }
        set { self = newValue.statement }
    }
}

// MARK: - TWCoreMedicationStatementNamespace

public struct TWCoreMedicationStatementNamespace {

    var statement: MedicationStatement

    public init(_ statement: MedicationStatement) {
        self.statement = statement
    }

    // MARK: 藥品代碼（SHOULD，僅當 medication[x] 為 CodeableConcept 時有效）

    /// 讀取 medication[x] 中指定 system 的藥品代碼
    public func medicationCode(system: String) -> String? {
        guard case .codeableConcept(let cc) = statement.medication else { return nil }
        return cc.coding?.first { $0.system?.absoluteString == system }?.code?.value?.string
    }

    /// 以 CodeableConcept 設定 medication[x] 中指定 system 的藥品代碼
    public mutating func setMedicationCode(_ value: String?, system: String, text: String? = nil) {
        var cc: CodeableConcept
        if case .codeableConcept(let existing) = statement.medication {
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
        statement.medication = .codeableConcept(cc)
    }

    // MARK: 識別碼（SHOULD）

    /// 讀取識別碼
    public func identifier(system: String) -> String? {
        statement.identifier?.first { $0.system?.absoluteString == system }?.value?.value?.string
    }

    /// 寫入識別碼
    public mutating func setIdentifier(_ value: String?, system: String) {
        if let value {
            let newId = makeIdentifier(value: value, system: system, typeCode: "FILL", typeText: "用藥聲明識別碼")
            if let idx = statement.identifier?.firstIndex(where: { $0.system?.absoluteString == system }) {
                statement.identifier?[idx] = newId
            } else {
                if statement.identifier == nil { statement.identifier = [newId] }
                else { statement.identifier?.append(newId) }
            }
        } else {
            statement.identifier?.removeAll { $0.system?.absoluteString == system }
        }
    }

    // MARK: Profile

    public mutating func declareProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.medicationStatement, on: &statement.meta)
    }
}

// MARK: - Validation

extension MedicationStatement {
    /// MedicationStatement 在 TW Core IG 中無額外 SHALL 欄位（base FHIR 已要求 status/medication/subject）
    public func validateTWCore() -> Result<Void, TWCoreValidationError> {
        .success(())
    }
}
