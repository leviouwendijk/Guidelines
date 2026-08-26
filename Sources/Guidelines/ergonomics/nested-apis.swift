public enum NestedAPIGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
    case wrapper_domain_operations
    case wrapper_accessors
    case local_child_symbols

    public var content: GuidelineContent {
        switch self {
        case .wrapper_domain_operations:
            NestedAPIDesignGuideline.wrapper_domain_operations.content

        case .wrapper_accessors:
            NestedAPIDesignGuideline.wrapper_accessors.content

        case .local_child_symbols:
            CasingGuideline.nest_repeated_context.content
        }
    }
}
