import Testing
import ModelsR4
@testable import TWCoreFHIRModels

// MARK: - Bundle

@Suite("Bundle TW Core")
struct BundleTWCoreTests {

    @Test("宣告通用 Profile")
    func declareProfile() {
        var bundle = ModelsR4.Bundle(type: FHIRPrimitive(.document))
        bundle.twCore.declareProfile()
        #expect(bundle.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.bundle)
    }

    @Test("宣告文件包 Profile")
    func declareBundleDocumentProfile() {
        var bundle = ModelsR4.Bundle(type: FHIRPrimitive(.document))
        bundle.twCore.declareBundleDocumentProfile()
        #expect(bundle.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.bundleDocument)
    }

    @Test("宣告訊息包 Profile")
    func declareBundleMessageProfile() {
        var bundle = ModelsR4.Bundle(type: FHIRPrimitive(.message))
        bundle.twCore.declareBundleMessageProfile()
        #expect(bundle.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.bundleMessage)
    }

    @Test("文件包驗證失敗：缺少 identifier")
    func validateDocumentMissingIdentifier() {
        let bundle = ModelsR4.Bundle(type: FHIRPrimitive(.document))
        guard case .failure(let error) = bundle.validateTWCoreBundleDocument() else {
            Issue.record("應回傳 failure"); return
        }
        #expect(error == .missingRequiredField("Bundle.identifier"))
    }

    @Test("文件包驗證失敗：缺少 timestamp")
    func validateDocumentMissingTimestamp() {
        var bundle = ModelsR4.Bundle(type: FHIRPrimitive(.document))
        bundle.identifier = Identifier(value: "DOC001".fhirString)
        guard case .failure(let error) = bundle.validateTWCoreBundleDocument() else {
            Issue.record("應回傳 failure"); return
        }
        #expect(error == .missingRequiredField("Bundle.timestamp"))
    }

    @Test("文件包驗證失敗：缺少 entry")
    func validateDocumentMissingEntry() {
        var bundle = ModelsR4.Bundle(type: FHIRPrimitive(.document))
        bundle.identifier = Identifier(value: "DOC001".fhirString)
        bundle.timestamp = FHIRPrimitive(try! Instant("2024-01-01T00:00:00+08:00"))
        guard case .failure(let error) = bundle.validateTWCoreBundleDocument() else {
            Issue.record("應回傳 failure"); return
        }
        #expect(error == .missingRequiredField("Bundle.entry"))
    }

    @Test("文件包驗證通過")
    func validateDocumentSuccess() {
        var bundle = ModelsR4.Bundle(type: FHIRPrimitive(.document))
        bundle.identifier = Identifier(value: "DOC001".fhirString)
        bundle.timestamp = FHIRPrimitive(try! Instant("2024-01-01T00:00:00+08:00"))
        bundle.entry = [BundleEntry()]
        guard case .success = bundle.validateTWCoreBundleDocument() else {
            Issue.record("驗證應通過"); return
        }
    }

    @Test("訊息包驗證通過")
    func validateMessageSuccess() {
        var bundle = ModelsR4.Bundle(type: FHIRPrimitive(.message))
        bundle.identifier = Identifier(value: "MSG001".fhirString)
        bundle.timestamp = FHIRPrimitive(try! Instant("2024-01-01T00:00:00+08:00"))
        bundle.entry = [BundleEntry()]
        guard case .success = bundle.validateTWCoreBundleMessage() else {
            Issue.record("驗證應通過"); return
        }
    }

    @Test("驗證通過（通用）")
    func validateSuccess() {
        let bundle = ModelsR4.Bundle(type: FHIRPrimitive(.document))
        guard case .success = bundle.validateTWCore() else {
            Issue.record("驗證應通過"); return
        }
    }
}

// MARK: - Composition

@Suite("Composition TW Core")
struct CompositionTWCoreTests {

    private func makeComposition() -> Composition {
        Composition(
            author: [Reference()],
            date: FHIRPrimitive(try! DateTime("2024-01-01T00:00:00+08:00")),
            status: FHIRPrimitive(.final),
            title: "測試文件".fhirString,
            type: CodeableConcept()
        )
    }

    @Test("宣告 Profile")
    func declareProfile() {
        var comp = makeComposition()
        comp.twCore.declareProfile()
        #expect(comp.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.composition)
    }

