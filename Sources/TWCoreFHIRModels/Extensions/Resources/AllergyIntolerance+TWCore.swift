import Foundation
import ModelsR4

// MARK: - Namespace 注入

extension AllergyIntolerance {
    public var twCore: TWCoreAllergyIntoleranceNamespace {
        get { TWCoreAllergyIntoleranceNamespace(self) }
        set { self = newValue.allergyIntolerance }
    }
}

// MARK: - TWCoreAllergyIntoleranceNamespace

public struct TWCoreAllergyIntoleranceNamespace {

    var allergyIntolerance: AllergyIntolerance

    public init(_ allergyIntolerance: AllergyIntolerance) {
        self.allergyIntolerance = allergyIntolerance
    }

    // MARK: Profile

    public mutating func declareProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.allergyIntolerance, on: &allergyIntolerance.meta)
    }
}

// MARK: - Validation

extension AllergyIntolerance {
    /// 驗證是否符合 TW Core AllergyIntolerance 必填欄位規範
    ///
    /// 檢查項目：
    /// - `code` 1..
    public func validateTWCore() -> Result<Void, TWCoreValidationError> {
        guard code != nil else {
            return .failure(.missingRequiredField("AllergyIntolerance.code"))
        }
        return .success(())
    }
}
