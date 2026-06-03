import Testing
import ModelsR4
@testable import TWCoreFHIRModels

// MARK: - Practitioner

@Suite("Practitioner TW Core")
struct PractitionerTests {

    @Test("設定與讀取身分證字號")
    func idCardNumber() {
        var p = Practitioner()
        p.twCore.idCardNumber = "A123456789"
        #expect(p.twCore.idCardNumber == "A123456789")
    }

    @Test("設定與讀取醫師執照號碼")
    func medicalLicense() {
        var p = Practitioner()
        let system = "https://www.mohw.gov.tw/sid/license"
        p.twCore.setMedicalLicense("MD123456", system: system)
        #expect(p.twCore.medicalLicense(system: system) == "MD123456")
    }

    @Test("驗證失敗：缺少 identifier")
    func validateMissingIdentifier() {
        let p = Practitioner()
        guard case .failure(let error) = p.validateTWCore() else {
            Issue.record("應回傳 failure"); return
        }
        #expect(error == .missingRequiredField("Practitioner.identifier"))
    }

    @Test("驗證通過")
    func validateSuccess() {
        var p = Practitioner()
        p.twCore.idCardNumber = "A123456789"
        guard case .success = p.validateTWCore() else {
            Issue.record("驗證應通過"); return
        }
    }

    @Test("宣告 Profile")
    func declareProfile() {
        var p = Practitioner()
        p.twCore.declareProfile()
        #expect(p.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.practitioner)
    }
}

// MARK: - Organization

@Suite("Organization TW Core")
struct OrganizationTests {

    @Test("設定與讀取名稱")
    func organizationName() {
        var org = Organization()
        org.twCore.name = "台灣大學醫學院附設醫院"
        #expect(org.twCore.name == "台灣大學醫學院附設醫院")
    }

    @Test("設定與讀取識別碼")
    func organizationIdentifier() {
        var org = Organization()
        let system = "https://www.nhi.gov.tw/sid/hospital"
        org.twCore.setIdentifier("0401070017", system: system, typeCode: "XX", typeText: "醫事機構代碼")
        #expect(org.twCore.identifier(system: system) == "0401070017")
    }

    @Test("驗證通過：有名稱")
    func validateWithName() {
        var org = Organization()
        org.twCore.name = "測試醫院"
        guard case .success = org.validateTWCore() else {
            Issue.record("驗證應通過"); return
        }
    }

    @Test("驗證失敗：name 和 identifier 皆為空")
    func validateEmpty() {
        let org = Organization()
        guard case .failure = org.validateTWCore() else {
            Issue.record("應回傳 failure"); return
        }
    }

    @Test("宣告 Profile")
    func declareProfile() {
        var org = Organization()
        org.twCore.declareProfile()
        #expect(org.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.organization)
    }
}

// MARK: - Encounter

@Suite("Encounter TW Core")
struct EncounterTests {

    @Test("設定與讀取就診識別碼")
    func encounterIdentifier() {
        var enc = Encounter(class: Coding(), status: FHIRPrimitive(.finished))
        let system = "https://www.example-hospital.com.tw/sid/visit"
        enc.twCore.setIdentifier("V20240601001", system: system)
        #expect(enc.twCore.identifier(system: system) == "V20240601001")
    }

    @Test("驗證失敗：缺少 identifier")
    func validateMissingIdentifier() {
        let enc = Encounter(class: Coding(), status: FHIRPrimitive(.finished))
        guard case .failure(let error) = enc.validateTWCore() else {
            Issue.record("應回傳 failure"); return
        }
        #expect(error == .missingRequiredField("Encounter.identifier"))
    }

    @Test("驗證通過")
    func validateSuccess() {
        var enc = Encounter(class: Coding(), status: FHIRPrimitive(.finished))
        enc.twCore.setIdentifier("V001", system: "https://hospital.example.com/visit")
        guard case .success = enc.validateTWCore() else {
            Issue.record("驗證應通過"); return
        }
    }

    @Test("宣告 Profile")
    func declareProfile() {
        var enc = Encounter(class: Coding(), status: FHIRPrimitive(.finished))
        enc.twCore.declareProfile()
        #expect(enc.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.encounter)
    }
}

// MARK: - Condition

@Suite("Condition TW Core")
struct ConditionTests {

