public enum SymbolDesignGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
    case concise_symbols
    case descriptive_identifier_names

    public var content: GuidelineContent {
        switch self {
        case .concise_symbols:
            CasingGuideline.concise_symbols.content

        case .descriptive_identifier_names:
            IdentifierGuideline.descriptive_names.content
        }
    }
}
