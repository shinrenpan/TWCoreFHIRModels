import Foundation
import ModelsR4

// MARK: - Namespace 注入

extension Immunization {
    public var twCore: TWCoreImmunizationNamespace {
        get { TWCoreImmunizationNamespace(self) }
        set { self = newValue.immunization }
    }
}

// MARK: - TWCoreImmunizationNamespace

public struct TWCoreImmunizationNamespace {

    var immunization: Immunization

    public init(_ immunization: Immunization) {
        self.immunization = immunization
    }

    // MARK: 疫苗代碼（SHOULD）
    // vaccineCode 本身由 base FHIR init 保證存在（required param）

    /// 讀取指定 system 的疫苗代碼
    public func vaccineCode(system: String) -> String? {
        immunization.vaccineCode.coding?.first { $0.system?.absoluteString == system }?.code?.value?.string
    }

    /// 寫入指定 system 的疫苗代碼（SHOULD）
    public mutating func setVaccineCode(_ value: String?, system: String, display: String? = nil) {
        if let value, let systemURI = system.fhirURI {
            var coding = Coding(code: value.fhirString, system: systemURI)
            if let display { coding.display = display.fhirString }
            if let idx = immunization.vaccineCode.coding?.firstIndex(where: { $0.system?.absoluteString == system }) {
                immunization.vaccineCode.coding?[idx] = coding
            } else {
                if immunization.vaccineCode.coding == nil { immunization.vaccineCode.coding = [coding] }
                else { immunization.vaccineCode.coding?.append(coding) }
            }
        } else {
            immunization.vaccineCode.coding?.removeAll { $0.system?.absoluteString == system }
        }
    }

    // MARK: 識別碼（SHOULD）

    /// 讀取識別碼
    public func identifier(system: String) -> String? {
        immunization.identifier?.first { $0.system?.absoluteString == system }?.value?.value?.string
    }

    /// 寫入識別碼
    public mutating func setIdentifier(_ value: String?, system: String) {
        if let value {
            let newId = makeIdentifier(value: value, system: system, typeCode: "FILL", typeText: "疫苗接種識別碼")
            if let idx = immunization.identifier?.firstIndex(where: { $0.system?.absoluteString == system }) {
                immunization.identifier?[idx] = newId
            } else {
                if immunization.identifier == nil { immunization.identifier = [newId] }
                else { immunization.identifier?.append(newId) }
            }
        } else {
            immunization.identifier?.removeAll { $0.system?.absoluteString == system }
        }
    }

    // MARK: Profile

    public mutating func declareProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.immunization, on: &immunization.meta)
    }
}

// MARK: - Validation

extension Immunization {
    /// Immunization 在 TW Core IG 中無額外 SHALL 欄位（base FHIR 已要求 vaccineCode、patient、occurrence[x]、status）
    public func validateTWCore() -> Result<Void, TWCoreValidationError> {
        .success(())
    }
}
