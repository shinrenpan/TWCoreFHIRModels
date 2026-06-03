import Foundation
import ModelsR4

// MARK: - Namespace 注入

extension Medication {
    public var twCore: TWCoreMedicationNamespace {
        get { TWCoreMedicationNamespace(self) }
        set { self = newValue.medication }
    }
}

// MARK: - TWCoreMedicationNamespace

public struct TWCoreMedicationNamespace {

    var medication: Medication

    public init(_ medication: Medication) {
        self.medication = medication
    }

    // MARK: 藥品代碼（SHOULD）

    /// 台灣食藥署 (FDA) 藥品代碼
    public var fdaCode: String? {
        get { codeValue(system: TWCoreURL.MedicationCode.fda) }
        set { setCodeValue(newValue, system: TWCoreURL.MedicationCode.fda) }
    }

    /// 健保署健保用藥品項代碼
    public var nhiCode: String? {
        get { codeValue(system: TWCoreURL.MedicationCode.nhi) }
        set { setCodeValue(newValue, system: TWCoreURL.MedicationCode.nhi) }
    }

    /// 健保署中藥用藥品項代碼
    public var chHerbCode: String? {
        get { codeValue(system: TWCoreURL.MedicationCode.nhiChHerb) }
        set { setCodeValue(newValue, system: TWCoreURL.MedicationCode.nhiChHerb) }
    }

    /// RxNorm 藥品代碼
    public var rxNormCode: String? {
        get { codeValue(system: TWCoreURL.MedicationCode.rxNorm) }
        set { setCodeValue(newValue, system: TWCoreURL.MedicationCode.rxNorm) }
    }

    /// 台灣食藥署 ATC 代碼
    public var atcCode: String? {
        get { codeValue(system: TWCoreURL.MedicationCode.atcTW) }
        set { setCodeValue(newValue, system: TWCoreURL.MedicationCode.atcTW) }
    }

    /// SNOMED CT 代碼
    public var snomedCode: String? {
        get { codeValue(system: TWCoreURL.MedicationCode.snomedCT) }
        set { setCodeValue(newValue, system: TWCoreURL.MedicationCode.snomedCT) }
    }

    /// 藥品代碼文字（code.text）（SHOULD）
    public var codeText: String? {
        get { medication.code?.text?.value?.string }
        set {
            if medication.code == nil { medication.code = CodeableConcept() }
            medication.code?.text = newValue?.fhirString
        }
    }

    /// 劑型文字（form.text）（SHOULD）
    public var formText: String? {
        get { medication.form?.text?.value?.string }
        set {
            if medication.form == nil { medication.form = CodeableConcept() }
            medication.form?.text = newValue?.fhirString
        }
    }

    // MARK: Profile

    public mutating func declareProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.medication, on: &medication.meta)
    }
}

// MARK: - Validation

extension Medication {
    /// Medication 在 TW Core IG 中無額外 SHALL 欄位，此方法保留以維持 API 一致性
    public func validateTWCore() -> Result<Void, TWCoreValidationError> {
        .success(())
    }
}

// MARK: - Private Helpers

private extension TWCoreMedicationNamespace {

    func codeValue(system: String) -> String? {
        medication.code?.coding?.first { $0.system?.absoluteString == system }?.code?.value?.string
    }

    mutating func setCodeValue(_ value: String?, system: String) {
        if medication.code == nil { medication.code = CodeableConcept() }
        if let value, let systemURI = system.fhirURI {
            let coding = Coding(code: value.fhirString, system: systemURI)
            if let idx = medication.code?.coding?.firstIndex(where: { $0.system?.absoluteString == system }) {
                medication.code?.coding?[idx] = coding
            } else {
                if medication.code?.coding == nil { medication.code?.coding = [coding] }
                else { medication.code?.coding?.append(coding) }
            }
        } else {
            medication.code?.coding?.removeAll { $0.system?.absoluteString == system }
        }
    }
}
