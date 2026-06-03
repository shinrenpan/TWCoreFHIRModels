import Testing
import ModelsR4
@testable import TWCoreFHIRModels

// MARK: - Medication

@Suite("Medication TW Core")
struct MedicationTests {

    @Test("設定與讀取 FDA 藥品代碼")
    func fdaCode() {
        var med = Medication()
        med.twCore.fdaCode = "AC37611100"
        #expect(med.twCore.fdaCode == "AC37611100")
    }

    @Test("設定與讀取 NHI 藥品代碼")
    func nhiCode() {
        var med = Medication()
        med.twCore.nhiCode = "BC22659100"
        #expect(med.twCore.nhiCode == "BC22659100")
    }

    @Test("設定與讀取 RxNorm 代碼")
    func rxNormCode() {
        var med = Medication()
        med.twCore.rxNormCode = "1049502"
        #expect(med.twCore.rxNormCode == "1049502")
    }

    @Test("設定與讀取藥品代碼文字")
    func codeText() {
        var med = Medication()
        med.twCore.codeText = "阿莫西林膠囊"
        #expect(med.twCore.codeText == "阿莫西林膠囊")
    }

    @Test("多個代碼互不干擾")
    func multipleCodes() {
        var med = Medication()
        med.twCore.fdaCode = "AC37611100"
        med.twCore.nhiCode = "BC22659100"
        #expect(med.twCore.fdaCode == "AC37611100")
        #expect(med.twCore.nhiCode == "BC22659100")
    }

    @Test("驗證通過（無 TW Core 特定 SHALL 欄位）")
    func validateSuccess() {
        let med = Medication()
        guard case .success = med.validateTWCore() else {
            Issue.record("驗證應通過"); return
        }
    }

    @Test("宣告 Profile")
    func declareProfile() {
        var med = Medication()
        med.twCore.declareProfile()
        #expect(med.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.medication)
    }
}

// MARK: - MedicationRequest

@Suite("MedicationRequest TW Core")
struct MedicationRequestTests {

    @Test("設定與讀取 FDA 藥品代碼")
    func medicationFdaCode() {
        var req = MedicationRequest(
            intent: FHIRPrimitive(.order),
            medication: .codeableConcept(CodeableConcept()),
            status: FHIRPrimitive(.active),
            subject: Reference()
        )
        req.twCore.setMedicationCode("AC37611100", system: TWCoreURL.MedicationCode.fda)
        #expect(req.twCore.medicationCode(system: TWCoreURL.MedicationCode.fda) == "AC37611100")
    }

    @Test("設定與讀取 NHI 藥品代碼（含文字）")
    func medicationNhiCodeWithText() {
        var req = MedicationRequest(
            intent: FHIRPrimitive(.order),
            medication: .codeableConcept(CodeableConcept()),
            status: FHIRPrimitive(.active),
            subject: Reference()
        )
        req.twCore.setMedicationCode("BC22659100", system: TWCoreURL.MedicationCode.nhi, text: "阿莫西林")
        #expect(req.twCore.medicationCode(system: TWCoreURL.MedicationCode.nhi) == "BC22659100")
    }

    @Test("設定與讀取識別碼")
    func identifier() {
        var req = MedicationRequest(
            intent: FHIRPrimitive(.order),
            medication: .codeableConcept(CodeableConcept()),
            status: FHIRPrimitive(.active),
            subject: Reference()
        )
        let system = "https://hospital.example.com/sid/rx"
        req.twCore.setIdentifier("RX20240601001", system: system)
        #expect(req.twCore.identifier(system: system) == "RX20240601001")
    }

    @Test("驗證通過（無 TW Core 特定 SHALL 欄位）")
    func validateSuccess() {
        let req = MedicationRequest(
            intent: FHIRPrimitive(.order),
            medication: .codeableConcept(CodeableConcept()),
            status: FHIRPrimitive(.active),
            subject: Reference()
        )
        guard case .success = req.validateTWCore() else {
            Issue.record("驗證應通過"); return
        }
    }