    @Test("驗證通過")
    func validateSuccess() {
        let comp = makeComposition()
        guard case .success = comp.validateTWCore() else {
            Issue.record("驗證應通過"); return
        }
    }
}

// MARK: - DocumentReference

@Suite("DocumentReference TW Core")
struct DocumentReferenceTWCoreTests {

    private func makeDocRef() -> DocumentReference {
        DocumentReference(
            content: [DocumentReferenceContent(attachment: Attachment())],
            status: FHIRPrimitive(.current)
        )
    }

    @Test("設定與讀取識別碼")
    func identifier() {
        var ref = makeDocRef()
        let system = "https://hospital.example.com/sid/docref"
        ref.twCore.setIdentifier("DOC001", system: system)
        #expect(ref.twCore.identifier(system: system) == "DOC001")
    }

    @Test("宣告 Profile")
    func declareProfile() {
        var ref = makeDocRef()
        ref.twCore.declareProfile()
        #expect(ref.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.documentReference)
    }

    @Test("驗證通過")
    func validateSuccess() {
        let ref = makeDocRef()
        guard case .success = ref.validateTWCore() else {
            Issue.record("驗證應通過"); return
        }
    }
}

// MARK: - MessageHeader

@Suite("MessageHeader TW Core")
struct MessageHeaderTWCoreTests {

    private func makeMessageHeader() -> MessageHeader {
        MessageHeader(
            event: .uri("urn:example:event".fhirURI!),
            source: MessageHeaderSource(endpoint: "https://hospital.example.com/msg".fhirURI!)
        )
    }

    @Test("宣告 Profile")
    func declareProfile() {
        var header = makeMessageHeader()
        header.twCore.declareProfile()
        #expect(header.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.messageHeader)
    }

    @Test("驗證通過")
    func validateSuccess() {
        let header = makeMessageHeader()
        guard case .success = header.validateTWCore() else {
            Issue.record("驗證應通過"); return
        }
    }
}

// MARK: - Provenance

@Suite("Provenance TW Core")
struct ProvenanceTWCoreTests {

    private func makeProvenance() -> Provenance {
        Provenance(
            agent: [ProvenanceAgent(who: Reference())],
            recorded: FHIRPrimitive(try! Instant("2024-01-01T00:00:00+08:00")),
            target: [Reference()]
        )
    }

    @Test("宣告 Profile")
    func declareProfile() {
        var prov = makeProvenance()
        prov.twCore.declareProfile()
        #expect(prov.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.provenance)
    }

    @Test("驗證通過")
    func validateSuccess() {
        let prov = makeProvenance()
        guard case .success = prov.validateTWCore() else {
            Issue.record("驗證應通過"); return
        }
    }
}

// MARK: - CarePlan

@Suite("CarePlan TW Core")
struct CarePlanTWCoreTests {

    private func makeCarePlan() -> CarePlan {
        CarePlan(intent: FHIRPrimitive(.plan), status: FHIRPrimitive(.active), subject: Reference())
    }

    @Test("驗證失敗：缺少 category[AssessPlan]")
    func validateMissingCategory() {
        let plan = makeCarePlan()
        guard case .failure(let error) = plan.validateTWCore() else {
            Issue.record("應回傳 failure"); return
        }
        #expect(error == .missingRequiredField("CarePlan.category[AssessPlan]"))
    }

    @Test("驗證通過：有 assess-plan category")
    func validateWithAssessPlanCategory() {
        var plan = makeCarePlan()
        plan.twCore.declareAssessPlanCategory()
        guard case .success = plan.validateTWCore() else {
            Issue.record("驗證應通過"); return
        }
    }

    @Test("declareAssessPlanCategory 冪等性")
    func declareAssessPlanCategoryIdempotent() {
        var plan = makeCarePlan()
        plan.twCore.declareAssessPlanCategory()
        plan.twCore.declareAssessPlanCategory()
        let count = plan.category?.filter { cc in
            cc.coding?.contains {
                $0.system?.absoluteString == TWCoreURL.CarePlanCategory.system &&
                $0.code?.value?.string == TWCoreURL.CarePlanCategory.assessPlan
            } ?? false
        }.count ?? 0
        #expect(count == 1)
    }

