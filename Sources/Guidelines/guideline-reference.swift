import Primitives
import Schema

public struct GuidelineReference:
    StringIdentifier,
    JSONSchemaProviding
{
    public let rawValue: String

    public init(
        rawValue: String
    ) {
        self.rawValue = rawValue
    }

    public static var jsonschema: JSONSchema {
        .string()
    }
}

public extension GuidelineReference {
    init(
        _ source: some GuidelineReferencing
    ) {
        self.init(
            rawValue: source.reference
        )
    }
}
