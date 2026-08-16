public struct GuidelineChapter:
    Sendable,
    Hashable,
    GuidelineReferencing
{
    public let area: GuidelineArea
    public let key: String
    public let title: String
    public let introduction: [GuidelineContent.Block]
    public let guidelines: [Guideline]

    public init(
        area: GuidelineArea,
        key: String,
        title: String,
        introduction: [GuidelineContent.Block] = [],
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
        @GuidelineBlockBuilder introduction: () -> [GuidelineContent.Block]
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
