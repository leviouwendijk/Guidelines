enum IdentifierGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
    case descriptive_names

    var content: GuidelineContent {
        switch self {
        case .descriptive_names:
            .init(
                title: "Prefer identifier over ID abbreviations",
                summary: #"""
                When a value has an Identifier domain type, prefer
                call-site names such as myIdentifier rather than
                shortening the concept to myID.
                """#
            ) {
            paragraph(
                #"""
                You may be tempted to make an Identifier type for something, like MyIdentifier.
                """#
            )

            paragraph(
                #"""
                Generally we prefer to then do: myIdentifier in callsites, not myID.
                """#
            )
            }
        }
    }
}
