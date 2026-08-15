public struct Guideline:
    Sendable,
    Hashable,
    GuidelineReferencing
{
    public let identifier: GuidelineIdentifier
    public let title: String
    public let content: String

    public init(
        identifier: GuidelineIdentifier,
        title: String,
        content: String
    ) {
        self.identifier = identifier
        self.title = title
        self.content = content
    }

    public var reference: String {
        identifier.reference
    }
}
