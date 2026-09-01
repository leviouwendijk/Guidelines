import DSL

public struct GuidelineContent:
    Sendable,
    Hashable
{
    public let title: String
    public let summary: String
    public let explanation: StructuredContent

    public init(
        title: String,
        summary: String,
        explanation: StructuredContent
    ) {
        self.title = title
        self.summary = summary
        self.explanation = explanation
    }

    public init(
        title: String,
        summary: String,
        @GuidelineBlockBuilder explanation: () -> StructuredContent
    ) {
        self.init(
            title: title,
            summary: summary,
            explanation: explanation()
        )
    }
}

public extension GuidelineContent {
    enum Role:
        String,
        Sendable,
        Hashable,
        StructuredContentRoleProviding
    {
        case example = "guidelines.example"
    }
}
