import Foundation
import ModelsR4

// MARK: - Namespace 注入

extension CarePlan {
    public var twCore: TWCoreCarePlanNamespace {
        get { TWCoreCarePlanNamespace(self) }
        set { self = newValue.carePlan }
    }
}

// MARK: - TWCoreCarePlanNamespace

public struct TWCoreCarePlanNamespace {

    var carePlan: CarePlan

    public init(_ carePlan: CarePlan) {
        self.carePlan = carePlan
    }

    // MARK: 照護計畫類別（SHALL）

    /// 是否已設定 assess-plan 類別
    public var hasAssessPlanCategory: Bool {
        carePlan.category?.contains { cc in
            cc.coding?.contains {
                $0.system?.absoluteString == TWCoreURL.CarePlanCategory.system &&
                $0.code?.value?.string == TWCoreURL.CarePlanCategory.assessPlan
            } ?? false
        } ?? false
    }

    /// 設定 TW Core 照護計畫類別（assess-plan）
    public mutating func declareAssessPlanCategory() {
        guard !hasAssessPlanCategory else { return }
        let coding = Coding(
            code: TWCoreURL.CarePlanCategory.assessPlan.fhirString,
            system: TWCoreURL.CarePlanCategory.system.fhirURI
        )
        let category = CodeableConcept(coding: [coding])
        if carePlan.category == nil {
            carePlan.category = [category]
        } else {
            carePlan.category?.append(category)
        }
    }

    // MARK: 識別碼（SHOULD）

    public func identifier(system: String) -> String? {
        carePlan.identifier?.first { $0.system?.absoluteString == system }?.value?.value?.string
    }

    public mutating func setIdentifier(_ value: String?, system: String) {
        if let value {
            let newId = makeIdentifier(value: value, system: system, typeCode: "FILL", typeText: "照護計畫識別碼")
            if let idx = carePlan.identifier?.firstIndex(where: { $0.system?.absoluteString == system }) {
                carePlan.identifier?[idx] = newId
            } else {
                if carePlan.identifier == nil { carePlan.identifier = [newId] }
                else { carePlan.identifier?.append(newId) }
            }
        } else {
            carePlan.identifier?.removeAll { $0.system?.absoluteString == system }
        }
    }

    // MARK: Profile

    public mutating func declareProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.carePlan, on: &carePlan.meta)
    }
}

// MARK: - Validation

extension CarePlan {
    /// 驗證是否符合 TW Core CarePlan 必填欄位規範
    ///
    /// - `category` 須包含 assess-plan 類別（TW Core SHALL：category[AssessPlan] 1..1）
    public func validateTWCore() -> Result<Void, TWCoreValidationError> {
        let hasAssessPlan = category?.contains { cc in
            cc.coding?.contains {
                $0.system?.absoluteString == TWCoreURL.CarePlanCategory.system &&
                $0.code?.value?.string == TWCoreURL.CarePlanCategory.assessPlan
            } ?? false
        } ?? false
        guard hasAssessPlan else {
            return .failure(.missingRequiredField("CarePlan.category[AssessPlan]"))
        }
        return .success(())
    }
}
