import Testing
import ModelsR4
@testable import TWCoreFHIRModels

@Suite("Patient TW Core")
struct PatientTests {

    // MARK: - 身分識別碼

    @Test("設定與讀取身分證字號")
    func idCardNumber() {
        var patient = Patient()
        patient.twCore.idCardNumber = "A123456789"
        #expect(patient.twCore.idCardNumber == "A123456789")
    }

    @Test("更新身分證字號不增加重複 identifier")
    func updateIdCardNumber() {
        var patient = Patient()
        patient.twCore.idCardNumber = "A123456789"
        patient.twCore.idCardNumber = "B987654321"
        #expect(patient.twCore.idCardNumber == "B987654321")
        #expect(patient.identifier?.count == 1)
    }

    @Test("清除身分證字號")
    func clearIdCardNumber() {
        var patient = Patient()
        patient.twCore.idCardNumber = "A123456789"
        patient.twCore.idCardNumber = nil
        #expect(patient.twCore.idCardNumber == nil)
        #expect(patient.identifier?.isEmpty == true)
    }

    @Test("設定與讀取護照號碼")
    func passportNumber() {
        var patient = Patient()
        patient.twCore.passportNumber = "888800371"
        #expect(patient.twCore.passportNumber == "888800371")
    }

    @Test("設定與讀取居留證號碼")
    func residentNumber() {
        var patient = Patient()
        patient.twCore.residentNumber = "A912345678"
        #expect(patient.twCore.residentNumber == "A912345678")
    }

    @Test("設定與讀取病歷號")
    func medicalRecord() {
        var patient = Patient()
        let hospitalSystem = "https://www.example-hospital.com.tw/sid/MR"
        patient.twCore.setMedicalRecord("8862168", system: hospitalSystem)
        #expect(patient.twCore.medicalRecord(system: hospitalSystem) == "8862168")
    }

    @Test("多種 identifier 並存且獨立")
    func multipleIdentifiers() {
        var patient = Patient()
        patient.twCore.idCardNumber = "A123456789"
        patient.twCore.passportNumber = "888800371"
        #expect(patient.identifier?.count == 2)
        #expect(patient.twCore.idCardNumber == "A123456789")
        #expect(patient.twCore.passportNumber == "888800371")
    }

    // MARK: - Identifier 結構正確性

    @Test("身分證 identifier 的 system、use、type.coding 正確")
    func idCardIdentifierStructure() {
        var patient = Patient()
        patient.twCore.idCardNumber = "A123456789"
        let id = patient.identifier?.first
        #expect(id?.system?.value?.url.absoluteString == "http://www.moi.gov.tw")
        #expect(id?.use?.value == .official)
        #expect(id?.type?.coding?.first?.system?.value?.url.absoluteString == "http://terminology.hl7.org/CodeSystem/v2-0203")
        #expect(id?.type?.coding?.first?.code?.value?.string == "NNxxx")
    }

    @Test("身分證 identifier code 帶有 identifier-suffix extension")
    func idCardIdentifierSuffix() {
        var patient = Patient()
        patient.twCore.idCardNumber = "A123456789"
        let codeExt = patient.identifier?.first?.type?.coding?.first?.code?.extension?.first
        #expect(codeExt?.url.value?.url.absoluteString == TWCoreURL.Extension.identifierSuffix)
        if case .string(let val) = codeExt?.value {
            #expect(val.value?.string == "TWN")
        } else {
            Issue.record("identifier-suffix extension 應為 .string 型別")
        }
    }

    // MARK: - Profile

    @Test("宣告 TW Core Patient Profile")
    func declareProfile() {
        var patient = Patient()
        patient.twCore.declareProfile()
        let profileURL = patient.meta?.profile?.first?.value?.url.absoluteString
        #expect(profileURL == "https://twcore.mohw.gov.tw/ig/twcore/StructureDefinition/Patient-twcore")
    }

    @Test("重複宣告 Profile 不重複加入")
    func declareProfileIdempotent() {
        var patient = Patient()
        patient.twCore.declareProfile()
        patient.twCore.declareProfile()
        #expect(patient.meta?.profile?.count == 1)
    }

    // MARK: - Validation

    @Test("驗證通過：必填欄位完整")
    func validateSuccess() {
        var patient = Patient()
        patient.twCore.idCardNumber = "A123456789"
        patient.gender = FHIRPrimitive(.male)
        patient.birthDate = FHIRPrimitive(FHIRDate(year: 1990, month: 1, day: 1))
        guard case .success = patient.validateTWCore() else {
            Issue.record("驗證應通過")
            return
        }
    }

    @Test("驗證失敗：缺少 identifier")
    func validateMissingIdentifier() {
        var patient = Patient()
        patient.gender = FHIRPrimitive(.male)
        patient.birthDate = FHIRPrimitive(FHIRDate(year: 1990, month: 1, day: 1))
        guard case .failure(let error) = patient.validateTWCore() else {
            Issue.record("應回傳 failure")
            return
        }
        #expect(error == .missingRequiredField("Patient.identifier"))
    }

    @Test("驗證失敗：缺少 gender")
    func validateMissingGender() {
        var patient = Patient()
        patient.twCore.idCardNumber = "A123456789"
        patient.birthDate = FHIRPrimitive(FHIRDate(year: 1990, month: 1, day: 1))
        guard case .failure(let error) = patient.validateTWCore() else {
            Issue.record("應回傳 failure")
            return
        }
        #expect(error == .missingRequiredField("Patient.gender"))
    }

    @Test("驗證失敗：缺少 birthDate")
    func validateMissingBirthDate() {
        var patient = Patient()
        patient.twCore.idCardNumber = "A123456789"
        patient.gender = FHIRPrimitive(.male)
        guard case .failure(let error) = patient.validateTWCore() else {
            Issue.record("應回傳 failure")
            return
        }
        #expect(error == .missingRequiredField("Patient.birthDate"))
    }
}
