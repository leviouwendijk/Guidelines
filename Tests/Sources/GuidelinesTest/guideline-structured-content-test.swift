import DSL
import Guidelines

func structuredContentAuthoringTest() throws {
    let content = GuidelineContent(
        title: "Structured content",
        summary: "Guidelines author the shared structured content model directly."
    ) {
        paragraph(
            "Paragraph"
        )

        code(
            language: "swift",
            content: "let value = 1"
        )

        quote(
            "Quoted"
        )

        list(
            style: .ordered,
            items: [
                "First",
                "Second",
            ]
        )

        example(
            "Example"
        ) {
            paragraph(
                "Nested example"
            )
        }

        section(
            "Details"
        ) {
            paragraph(
                "Nested section"
            )
        }
    }

    guard
        case .collection(
            let explanation
        ) = content.explanation
    else {
        throw TestFailure.expectationFailed(
            "multiple authored blocks should form one structured collection"
        )
    }

    try expect(
        explanation.count,
        equals: 6,
        "all authored guideline blocks should remain distinct structured values"
    )

    guard
        case .paragraph(
            let paragraphContent
        ) = explanation[0]
    else {
        throw TestFailure.expectationFailed(
            "paragraph should be authored directly as StructuredContent"
        )
    }

    try expect(
        paragraphContent,
        equals: [
            StructuredContent.Inline.text(
                "Paragraph"
            ),
        ],
        "paragraph should preserve structured inline content"
    )

    guard
        case .quote(
            let quote
        ) = explanation[2],
        case .paragraph(
            let quotedParagraph
        ) = quote
    else {
        throw TestFailure.expectationFailed(
            "quote should recursively contain structured content"
        )
    }

    try expect(
        quotedParagraph,
        equals: [
            StructuredContent.Inline.text(
                "Quoted"
            ),
        ],
        "quote should preserve its nested paragraph"
    )

    guard
        case .list(
            let style,
            let items
        ) = explanation[3]
    else {
        throw TestFailure.expectationFailed(
            "list should be authored directly as StructuredContent"
        )
    }

    try expect(
        style,
        equals: StructuredContent.ListStyle.ordered,
        "list style should use the shared DSL type directly"
    )

    try expect(
        items.count,
        equals: 2,
        "list items should be recursive structured content values"
    )

    guard
        case .paragraph = items[0],
        case .paragraph = items[1]
    else {
        throw TestFailure.expectationFailed(
            "simple guideline list items should author as structured paragraphs"
        )
    }

    guard
        case .group(
            let exampleRole,
            let exampleTitle,
            let exampleContent
        ) = explanation[4]
    else {
        throw TestFailure.expectationFailed(
            "example should use a semantic structured-content group"
        )
    }

    try expect(
        exampleRole?.rawValue,
        equals: Optional(
            "guidelines.example"
        ),
        "example semantics should survive through the domain role"
    )

    try expect(
        exampleTitle,
        equals: Optional(
            [
                StructuredContent.Inline.text(
                    "Example"
                ),
            ]
        ),
        "example title should remain structured inline content"
    )

    guard
        case .paragraph = exampleContent
    else {
        throw TestFailure.expectationFailed(
            "single nested example content should remain its direct structured value"
        )
    }

    guard
        case .group(
            let sectionRole,
            let sectionTitle,
            let sectionContent
        ) = explanation[5]
    else {
        throw TestFailure.expectationFailed(
            "section should use a structural group"
        )
    }

    try expect(
        sectionRole,
        equals: Optional<StructuredContent.Role>.none,
        "ordinary sections should not invent a semantic role"
    )

    try expect(
        sectionTitle,
        equals: Optional(
            [
                StructuredContent.Inline.text(
                    "Details"
                ),
            ]
        ),
        "section title should remain structured inline content"
    )

    guard
        case .paragraph = sectionContent
    else {
        throw TestFailure.expectationFailed(
            "single nested section content should remain its direct structured value"
        )
    }

    let single = GuidelineContent(
        title: "Single",
        summary: "Single child"
    ) {
        paragraph(
            "Only"
        )
    }

    guard
        case .paragraph = single.explanation
    else {
        throw TestFailure.expectationFailed(
            "a single authored value should not gain a meaningless collection wrapper"
        )
    }
}
