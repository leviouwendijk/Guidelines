public struct GuidelineContent:
    Sendable,
    Hashable
{
    public let title: String
    public let summary: String
    public let explanation: [Block]

    public init(
        title: String,
        summary: String,
        explanation: [Block]
    ) {
        self.title = title
        self.summary = summary
        self.explanation = explanation
    }

    public init(
        title: String,
        summary: String,
        @GuidelineBlockBuilder explanation: () -> [Block]
    ) {
        self.init(
            title: title,
            summary: summary,
            explanation: explanation()
        )
    }
}

public extension GuidelineContent {
    enum Block:
        Sendable,
        Hashable
    {
        case paragraph(String)

        case code(
            language: String?,
            content: String
        )

        case quote(String)

        case list(
            style: ListStyle,
            items: [String]
        )

        case example(Example)

        case section(Section)
    }

    enum ListStyle:
        Sendable,
        Hashable
    {
        case unordered
        case ordered
    }

    struct Example:
        Sendable,
        Hashable
    {
        public let title: String?
        public let content: [Block]

        public init(
            title: String? = nil,
            content: [Block]
        ) {
            self.title = title
            self.content = content
        }
    }

    struct Section:
        Sendable,
        Hashable
    {
        public let title: String
        public let content: [Block]

        public init(
            title: String,
            content: [Block]
        ) {
            self.title = title
            self.content = content
        }
    }
}