    @Test("hasAssessPlanCategory 讀取正確")
    func hasAssessPlanCategory() {
        var plan = makeCarePlan()
        #expect(plan.twCore.hasAssessPlanCategory == false)
        plan.twCore.declareAssessPlanCategory()
        #expect(plan.twCore.hasAssessPlanCategory == true)
    }

    @Test("設定與讀取識別碼")
    func identifier() {
        var plan = makeCarePlan()
        let system = "https://hospital.example.com/sid/careplan"
        plan.twCore.setIdentifier("CP001", system: system)
        #expect(plan.twCore.identifier(system: system) == "CP001")
    }

    @Test("宣告 Profile")
    func declareProfile() {
        var plan = makeCarePlan()
        plan.twCore.declareProfile()
        #expect(plan.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.carePlan)
    }
}

// MARK: - CareTeam

@Suite("CareTeam TW Core")
struct CareTeamTWCoreTests {

    @Test("驗證失敗：缺少 participant")
    func validateMissingParticipant() {
        let team = CareTeam()
        guard case .failure(let error) = team.validateTWCore() else {
            Issue.record("應回傳 failure"); return
        }
        #expect(error == .missingRequiredField("CareTeam.participant"))
    }

    @Test("驗證失敗：participant 缺少 role")
    func validateMissingRole() {
        var team = CareTeam()
        var participant = CareTeamParticipant()
        participant.member = Reference()
        team.participant = [participant]
        guard case .failure(let error) = team.validateTWCore() else {
            Issue.record("應回傳 failure"); return
        }
        #expect(error == .missingRequiredField("CareTeam.participant.role"))
    }

    @Test("驗證失敗：participant 缺少 member")
    func validateMissingMember() {
        var team = CareTeam()
        var participant = CareTeamParticipant()
        participant.role = [CodeableConcept(text: "醫師".fhirString)]
        team.participant = [participant]
        guard case .failure(let error) = team.validateTWCore() else {
            Issue.record("應回傳 failure"); return
        }
        #expect(error == .missingRequiredField("CareTeam.participant.member"))
    }

    @Test("驗證通過：participant 有 role 與 member")
    func validateSuccess() {
        var team = CareTeam()
        var participant = CareTeamParticipant()
        participant.role = [CodeableConcept(text: "醫師".fhirString)]
        participant.member = Reference()
        team.participant = [participant]
        guard case .success = team.validateTWCore() else {
            Issue.record("驗證應通過"); return
        }
    }

    @Test("設定與讀取識別碼")
    func identifier() {
        var team = CareTeam()
        let system = "https://hospital.example.com/sid/careteam"
        team.twCore.setIdentifier("CT001", system: system)
        #expect(team.twCore.identifier(system: system) == "CT001")
    }

    @Test("宣告 Profile")
    func declareProfile() {
        var team = CareTeam()
        team.twCore.declareProfile()
        #expect(team.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.careTeam)
    }
}

// MARK: - Goal

@Suite("Goal TW Core")
struct GoalTWCoreTests {

    private func makeGoal() -> Goal {
        Goal(
            description_fhir: CodeableConcept(text: "血壓控制".fhirString),
            lifecycleStatus: FHIRPrimitive(.active),
            subject: Reference()
        )
    }

    @Test("設定與讀取識別碼")
    func identifier() {
        var goal = makeGoal()
        let system = "https://hospital.example.com/sid/goal"
        goal.twCore.setIdentifier("GOAL001", system: system)
        #expect(goal.twCore.identifier(system: system) == "GOAL001")
    }

    @Test("宣告 Profile")
    func declareProfile() {
        var goal = makeGoal()
        goal.twCore.declareProfile()
        #expect(goal.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.goal)
    }

    @Test("驗證通過")
    func validateSuccess() {
        let goal = makeGoal()
        guard case .success = goal.validateTWCore() else {
            Issue.record("驗證應通過"); return
        }
    }
}

// MARK: - ServiceRequest

@Suite("ServiceRequest TW Core")
struct ServiceRequestTWCoreTests {

    private func makeServiceRequest() -> ServiceRequest {
        ServiceRequest(intent: FHIRPrimitive(.order), status: FHIRPrimitive(.active), subject: Reference())
    }

