import Testing
import ModelsR4
@testable import TWCoreFHIRModels

// MARK: - Procedure

@Suite("Procedure TW Core")
struct ProcedureTests {

    @Test("驗證失敗：缺少 code")
    func validateMissingCode() {
        let proc = Procedure(status: FHIRPrimitive(.completed), subject: Reference())
        guard case .failure(let error) = proc.validateTWCore() else {
            Issue.record("應回傳 failure"); return
        }
        #expect(error == .missingRequiredField("Procedure.code"))
    }

    @Test("驗證通過：有 code")
    func validateSuccess() {
        var proc = Procedure(status: FHIRPrimitive(.completed), subject: Reference())
        proc.twCore.setCodeValue("0BH17EZ", system: TWCoreURL.ProcedureCode.icd10pcs2021)
        guard case .success = proc.validateTWCore() else {
            Issue.record("驗證應通過"); return
        }
    }

    @Test("設定與讀取 ICD-10-PCS 2021 代碼")
    func icd10pcs2021Code() {
        var proc = Procedure(status: FHIRPrimitive(.completed), subject: Reference())
        proc.twCore.setCodeValue("0BH17EZ", system: TWCoreURL.ProcedureCode.icd10pcs2021)
        #expect(proc.twCore.codeValue(system: TWCoreURL.ProcedureCode.icd10pcs2021) == "0BH17EZ")
    }

    @Test("設定與讀取 SNOMED CT 處置代碼")
    func snomedCode() {
        var proc = Procedure(status: FHIRPrimitive(.completed), subject: Reference())
        proc.twCore.setCodeValue("233173007", system: TWCoreURL.ProcedureCode.snomedCT, text: "血液透析")
        #expect(proc.twCore.codeValue(system: TWCoreURL.ProcedureCode.snomedCT) == "233173007")
        #expect(proc.twCore.codeText == "血液透析")
    }

    @Test("多個 code slice 互不干擾")
    func multipleCodeSlices() {
        var proc = Procedure(status: FHIRPrimitive(.completed), subject: Reference())
        proc.twCore.setCodeValue("0BH17EZ", system: TWCoreURL.ProcedureCode.icd10pcs2021)
        proc.twCore.setCodeValue("233173007", system: TWCoreURL.ProcedureCode.snomedCT)
        #expect(proc.twCore.codeValue(system: TWCoreURL.ProcedureCode.icd10pcs2021) == "0BH17EZ")
        #expect(proc.twCore.codeValue(system: TWCoreURL.ProcedureCode.snomedCT) == "233173007")
    }

    @Test("設定與讀取識別碼")
    func identifier() {
        var proc = Procedure(status: FHIRPrimitive(.completed), subject: Reference())
        let system = "https://hospital.example.com/sid/procedure"
        proc.twCore.setIdentifier("PROC001", system: system)
        #expect(proc.twCore.identifier(system: system) == "PROC001")
    }

    @Test("宣告 Profile")
    func declareProfile() {
        var proc = Procedure(status: FHIRPrimitive(.completed), subject: Reference())
        proc.twCore.declareProfile()
        #expect(proc.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.procedure)
    }
}

// MARK: - DiagnosticReport

@Suite("DiagnosticReport TW Core")
struct DiagnosticReportTests {

    @Test("設定與讀取 LOINC 報告代碼")
    func loincCode() {
        var report = DiagnosticReport(
            code: CodeableConcept(),
            status: FHIRPrimitive(.final)
        )
        report.twCore.setCodeValue("58410-2", system: TWCoreURL.ProcedureCode.loinc, text: "CBC")
        #expect(report.twCore.codeValue(system: TWCoreURL.ProcedureCode.loinc) == "58410-2")
        #expect(report.twCore.codeValue(system: TWCoreURL.ObservationCode.loinc) == "58410-2")
    }

    @Test("設定與讀取健保醫療服務代碼")
    func twLaboratoryCode() {
        var report = DiagnosticReport(
            code: CodeableConcept(),
            status: FHIRPrimitive(.final)
        )
        let system = TWCoreURL.ObservationCode.twLaboratoryCategory
        report.twCore.setCodeValue("09001C", system: system)
        #expect(report.twCore.codeValue(system: system) == "09001C")
    }

    @Test("設定與讀取 ICD-10-PCS 2023 代碼")
    func icd10pcs2023Code() {
        var report = DiagnosticReport(
            code: CodeableConcept(),
            status: FHIRPrimitive(.final)
        )
        report.twCore.setCodeValue("BW00ZZZ", system: TWCoreURL.ProcedureCode.icd10pcs2023)
        #expect(report.twCore.codeValue(system: TWCoreURL.ProcedureCode.icd10pcs2023) == "BW00ZZZ")
    }

