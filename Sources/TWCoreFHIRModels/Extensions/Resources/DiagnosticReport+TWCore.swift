import Foundation
import ModelsR4

// MARK: - Namespace 注入

extension DiagnosticReport {
    public var twCore: TWCoreDiagnosticReportNamespace {
        get { TWCoreDiagnosticReportNamespace(self) }
        set { self = newValue.report }
    }
}

// MARK: - TWCoreDiagnosticReportNamespace

public struct TWCoreDiagnosticReportNamespace {

    var report: DiagnosticReport

    public init(_ report: DiagnosticReport) {
        self.report = report
    }

    // MARK: 報告代碼（各 slice 為 SHOULD）
    // code 本身由 base FHIR init 保證存在（required param）

    /// 讀取指定 system 的報告代碼
    public func codeValue(system: String) -> String? {
        report.code.coding?.first { $0.system?.absoluteString == system }?.code?.value?.string
    }

    /// 寫入指定 system 的報告代碼
    public mutating func setCodeValue(_ value: String?, system: String, text: String? = nil) {
        if let value, let systemURI = system.fhirURI {
            let coding = Coding(code: value.fhirString, system: systemURI)
            if let idx = report.code.coding?.firstIndex(where: { $0.system?.absoluteString == system }) {
                report.code.coding?[idx] = coding
            } else {
                if report.code.coding == nil { report.code.coding = [coding] }
                else { report.code.coding?.append(coding) }
            }
        } else {
            report.code.coding?.removeAll { $0.system?.absoluteString == system }
        }
        if let text { report.code.text = text.fhirString }
    }

    // MARK: 識別碼（SHOULD）

    /// 讀取識別碼
    public func identifier(system: String) -> String? {
        report.identifier?.first { $0.system?.absoluteString == system }?.value?.value?.string
    }

    /// 寫入識別碼
    public mutating func setIdentifier(_ value: String?, system: String) {
        if let value {
            let newId = makeIdentifier(value: value, system: system, typeCode: "FILL", typeText: "報告識別碼")
            if let idx = report.identifier?.firstIndex(where: { $0.system?.absoluteString == system }) {
                report.identifier?[idx] = newId
            } else {
                if report.identifier == nil { report.identifier = [newId] }
                else { report.identifier?.append(newId) }
            }
        } else {
            report.identifier?.removeAll { $0.system?.absoluteString == system }
        }
    }

    // MARK: Profile

    public mutating func declareProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.diagnosticReport, on: &report.meta)
    }
}

// MARK: - Validation

extension DiagnosticReport {
    /// DiagnosticReport 在 TW Core IG 中無額外 SHALL 欄位（base FHIR 已要求 code、status）
    public func validateTWCore() -> Result<Void, TWCoreValidationError> {
        .success(())
    }
}
