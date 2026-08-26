public enum SourceConventionGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
    case no_emoji
    case indentation

    public var content: GuidelineContent {
        switch self {
        case .no_emoji:
            CasingGuideline.no_emoji.content

        case .indentation:
            CasingGuideline.indentation.content
        }
    }
}