    @Test("設定與讀取識別碼")
    func identifier() {
        var report = DiagnosticReport(
            code: CodeableConcept(),
            status: FHIRPrimitive(.final)
        )
        let system = "https://hospital.example.com/sid/report"
        report.twCore.setIdentifier("RPT20240601001", system: system)
        #expect(report.twCore.identifier(system: system) == "RPT20240601001")
    }

    @Test("驗證通過（無 TW Core 特定 SHALL 欄位）")
    func validateSuccess() {
        let report = DiagnosticReport(
            code: CodeableConcept(),
            status: FHIRPrimitive(.final)
        )
        guard case .success = report.validateTWCore() else {
            Issue.record("驗證應通過"); return
        }
    }

    @Test("宣告 Profile")
    func declareProfile() {
        var report = DiagnosticReport(
            code: CodeableConcept(),
            status: FHIRPrimitive(.final)
        )
        report.twCore.declareProfile()
        #expect(report.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.diagnosticReport)
    }
}

// MARK: - Immunization

@Suite("Immunization TW Core")
struct ImmunizationTests {

    @Test("設定與讀取 CVX 疫苗代碼")
    func cvxCode() {
        var imm = Immunization(
            occurrence: .dateTime(FHIRPrimitive(DateTime(date: FHIRDate(year: 2024, month: 6, day: 1)))),
            patient: Reference(),
            status: FHIRPrimitive(.completed),
            vaccineCode: CodeableConcept()
        )
        imm.twCore.setVaccineCode("208", system: TWCoreURL.VaccineCode.cvx, display: "COVID-19")
        #expect(imm.twCore.vaccineCode(system: TWCoreURL.VaccineCode.cvx) == "208")
    }

    @Test("設定與讀取 NDC 疫苗代碼")
    func ndcCode() {
        var imm = Immunization(
            occurrence: .dateTime(FHIRPrimitive(DateTime(date: FHIRDate(year: 2024, month: 6, day: 1)))),
            patient: Reference(),
            status: FHIRPrimitive(.completed),
            vaccineCode: CodeableConcept()
        )
        imm.twCore.setVaccineCode("59267-1000-2", system: TWCoreURL.VaccineCode.ndc)
        #expect(imm.twCore.vaccineCode(system: TWCoreURL.VaccineCode.ndc) == "59267-1000-2")
    }

    @Test("CVX 與 NDC 同時存在互不干擾")
    func cvxAndNdcCoexist() {
        var imm = Immunization(
            occurrence: .dateTime(FHIRPrimitive(DateTime(date: FHIRDate(year: 2024, month: 6, day: 1)))),
            patient: Reference(),
            status: FHIRPrimitive(.completed),
            vaccineCode: CodeableConcept()
        )
        imm.twCore.setVaccineCode("208", system: TWCoreURL.VaccineCode.cvx)
        imm.twCore.setVaccineCode("59267-1000-2", system: TWCoreURL.VaccineCode.ndc)
        #expect(imm.twCore.vaccineCode(system: TWCoreURL.VaccineCode.cvx) == "208")
        #expect(imm.twCore.vaccineCode(system: TWCoreURL.VaccineCode.ndc) == "59267-1000-2")
    }

    @Test("設定與讀取識別碼")
    func identifier() {
        var imm = Immunization(
            occurrence: .dateTime(FHIRPrimitive(DateTime(date: FHIRDate(year: 2024, month: 6, day: 1)))),
            patient: Reference(),
            status: FHIRPrimitive(.completed),
            vaccineCode: CodeableConcept()
        )
        let system = "https://hospital.example.com/sid/immunization"
        imm.twCore.setIdentifier("VAC001", system: system)
        #expect(imm.twCore.identifier(system: system) == "VAC001")
    }

    @Test("驗證通過（無 TW Core 特定 SHALL 欄位）")
    func validateSuccess() {
        let imm = Immunization(
            occurrence: .dateTime(FHIRPrimitive(DateTime(date: FHIRDate(year: 2024, month: 6, day: 1)))),
            patient: Reference(),
            status: FHIRPrimitive(.completed),
            vaccineCode: CodeableConcept()
        )
        guard case .success = imm.validateTWCore() else {
            Issue.record("驗證應通過"); return
        }
    }

    @Test("宣告 Profile")
    func declareProfile() {
        var imm = Immunization(
            occurrence: .dateTime(FHIRPrimitive(DateTime(date: FHIRDate(year: 2024, month: 6, day: 1)))),
            patient: Reference(),
            status: FHIRPrimitive(.completed),
            vaccineCode: CodeableConcept()
        )
        imm.twCore.declareProfile()
        #expect(imm.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.immunization)
    }
}
