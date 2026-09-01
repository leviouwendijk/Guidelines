import DSL

@resultBuilder
public enum GuidelineBlockBuilder {
    public static func buildExpression(
        _ expression: StructuredContent
    ) -> [StructuredContent] {
        [expression]
    }

    public static func buildExpression(
        _ expression: [StructuredContent]
    ) -> [StructuredContent] {
        expression
    }

    public static func buildBlock(
        _ components: [StructuredContent]...
    ) -> [StructuredContent] {
        components.flatMap { $0 }
    }

    public static func buildOptional(
        _ component: [StructuredContent]?
    ) -> [StructuredContent] {
        component ?? []
    }

    public static func buildEither(
        first component: [StructuredContent]
    ) -> [StructuredContent] {
        component
    }

    public static func buildEither(
        second component: [StructuredContent]
    ) -> [StructuredContent] {
        component
    }

    public static func buildArray(
        _ components: [[StructuredContent]]
    ) -> [StructuredContent] {
        components.flatMap { $0 }
    }

    public static func buildFinalResult(
        _ component: [StructuredContent]
    ) -> StructuredContent {
        guard
            component.count == 1,
            let content = component.first
        else {
            return .collection(
                component
            )
        }

        return content
    }
}

public func paragraph(
    _ content: String
) -> StructuredContent {
    .paragraph(
        [
            .text(content),
        ]
    )
}

public func code(
    language: String? = nil,
    content: String
) -> StructuredContent {
    .code(
        language: language,
        source: content
    )
}

public func quote(
    _ content: String
) -> StructuredContent {
    .quote(
        .paragraph(
            [
                .text(content),
            ]
        )
    )
}

public func list(
    style: StructuredContent.ListStyle,
    items: [String]
) -> StructuredContent {
    .list(
        style: style,
        items:
            items.map { item in
                .paragraph(
                    [
                        .text(item),
                    ]
                )
            }
    )
}

public func example(
    _ title: String? = nil,
    @GuidelineBlockBuilder content: () -> StructuredContent
) -> StructuredContent {
    .group(
        role:
            GuidelineContent
                .Role
                .example
                .structuredContentRole,
        title:
            title.map { title in
                [
                    .text(title),
                ]
            },
        content: content()
    )
}

public func section(
    _ title: String,
    @GuidelineBlockBuilder content: () -> StructuredContent
) -> StructuredContent {
    .group(
        role: nil,
        title: [
            .text(title),
        ],
        content: content()
    )
}