    @Test("驗證失敗：缺少 code")
    func validateMissingCode() {
        let req = makeServiceRequest()
        guard case .failure(let error) = req.validateTWCore() else {
            Issue.record("應回傳 failure"); return
        }
        #expect(error == .missingRequiredField("ServiceRequest.code"))
    }

    @Test("驗證通過：有 code")
    func validateWithCode() {
        var req = makeServiceRequest()
        req.twCore.setCodeValue("71388002", system: TWCoreURL.ProcedureCode.snomedCT)
        guard case .success = req.validateTWCore() else {
            Issue.record("驗證應通過"); return
        }
    }

    @Test("設定與讀取服務代碼")
    func codeReadWrite() {
        var req = makeServiceRequest()
        req.twCore.setCodeValue("71388002", system: TWCoreURL.ProcedureCode.snomedCT, text: "手術程序")
        #expect(req.twCore.codeValue(system: TWCoreURL.ProcedureCode.snomedCT) == "71388002")
    }

    @Test("設定與讀取識別碼")
    func identifier() {
        var req = makeServiceRequest()
        let system = "https://hospital.example.com/sid/sreq"
        req.twCore.setIdentifier("SR001", system: system)
        #expect(req.twCore.identifier(system: system) == "SR001")
    }

    @Test("宣告 Profile")
    func declareProfile() {
        var req = makeServiceRequest()
        req.twCore.declareProfile()
        #expect(req.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.serviceRequest)
    }
}

// MARK: - ImagingStudy

@Suite("ImagingStudy TW Core")
struct ImagingStudyTWCoreTests {

    private func makeImagingStudy() -> ImagingStudy {
        ImagingStudy(status: FHIRPrimitive(.available), subject: Reference())
    }

    @Test("設定與讀取識別碼")
    func identifier() {
        var study = makeImagingStudy()
        let system = "https://hospital.example.com/sid/imaging"
        study.twCore.setIdentifier("IMG001", system: system)
        #expect(study.twCore.identifier(system: system) == "IMG001")
    }

    @Test("宣告 Profile")
    func declareProfile() {
        var study = makeImagingStudy()
        study.twCore.declareProfile()
        #expect(study.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.imagingStudy)
    }

    @Test("驗證通過")
    func validateSuccess() {
        let study = makeImagingStudy()
        guard case .success = study.validateTWCore() else {
            Issue.record("驗證應通過"); return
        }
    }
}

// MARK: - Media

@Suite("Media TW Core")
struct MediaTWCoreTests {

    private func makeMedia() -> Media {
        Media(content: Attachment(), status: FHIRPrimitive(.completed))
    }

    @Test("設定與讀取識別碼")
    func identifier() {
        var media = makeMedia()
        let system = "https://hospital.example.com/sid/media"
        media.twCore.setIdentifier("MEDIA001", system: system)
        #expect(media.twCore.identifier(system: system) == "MEDIA001")
    }

    @Test("宣告 Profile")
    func declareProfile() {
        var media = makeMedia()
        media.twCore.declareProfile()
        #expect(media.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.media)
    }

    @Test("驗證通過")
    func validateSuccess() {
        let media = makeMedia()
        guard case .success = media.validateTWCore() else {
            Issue.record("驗證應通過"); return
        }
    }
}

// MARK: - Device

@Suite("Device TW Core")
struct DeviceTWCoreTests {

    @Test("宣告 Profile")
    func declareProfile() {
        var device = Device()
        device.twCore.declareProfile()
        #expect(device.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.device)
    }

    @Test("驗證通過")
    func validateSuccess() {
        let device = Device()
        guard case .success = device.validateTWCore() else {
            Issue.record("驗證應通過"); return
        }
    }
}

// MARK: - QuestionnaireResponse

@Suite("QuestionnaireResponse TW Core")
struct QuestionnaireResponseTWCoreTests {

    @Test("宣告 Profile")
    func declareProfile() {
        var qr = QuestionnaireResponse(status: FHIRPrimitive(.completed))
        qr.twCore.declareProfile()
        #expect(qr.meta?.profile?.first?.value?.url.absoluteString == TWCoreURL.Profile.questionnaireResponse)
    }

    @Test("驗證通過")
    func validateSuccess() {
        let qr = QuestionnaireResponse(status: FHIRPrimitive(.completed))
        guard case .success = qr.validateTWCore() else {
            Issue.record("驗證應通過"); return
        }
    }
}