    @Test("驗證失敗：缺少 clinicalStatus")
    func validateMissingClinicalStatus() {
        let cond = Condition(subject: Reference())
        guard case .failure(let error) = cond.validateTWCore() else {
            Issue.record("應回傳 failure"); return
        }
        #expect(error == .missingRequiredField("Condition.clinicalStatus"))
    }

    @Test("驗證失敗：缺少 category")
    func validateMissingCategory() {
        var cond = Condition(subject: Reference())
        cond.clinicalStatus = CodeableConcept(
            coding: [Coding(code: "active".fhirString,
                            system: "http://terminology.hl7.org/CodeSystem/condition-clinical".fhirURI)]
        )
        guard case .failure(let error) = cond.validateTWCore() else {
            Issue.record("應回傳 failure"); return
        }
        #expect(error == .missingRequiredField("Condition.category"))
    }

    @Test("驗證通過")
    func validateSuccess() {
        var cond = Condition(subject: Reference())
        cond.clinicalStatus = CodeableConcept(
            coding: [Coding(code: "active".fhirString,
                            system: "http://terminology.hl7.org/CodeSystem/condition-clinical".fhirURI)]
        )
        cond.category = [CodeableConcept(
            coding: [Coding(code: "problem-list-item".fhirString,
                            system: "http://terminology.hl7.org/CodeSystem/condition-category".fhirURI)]
        )]
        guard case .success = cond.validateTWCore() else {
            Issue.record("驗證應通過"); return
        }
    }

    @Test("宣告 Profile")
    func declareProfile() {
        var cond = Condition(subject: Reference())
        cond.twCore.declareProfile()
        #expect(cond.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.condition)
    }
}

// MARK: - AllergyIntolerance

@Suite("AllergyIntolerance TW Core")
struct AllergyIntoleranceTests {

    @Test("驗證失敗：缺少 code")
    func validateMissingCode() {
        let allergy = AllergyIntolerance(patient: Reference())
        guard case .failure(let error) = allergy.validateTWCore() else {
            Issue.record("應回傳 failure"); return
        }
        #expect(error == .missingRequiredField("AllergyIntolerance.code"))
    }

    @Test("驗證通過")
    func validateSuccess() {
        var allergy = AllergyIntolerance(patient: Reference())
        allergy.code = CodeableConcept(text: "盤尼西林".fhirString)
        guard case .success = allergy.validateTWCore() else {
            Issue.record("驗證應通過"); return
        }
    }

    @Test("宣告 Profile")
    func declareProfile() {
        var allergy = AllergyIntolerance(patient: Reference())
        allergy.twCore.declareProfile()
        #expect(allergy.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.allergyIntolerance)
    }
}

// MARK: - Observation

@Suite("Observation TW Core")
struct ObservationTests {

    @Test("設定生命徵象 category")
    func setVitalSignsCategory() {
        var obs = Observation(code: CodeableConcept(), status: FHIRPrimitive(.final))
        obs.twCore.setVitalSignsCategory()
        #expect(obs.twCore.hasVitalSignsCategory == true)
    }

    @Test("重複設定 category 不重複加入")
    func categoryIdempotent() {
        var obs = Observation(code: CodeableConcept(), status: FHIRPrimitive(.final))
        obs.twCore.setVitalSignsCategory()
        obs.twCore.setVitalSignsCategory()
        let count = obs.category?.filter {
            $0.coding?.contains { $0.code?.value?.string == "vital-signs" } ?? false
        }.count
        #expect(count == 1)
    }

    @Test("設定實驗室 category")
    func setLaboratoryCategory() {
        var obs = Observation(code: CodeableConcept(), status: FHIRPrimitive(.final))
        obs.twCore.setLaboratoryCategory()
        #expect(obs.twCore.hasLaboratoryCategory == true)
    }

    @Test("驗證 VitalSigns 失敗：缺少 category")
    func validateVitalSignsMissingCategory() {
        let obs = Observation(code: CodeableConcept(), status: FHIRPrimitive(.final))
        guard case .failure(let error) = obs.validateTWCoreVitalSigns() else {
            Issue.record("應回傳 failure"); return
        }
        #expect(error == .missingRequiredField("Observation.category[vital-signs]"))
    }

    @Test("驗證 VitalSigns 失敗：缺少 effective")
    func validateVitalSignsMissingEffective() {
        var obs = Observation(code: CodeableConcept(), status: FHIRPrimitive(.final))
        obs.twCore.setVitalSignsCategory()
        guard case .failure(let error) = obs.validateTWCoreVitalSigns() else {
            Issue.record("應回傳 failure"); return
        }
        #expect(error == .missingRequiredField("Observation.effective"))
    }

