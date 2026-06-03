import Foundation
import ModelsR4

// MARK: - Namespace 注入

extension Coverage {
    public var twCore: TWCoreCoverageNamespace {
        get { TWCoreCoverageNamespace(self) }
        set { self = newValue.coverage }
    }
}

// MARK: - TWCoreCoverageNamespace

public struct TWCoreCoverageNamespace {

    var coverage: Coverage

    public init(_ coverage: Coverage) {
        self.coverage = coverage
    }

    // MARK: 保險會員 ID（SHOULD，tw-core-9 至少需此或 subscriberId）

    /// 讀取健保會員識別碼（identifier type code = MB）
    public var memberId: String? {
        coverage.identifier?.first {
            $0.type?.coding?.contains { $0.system?.absoluteString == TWCoreURL.IdentifierType.system && $0.code?.value?.string == "MB" } ?? false
        }?.value?.value?.string
    }

    /// 寫入健保會員識別碼（identifier type code = MB）
    public mutating func setMemberId(_ value: String?, system: String) {
        if let value {
            let newId = makeIdentifier(value: value, system: system, typeCode: "MB", typeText: "會員識別碼")
            if let idx = coverage.identifier?.firstIndex(where: {
                $0.type?.coding?.contains { $0.system?.absoluteString == TWCoreURL.IdentifierType.system && $0.code?.value?.string == "MB" } ?? false
            }) {
                coverage.identifier?[idx] = newId
            } else {
                if coverage.identifier == nil { coverage.identifier = [newId] }
                else { coverage.identifier?.append(newId) }
            }
        } else {
            coverage.identifier?.removeAll {
                $0.type?.coding?.contains { $0.system?.absoluteString == TWCoreURL.IdentifierType.system && $0.code?.value?.string == "MB" } ?? false
            }
        }
    }

    // MARK: 保戶 ID（SHOULD，tw-core-9 至少需此或 memberId）

    /// 保戶識別碼（subscriberId）
    public var subscriberId: String? {
        get { coverage.subscriberId?.value?.string }
        set { coverage.subscriberId = newValue?.fhirString }
    }

    // MARK: Profile

    public mutating func declareProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.coverage, on: &coverage.meta)
    }
}

// MARK: - Validation

extension Coverage {
    /// 驗證是否符合 TW Core Coverage 必填欄位規範
    ///
    /// - `relationship` 1..（TW Core SHALL；base FHIR R4 為 0..1）
    /// - `tw-core-9`：identifier[memberid] 或 subscriberId 至少填一項
    public func validateTWCore() -> Result<Void, TWCoreValidationError> {
        guard relationship != nil else {
            return .failure(.missingRequiredField("Coverage.relationship"))
        }
        let hasMemberId = identifier?.contains {
            $0.type?.coding?.contains {
                $0.system?.absoluteString == TWCoreURL.IdentifierType.system && $0.code?.value?.string == "MB"
            } ?? false
        } ?? false
        let hasSubscriberId = subscriberId != nil
        guard hasMemberId || hasSubscriberId else {
            return .failure(.missingRequiredField("Coverage.identifier[memberid] 或 Coverage.subscriberId 至少填一項"))
        }
        return .success(())
    }
}
