import DSL

public struct GuidelineChapter:
    Sendable,
    Hashable,
    GuidelineReferencing
{
    public let area: GuidelineArea
    public let key: String
    public let title: String
    public let introduction: StructuredContent
    public let guidelines: [Guideline]

    public init(
        area: GuidelineArea,
        key: String,
        title: String,
        introduction: StructuredContent = .collection([]),
        guidelines: [Guideline]
    ) {
        self.area = area
        self.key = key
        self.title = title
        self.introduction = introduction
        self.guidelines = guidelines
    }

    public init(
        area: GuidelineArea,
        key: String,
        title: String,
        guidelines: [Guideline],
        @GuidelineBlockBuilder introduction: () -> StructuredContent
    ) {
        self.init(
            area: area,
            key: key,
            title: title,
            introduction: introduction(),
            guidelines: guidelines
        )
    }

    public var reference: String {
        "\(area.rawValue).\(key)"
    }
}
