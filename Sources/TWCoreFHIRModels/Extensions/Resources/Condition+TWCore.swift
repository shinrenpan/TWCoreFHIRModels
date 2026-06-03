import Foundation
import ModelsR4

// MARK: - Namespace 注入

extension Condition {
    public var twCore: TWCoreConditionNamespace {
        get { TWCoreConditionNamespace(self) }
        set { self = newValue.condition }
    }
}

// MARK: - TWCoreConditionNamespace

public struct TWCoreConditionNamespace {

    var condition: Condition

    public init(_ condition: Condition) {
        self.condition = condition
    }

    // MARK: Profile

    public mutating func declareProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.condition, on: &condition.meta)
    }
}

// MARK: - Validation

extension Condition {
    /// 驗證是否符合 TW Core Condition 必填欄位規範
    ///
    /// 檢查項目：
    /// - `clinicalStatus` 1..*
    /// - `category` 1..1
    public func validateTWCore() -> Result<Void, TWCoreValidationError> {
        guard clinicalStatus != nil else {
            return .failure(.missingRequiredField("Condition.clinicalStatus"))
        }
        guard let cats = category, !cats.isEmpty else {
            return .failure(.missingRequiredField("Condition.category"))
        }
        return .success(())
    }
}