    @Test("宣告 Profile")
    func declareProfile() {
        var req = MedicationRequest(
            intent: FHIRPrimitive(.order),
            medication: .codeableConcept(CodeableConcept()),
            status: FHIRPrimitive(.active),
            subject: Reference()
        )
        req.twCore.declareProfile()
        #expect(req.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.medicationRequest)
    }
}

// MARK: - MedicationDispense

@Suite("MedicationDispense TW Core")
struct MedicationDispenseTests {

    @Test("設定與讀取 FDA 藥品代碼")
    func medicationFdaCode() {
        var disp = MedicationDispense(
            medication: .codeableConcept(CodeableConcept()),
            status: FHIRPrimitive(.completed)
        )
        disp.twCore.setMedicationCode("AC37611100", system: TWCoreURL.MedicationCode.fda)
        #expect(disp.twCore.medicationCode(system: TWCoreURL.MedicationCode.fda) == "AC37611100")
    }

    @Test("驗證失敗：缺少 subject")
    func validateMissingSubject() {
        let disp = MedicationDispense(
            medication: .codeableConcept(CodeableConcept()),
            status: FHIRPrimitive(.completed)
        )
        guard case .failure(let error) = disp.validateTWCore() else {
            Issue.record("應回傳 failure"); return
        }
        #expect(error == .missingRequiredField("MedicationDispense.subject"))
    }

    @Test("驗證通過：有 subject")
    func validateSuccess() {
        var disp = MedicationDispense(
            medication: .codeableConcept(CodeableConcept()),
            status: FHIRPrimitive(.completed)
        )
        disp.subject = Reference(reference: "Patient/123".fhirString)
        guard case .success = disp.validateTWCore() else {
            Issue.record("驗證應通過"); return
        }
    }

    @Test("宣告 Profile")
    func declareProfile() {
        var disp = MedicationDispense(
            medication: .codeableConcept(CodeableConcept()),
            status: FHIRPrimitive(.completed)
        )
        disp.twCore.declareProfile()
        #expect(disp.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.medicationDispense)
    }
}

// MARK: - MedicationStatement

@Suite("MedicationStatement TW Core")
struct MedicationStatementTests {

    @Test("設定與讀取 NHI 藥品代碼")
    func medicationNhiCode() {
        var stmt = MedicationStatement(
            medication: .codeableConcept(CodeableConcept()),
            status: FHIRPrimitive(.active),
            subject: Reference()
        )
        stmt.twCore.setMedicationCode("BC22659100", system: TWCoreURL.MedicationCode.nhi)
        #expect(stmt.twCore.medicationCode(system: TWCoreURL.MedicationCode.nhi) == "BC22659100")
    }

    @Test("設定與讀取識別碼")
    func identifier() {
        var stmt = MedicationStatement(
            medication: .codeableConcept(CodeableConcept()),
            status: FHIRPrimitive(.active),
            subject: Reference()
        )
        let system = "https://hospital.example.com/sid/stmt"
        stmt.twCore.setIdentifier("STMT001", system: system)
        #expect(stmt.twCore.identifier(system: system) == "STMT001")
    }

    @Test("驗證通過（無 TW Core 特定 SHALL 欄位）")
    func validateSuccess() {
        let stmt = MedicationStatement(
            medication: .codeableConcept(CodeableConcept()),
            status: FHIRPrimitive(.active),
            subject: Reference()
        )
        guard case .success = stmt.validateTWCore() else {
            Issue.record("驗證應通過"); return
        }
    }

    @Test("宣告 Profile")
    func declareProfile() {
        var stmt = MedicationStatement(
            medication: .codeableConcept(CodeableConcept()),
            status: FHIRPrimitive(.active),
            subject: Reference()
        )
        stmt.twCore.declareProfile()
        #expect(stmt.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.medicationStatement)
    }
}
