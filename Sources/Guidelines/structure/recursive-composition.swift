public enum RecursiveCompositionGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
    case relative_recursive_boundaries

    public var content: GuidelineContent {
        switch self {
        case .relative_recursive_boundaries:
            .init(
                title: "Apply the operational discipline recursively at meaningful boundaries",
                summary: #"""
                Treat intent, resolution, preparation, effects, observation, outcome,
                and adaptation as roles relative to each operation, including libraries
                that themselves act as adapters for another domain.
                """#
            ) {
                paragraph(
                    #"""
                    The operational model is recursive.
                    """#
                )

                paragraph(
                    #"""
                    A library that serves as an adapter or presentation dependency at one architectural level may itself contain operations following the same discipline internally.
                    """#
                )

                paragraph(
                    #"""
                    For example:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    SBM
                        uses Terminal as presentation
                    """#
                )

                paragraph(
                    #"""
                    while Terminal may internally have:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    RenderInput
                        ↓
                    RenderPlan
                        ↓
                    Renderer
                        ↓
                    RenderResult
                    """#
                )

                paragraph(
                    #"""
                    Likewise:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    Accounting
                        uses a PDF DSL as an output adapter
                    """#
                )

                paragraph(
                    #"""
                    while the PDF system may internally have:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    input
                        ↓
                    resolved layout
                        ↓
                    render plan
                        ↓
                    render events
                        ↓
                    render result
                    """#
                )

                paragraph(
                    #"""
                    This is not conceptually circular.
                    """#
                )

                paragraph(
                    #"""
                    It is recursive composition.
                    """#
                )

                paragraph(
                    #"""
                    At every meaningful boundary we can ask:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    what is intent?
                    what requires resolution?
                    what is preparation?
                    what performs effects?
                    what is observation?
                    what is authoritative output?
                    what is adaptation?
                    """#
                )

                paragraph(
                    #"""
                    The answers are relative to the operation being considered.
                    """#
                )

                paragraph(
                    #"""
                    This is why the model is more useful as a structural discipline than as one universal inheritance hierarchy.
                    """#
                )
            }
        }
    }
}
