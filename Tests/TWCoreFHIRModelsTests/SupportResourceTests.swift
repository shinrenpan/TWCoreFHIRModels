import Testing
import ModelsR4
@testable import TWCoreFHIRModels

// MARK: - Coverage

@Suite("Coverage TW Core")
struct CoverageTests {

    @Test("驗證失敗：缺少 relationship")
    func validateMissingRelationship() {
        let cov = Coverage(
            beneficiary: Reference(),
            payor: [Reference()],
            status: FHIRPrimitive(.active)
        )
        guard case .failure(let error) = cov.validateTWCore() else {
            Issue.record("應回傳 failure"); return
        }
        #expect(error == .missingRequiredField("Coverage.relationship"))
    }

    @Test("驗證失敗：缺少 memberId 與 subscriberId")
    func validateMissingMemberIdAndSubscriberId() {
        var cov = Coverage(
            beneficiary: Reference(),
            payor: [Reference()],
            status: FHIRPrimitive(.active)
        )
        cov.relationship = CodeableConcept(
            coding: [Coding(code: "self".fhirString,
                            system: "http://terminology.hl7.org/CodeSystem/subscriber-relationship".fhirURI)]
        )
        guard case .failure(let error) = cov.validateTWCore() else {
            Issue.record("應回傳 failure"); return
        }
        #expect(error == .missingRequiredField("Coverage.identifier[memberid] 或 Coverage.subscriberId 至少填一項"))
    }

    @Test("驗證通過：有 memberId")
    func validateWithMemberId() {
        var cov = Coverage(
            beneficiary: Reference(),
            payor: [Reference()],
            status: FHIRPrimitive(.active)
        )
        cov.relationship = CodeableConcept(
            coding: [Coding(code: "self".fhirString,
                            system: "http://terminology.hl7.org/CodeSystem/subscriber-relationship".fhirURI)]
        )
        cov.twCore.setMemberId("12345678", system: "https://www.nhi.gov.tw/sid/member")
        guard case .success = cov.validateTWCore() else {
            Issue.record("驗證應通過"); return
        }
    }

    @Test("驗證通過：有 subscriberId")
    func validateWithSubscriberId() {
        var cov = Coverage(
            beneficiary: Reference(),
            payor: [Reference()],
            status: FHIRPrimitive(.active)
        )
        cov.relationship = CodeableConcept(
            coding: [Coding(code: "self".fhirString,
                            system: "http://terminology.hl7.org/CodeSystem/subscriber-relationship".fhirURI)]
        )
        cov.twCore.subscriberId = "A123456789"
        guard case .success = cov.validateTWCore() else {
            Issue.record("驗證應通過"); return
        }
    }

    @Test("設定與讀取 memberId")
    func memberIdReadWrite() {
        var cov = Coverage(
            beneficiary: Reference(),
            payor: [Reference()],
            status: FHIRPrimitive(.active)
        )
        cov.twCore.setMemberId("12345678", system: "https://www.nhi.gov.tw/sid/member")
        #expect(cov.twCore.memberId == "12345678")
    }

    @Test("設定與讀取 subscriberId")
    func subscriberIdReadWrite() {
        var cov = Coverage(
            beneficiary: Reference(),
            payor: [Reference()],
            status: FHIRPrimitive(.active)
        )
        cov.twCore.subscriberId = "A123456789"
        #expect(cov.twCore.subscriberId == "A123456789")
    }

    @Test("宣告 Profile")
    func declareProfile() {
        var cov = Coverage(
            beneficiary: Reference(),
            payor: [Reference()],
            status: FHIRPrimitive(.active)
        )
        cov.twCore.declareProfile()
        #expect(cov.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.coverage)
    }
}

// MARK: - Specimen

@Suite("Specimen TW Core")
struct SpecimenTests {

    @Test("設定與讀取識別碼")
    func identifier() {
        var spec = Specimen()
        let system = "https://hospital.example.com/sid/specimen"
        spec.twCore.setIdentifier("SPEC001", system: system)
        #expect(spec.twCore.identifier(system: system) == "SPEC001")
    }

    @Test("驗證通過（無 TW Core 特定 SHALL 欄位）")
    func validateSuccess() {
        let spec = Specimen()
        guard case .success = spec.validateTWCore() else {
            Issue.record("驗證應通過"); return
        }
    }

    @Test("宣告 Profile")
    func declareProfile() {
        var spec = Specimen()
        spec.twCore.declareProfile()
        #expect(spec.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.specimen)
    }
}

// MARK: - Location

@Suite("Location TW Core")
struct LocationTests {

    @Test("設定與讀取名稱")
    func locationName() {
        var loc = Location()
        loc.twCore.name = "急診室"
        #expect(loc.twCore.name == "急診室")
    }

