/// TW Core IG 驗證錯誤型別
public enum TWCoreValidationError: Error, Sendable, Equatable {
    /// 缺少 SHALL 必填欄位，帶入 FHIR path 說明（例如 "Patient.gender"）
    case missingRequiredField(String)
    /// identifier 內的 system 或 value 為空
    case invalidIdentifier(String)
}