    @Test("驗證 VitalSigns 通過")
    func validateVitalSignsSuccess() {
        var obs = Observation(code: CodeableConcept(), status: FHIRPrimitive(.final))
        obs.twCore.setVitalSignsCategory()
        obs.effective = .dateTime(FHIRPrimitive(DateTime(date: FHIRDate(year: 2024, month: 6, day: 1))))
        guard case .success = obs.validateTWCoreVitalSigns() else {
            Issue.record("驗證應通過"); return
        }
    }

    @Test("宣告生命徵象 Profile")
    func declareVitalSignsProfile() {
        var obs = Observation(code: CodeableConcept(), status: FHIRPrimitive(.final))
        obs.twCore.declareVitalSignsProfile()
        #expect(obs.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.observationVitalSigns)
    }

    @Test("宣告實驗室結果 Profile")
    func declareLaboratoryResultProfile() {
        var obs = Observation(code: CodeableConcept(), status: FHIRPrimitive(.final))
        obs.twCore.declareLaboratoryResultProfile()
        #expect(obs.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.observationLaboratoryResult)
    }
}

// MARK: - Organization 子型別

private func makeOrgWithUBN() -> Organization {
    var org = Organization()
    let idType = CodeableConcept(coding: [
        Coding(
            code: TWCoreURL.OrganizationSubtype.coIdentifierTypeCode.fhirString,
            system: TWCoreURL.OrganizationSubtype.coIdentifierTypeSystem.fhirURI
        )
    ])
    let id = Identifier(type: idType, value: "12345678".fhirString)
    org.identifier = [id]
    org.type = [CodeableConcept(coding: [
        Coding(
            code: TWCoreURL.OrganizationSubtype.busTypeCode.fhirString,
            system: TWCoreURL.OrganizationSubtype.typeSystem.fhirURI
        )
    ])]
    return org
}

private func makeOrgWithGOI() -> Organization {
    var org = Organization()
    let idType = CodeableConcept(coding: [
        Coding(
            code: TWCoreURL.OrganizationSubtype.govtIdentifierTypeCode.fhirString,
            system: TWCoreURL.OrganizationSubtype.coIdentifierTypeSystem.fhirURI
        )
    ])
    let id = Identifier(type: idType, value: "A99990001".fhirString)
    org.identifier = [id]
    org.type = [CodeableConcept(coding: [
        Coding(
            code: TWCoreURL.OrganizationSubtype.govtTypeCode.fhirString,
            system: TWCoreURL.OrganizationSubtype.typeSystem.fhirURI
        )
    ])]
    return org
}

private func makeOrgWithPRN() -> Organization {
    var org = Organization()
    let idType = CodeableConcept(coding: [
        Coding(
            code: TWCoreURL.OrganizationSubtype.hospIdentifierTypeCode.fhirString,
            system: TWCoreURL.OrganizationSubtype.hospIdentifierTypeSystem.fhirURI
        )
    ])
    let id = Identifier(type: idType, value: "0401070017".fhirString)
    org.identifier = [id]
    return org
}

@Suite("Organization 公司機構子型別")
struct OrganizationCompanyTests {

    @Test("宣告公司機構 Profile URL 正確")
    func companyProfileURL() {
        var org = Organization()
        org.twCore.declareCompanyProfile()
        #expect(org.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.organizationCompany)
    }

    @Test("驗證失敗：缺少 UBN identifier")
    func validateMissingUBN() {
        var org = Organization()
        org.type = [CodeableConcept(coding: [
            Coding(code: TWCoreURL.OrganizationSubtype.busTypeCode.fhirString,
                   system: TWCoreURL.OrganizationSubtype.typeSystem.fhirURI)
        ])]
        guard case .failure(let error) = org.validateTWCoreOrganizationCompany() else {
            Issue.record("應回傳 failure"); return
        }
        #expect(error == .missingRequiredField("Organization.identifier.type[UBN]"))
    }

    @Test("驗證失敗：缺少 bus type")
    func validateMissingBusType() {
        var org = makeOrgWithUBN()
        org.type = nil
        guard case .failure(let error) = org.validateTWCoreOrganizationCompany() else {
            Issue.record("應回傳 failure"); return
        }
        #expect(error == .missingRequiredField("Organization.type[bus]"))
    }

