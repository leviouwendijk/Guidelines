import Primitives

public struct GuidelineReference:
    StringIdentifier
{
    public let rawValue: String

    public init(
        rawValue: String
    ) {
        self.rawValue = rawValue
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
