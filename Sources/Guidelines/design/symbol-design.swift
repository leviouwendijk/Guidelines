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
            .init(
                title: "Prefer concise symbols",
                summary: #"""
                Prefer short symbols that remain clear over longer symbols
                that repeat meaning already present in context.
                """#
            ) {
                paragraph(
                    #"""
                    Prefer the shortest symbol that remains immediately clear in its actual scope. A longer name is not more descriptive when most of its words merely restate meaning already supplied by the containing type, access path, parameter label, or neighboring API.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "Remove words that repeat context already established by the parent type or access path.",
                        "Keep enough vocabulary to preserve semantic distinction between neighboring operations or values.",
                        "Do not shorten a symbol into an abbreviation or generic word that forces the reader to reconstruct its meaning.",
                        "Judge concision at the call site, not from the declaration in isolation.",
                    ]
                )

                example("Remove repeated phrasing") {
                    code(
                        language: "swift",
                        content: #"""
                        // Avoid.
                        isAnAllowedTypeToSend

                        // Prefer.
                        isAllowedType
                        """#
                    )

                    paragraph(
                        #"""
                        The shorter form preserves the meaningful distinction while removing filler that does not improve recognition.
                        """#
                    )
                }
            }

        case .descriptive_identifier_names:
            .init(
                title: "Prefer semantic identifier names over abbreviations",
                summary: #"""
                When a value has an Identifier domain type, prefer names such
                as myIdentifier rather than shortening the modeled concept to
                myID merely to save characters.
                """#
            ) {
                paragraph(
                    #"""
                    Name a value after the semantic concept represented by its type. If the domain models an `Identifier`, preserve that vocabulary at the call site rather than silently changing the concept to the abbreviation `ID`.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "Prefer `identifier` when `Identifier` is the modeled domain term.",
                        "Use an abbreviation when the abbreviation itself is the established domain vocabulary, not merely because it is shorter.",
                        "Keep naming consistent across related values so the same modeled concept does not alternate between `identifier`, `id`, and other spellings without semantic reason.",
                    ]
                )

                example("Match the symbol to the domain type") {
                    code(
                        language: "swift",
                        content: #"""
                        struct MyIdentifier: Sendable, Hashable {
                            let rawValue: String
                        }

                        let myIdentifier: MyIdentifier

                        // Avoid when `Identifier` is the actual domain term.
                        let myID: MyIdentifier
                        """#
                    )
                }
            }
        }
    }
}