    @Test("設定與讀取識別碼")
    func identifier() {
        var loc = Location()
        let system = "https://hospital.example.com/sid/location"
        loc.twCore.setIdentifier("LOC001", system: system)
        #expect(loc.twCore.identifier(system: system) == "LOC001")
    }

    @Test("驗證通過（無 TW Core 特定 SHALL 欄位）")
    func validateSuccess() {
        let loc = Location()
        guard case .success = loc.validateTWCore() else {
            Issue.record("驗證應通過"); return
        }
    }

    @Test("宣告 Profile")
    func declareProfile() {
        var loc = Location()
        loc.twCore.declareProfile()
        #expect(loc.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.location)
    }
}

// MARK: - PractitionerRole

@Suite("PractitionerRole TW Core")
struct PractitionerRoleTests {

    @Test("設定與讀取門診科別代碼")
    func consultationSpecialty() {
        var role = PractitionerRole()
        role.twCore.setSpecialty("02", system: TWCoreURL.SpecialtyCode.consultationDepartment)
        #expect(role.twCore.specialty(system: TWCoreURL.SpecialtyCode.consultationDepartment) == "02")
    }

    @Test("設定與讀取住診科別代碼")
    func treatmentSpecialty() {
        var role = PractitionerRole()
        role.twCore.setSpecialty("01", system: TWCoreURL.SpecialtyCode.treatmentDepartment)
        #expect(role.twCore.specialty(system: TWCoreURL.SpecialtyCode.treatmentDepartment) == "01")
    }

    @Test("多個 specialty system 互不干擾")
    func multipleSpecialtySystems() {
        var role = PractitionerRole()
        role.twCore.setSpecialty("02", system: TWCoreURL.SpecialtyCode.consultationDepartment)
        role.twCore.setSpecialty("394814009", system: TWCoreURL.SpecialtyCode.snomedCT)
        #expect(role.twCore.specialty(system: TWCoreURL.SpecialtyCode.consultationDepartment) == "02")
        #expect(role.twCore.specialty(system: TWCoreURL.SpecialtyCode.snomedCT) == "394814009")
    }

    @Test("設定與讀取識別碼")
    func identifier() {
        var role = PractitionerRole()
        let system = "https://hospital.example.com/sid/role"
        role.twCore.setIdentifier("ROLE001", system: system)
        #expect(role.twCore.identifier(system: system) == "ROLE001")
    }

    @Test("驗證通過（無 TW Core 特定 SHALL 欄位）")
    func validateSuccess() {
        let role = PractitionerRole()
        guard case .success = role.validateTWCore() else {
            Issue.record("驗證應通過"); return
        }
    }

    @Test("宣告 Profile")
    func declareProfile() {
        var role = PractitionerRole()
        role.twCore.declareProfile()
        #expect(role.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.practitionerRole)
    }
}

// MARK: - RelatedPerson

@Suite("RelatedPerson TW Core")
struct RelatedPersonTests {

    @Test("驗證失敗：缺少 active")
    func validateMissingActive() {
        let person = RelatedPerson(patient: Reference())
        guard case .failure(let error) = person.validateTWCore() else {
            Issue.record("應回傳 failure"); return
        }
        #expect(error == .missingRequiredField("RelatedPerson.active"))
    }

    @Test("驗證失敗：缺少 name 與 relationship")
    func validateMissingNameAndRelationship() {
        var person = RelatedPerson(patient: Reference())
        person.active = FHIRPrimitive(true)
        guard case .failure(let error) = person.validateTWCore() else {
            Issue.record("應回傳 failure"); return
        }
        #expect(error == .missingRequiredField("RelatedPerson.name 或 RelatedPerson.relationship 至少填一項"))
    }

    @Test("驗證通過：有 name")
    func validateWithName() {
        var person = RelatedPerson(patient: Reference())
        person.active = FHIRPrimitive(true)
        person.name = [HumanName(text: "王小明".fhirString)]
        guard case .success = person.validateTWCore() else {
            Issue.record("驗證應通過"); return
        }
    }

    @Test("驗證通過：有 relationship")
    func validateWithRelationship() {
        var person = RelatedPerson(patient: Reference())
        person.active = FHIRPrimitive(true)
        person.relationship = [CodeableConcept(text: "父母".fhirString)]
        guard case .success = person.validateTWCore() else {
            Issue.record("驗證應通過"); return
        }
    }

    @Test("設定與讀取識別碼")
    func identifier() {
        var person = RelatedPerson(patient: Reference())
        let system = "https://hospital.example.com/sid/related"
        person.twCore.setIdentifier("REL001", system: system)
        #expect(person.twCore.identifier(system: system) == "REL001")
    }

    @Test("宣告 Profile")
    func declareProfile() {
        var person = RelatedPerson(patient: Reference())
        person.twCore.declareProfile()
        #expect(person.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.relatedPerson)
    }
}
