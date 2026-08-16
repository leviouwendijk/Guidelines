@resultBuilder
public enum GuidelineBlockBuilder {
    public static func buildExpression(
        _ expression: GuidelineContent.Block
    ) -> [GuidelineContent.Block] {
        [expression]
    }

    public static func buildExpression(
        _ expression: [GuidelineContent.Block]
    ) -> [GuidelineContent.Block] {
        expression
    }

    public static func buildBlock(
        _ components: [GuidelineContent.Block]...
    ) -> [GuidelineContent.Block] {
        components.flatMap { $0 }
    }

    public static func buildOptional(
        _ component: [GuidelineContent.Block]?
    ) -> [GuidelineContent.Block] {
        component ?? []
    }

    public static func buildEither(
        first component: [GuidelineContent.Block]
    ) -> [GuidelineContent.Block] {
        component
    }

    public static func buildEither(
        second component: [GuidelineContent.Block]
    ) -> [GuidelineContent.Block] {
        component
    }

    public static func buildArray(
        _ components: [[GuidelineContent.Block]]
    ) -> [GuidelineContent.Block] {
        components.flatMap { $0 }
    }
}

func paragraph(
    _ content: String
) -> GuidelineContent.Block {
    .paragraph(content)
}

func code(
    language: String? = nil,
    content: String
) -> GuidelineContent.Block {
    .code(
        language: language,
        content: content
    )
}

func quote(
    _ content: String
) -> GuidelineContent.Block {
    .quote(content)
}

func list(
    style: GuidelineContent.ListStyle,
    items: [String]
) -> GuidelineContent.Block {
    .list(
        style: style,
        items: items
    )
}

func example(
    _ title: String? = nil,
    @GuidelineBlockBuilder content: () -> [GuidelineContent.Block]
) -> GuidelineContent.Block {
    .example(
        .init(
            title: title,
            content: content()
        )
    )
}

func section(
    _ title: String,
    @GuidelineBlockBuilder content: () -> [GuidelineContent.Block]
) -> GuidelineContent.Block {
    .section(
        .init(
            title: title,
            content: content()
        )
    )
}