    @Test("驗證通過")
    func validateSuccess() {
        let org = makeOrgWithUBN()
        guard case .success = org.validateTWCoreOrganizationCompany() else {
            Issue.record("驗證應通過"); return
        }
    }
}

@Suite("Organization 政府機構子型別")
struct OrganizationGovernmentTests {

    @Test("宣告政府機構 Profile URL 正確")
    func governmentProfileURL() {
        var org = Organization()
        org.twCore.declareGovernmentProfile()
        #expect(org.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.organizationGovernment)
    }

    @Test("驗證失敗：缺少 GOI identifier")
    func validateMissingGOI() {
        var org = Organization()
        org.type = [CodeableConcept(coding: [
            Coding(code: TWCoreURL.OrganizationSubtype.govtTypeCode.fhirString,
                   system: TWCoreURL.OrganizationSubtype.typeSystem.fhirURI)
        ])]
        guard case .failure(let error) = org.validateTWCoreOrganizationGovernment() else {
            Issue.record("應回傳 failure"); return
        }
        #expect(error == .missingRequiredField("Organization.identifier.type[GOI]"))
    }

    @Test("驗證失敗：缺少 govt type")
    func validateMissingGovtType() {
        var org = makeOrgWithGOI()
        org.type = nil
        guard case .failure(let error) = org.validateTWCoreOrganizationGovernment() else {
            Issue.record("應回傳 failure"); return
        }
        #expect(error == .missingRequiredField("Organization.type[govt]"))
    }

    @Test("驗證通過")
    func validateSuccess() {
        let org = makeOrgWithGOI()
        guard case .success = org.validateTWCoreOrganizationGovernment() else {
            Issue.record("驗證應通過"); return
        }
    }
}

@Suite("Organization 醫院科別子型別")
struct OrganizationHospitalTests {

    @Test("宣告醫院科別 Profile URL 正確")
    func hospitalProfileURL() {
        var org = Organization()
        org.twCore.declareHospitalProfile()
        #expect(org.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.organizationHospital)
    }

    @Test("驗證失敗：缺少 PRN identifier")
    func validateMissingPRN() {
        let org = Organization()
        guard case .failure(let error) = org.validateTWCoreOrganizationHospital() else {
            Issue.record("應回傳 failure"); return
        }
        #expect(error == .missingRequiredField("Organization.identifier.type[PRN]"))
    }

    @Test("驗證通過")
    func validateSuccess() {
        let org = makeOrgWithPRN()
        guard case .success = org.validateTWCoreOrganizationHospital() else {
            Issue.record("驗證應通過"); return
        }
    }
}

// MARK: - Address

@Suite("Address TW Core")
struct AddressTests {

    @Test("設定與讀取村里")
    func village() {
        var addr = Address()
        addr.twCore.village = "龍潭里"
        #expect(addr.twCore.village == "龍潭里")
    }

    @Test("設定與讀取巷弄號")
    func laneAlleyNumber() {
        var addr = Address()
        addr.twCore.lane = "12巷"
        addr.twCore.alley = "3弄"
        addr.twCore.number = "5號"
        #expect(addr.twCore.lane == "12巷")
        #expect(addr.twCore.alley == "3弄")
        #expect(addr.twCore.number == "5號")
    }

    @Test("設定樓層與室號")
    func floorRoom() {
        var addr = Address()
        addr.twCore.floor = "3樓"
        addr.twCore.room = "301室"
        #expect(addr.twCore.floor == "3樓")
        #expect(addr.twCore.room == "301室")
    }

    @Test("清除 extension")
    func clearExtension() {
        var addr = Address()
        addr.twCore.village = "龍潭里"
        addr.twCore.village = nil
        #expect(addr.twCore.village == nil)
    }

    @Test("多個 extension 互不干擾")
    func multipleExtensions() {
        var addr = Address()
        addr.twCore.village = "龍潭里"
        addr.twCore.lane = "12巷"
        #expect(addr.extension?.count == 2)
        #expect(addr.twCore.village == "龍潭里")
        #expect(addr.twCore.lane == "12巷")
    }

    @Test("extension 正確帶入 TW Core URL")
    func extensionURL() {
        var addr = Address()
        addr.twCore.lane = "12巷"
        let extURL = addr.extension?.first?.url.value?.url.absoluteString
        #expect(extURL == TWCoreURL.AddressExtension.lane)
    }
}
