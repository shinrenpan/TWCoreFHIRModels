import Foundation
import ModelsR4

extension String {
    /// 快速轉換為 FHIR 字串型別
    public var fhirString: FHIRPrimitive<FHIRString> {
        FHIRPrimitive(FHIRString(self))
    }

    /// 快速轉換為 FHIR URI 型別，若非合法 URL 則回傳 nil
    public var fhirURI: FHIRPrimitive<FHIRURI>? {
        guard let url = URL(string: self) else { return nil }
        return FHIRPrimitive(FHIRURI(url))
    }
}

extension FHIRPrimitive where PrimitiveType == FHIRString {
    /// 快速還原為 Swift String
    public var string: String? {
        value?.string
    }
}

extension FHIRPrimitive where PrimitiveType == FHIRURI {
    /// 快速還原為 URL absoluteString
    public var absoluteString: String? {
        value?.url.absoluteString
    }
}
