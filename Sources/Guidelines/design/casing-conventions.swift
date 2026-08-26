public enum CasingConventionGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
    case contextual_style
    case external_facing_names

    public var content: GuidelineContent {
        switch self {
        case .contextual_style:
            SnakeOrCamelGuideline.contextual_style.content

        case .external_facing_names:
            CasingGuideline.io_facing_casing.content
        }
    }
}
