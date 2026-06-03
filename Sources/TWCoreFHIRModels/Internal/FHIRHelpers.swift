import Foundation
import ModelsR4

// Module-internal helpers shared across all Resource namespaces.

// MARK: - Identifier builder

func makeIdentifier(
    value: String,
    system: String,
    typeCode: String,
    typeCodeSuffix: String? = nil,
    typeText: String
) -> Identifier {
    var codePrimitive = typeCode.fhirString
    if let suffix = typeCodeSuffix,
       let suffixURL = TWCoreURL.Extension.identifierSuffix.fhirURI {
        let suffixExt = Extension(url: suffixURL, value: .string(suffix.fhirString))
        codePrimitive.extension = [suffixExt]
    }
    let coding = Coding(
        code: codePrimitive,
        display: typeText.fhirString,
        system: TWCoreURL.IdentifierType.system.fhirURI
    )
    let identifierType = CodeableConcept(coding: [coding], text: typeText.fhirString)
    return Identifier(
        system: system.fhirURI,
        type: identifierType,
        use: FHIRPrimitive(.official),
        value: value.fhirString
    )
}

// MARK: - Profile declaration

/// meta.profile 加入 profileURLString（若尚未存在）
func declareProfile(_ profileURLString: String, on meta: inout Meta?) {
    guard let url = URL(string: profileURLString) else { return }
    if meta == nil { meta = Meta() }
    let already = meta?.profile?.contains { $0.value?.url.absoluteString == profileURLString } ?? false
    guard !already else { return }
    let canonical = FHIRPrimitive(Canonical(url))
    if meta?.profile == nil {
        meta?.profile = [canonical]
    } else {
        meta?.profile?.append(canonical)
    }
}

