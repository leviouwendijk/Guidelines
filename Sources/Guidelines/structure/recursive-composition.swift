public enum RecursiveCompositionGuideline: String, Sendable, Hashable, CaseIterable {
    case relative_recursive_boundaries

    public var content: GuidelineContent {
        switch self {
        case .relative_recursive_boundaries:
            .init(
                title: "Apply the operational discipline recursively at meaningful boundaries",
                summary: #"""
                Treat intent, resolution, preparation, effects, observation, outcome, and
                adaptation as roles relative to each operation, including libraries that
                themselves act as adapters for another domain.
                """#
            ) {
                paragraph(
                    #"""
                    Operational roles are relative to the operation being considered. A library that acts as an adapter or presentation dependency at one architectural level may itself contain domain operations with their own meaningful internal boundaries.
                    """#
                )

                example("A presentation dependency may have its own operational model") {
                    code(
                        language: "text",
                        content: #"""
                        SBM
                            uses Terminal as presentation

                        Terminal internally
                            RenderInput
                                ↓
                            RenderPlan
                                ↓
                            Renderer
                                ↓
                            RenderResult
                        """#
                    )
                }

                example("An output adapter may itself be a domain") {
                    code(
                        language: "text",
                        content: #"""
                        Accounting
                            uses a PDF DSL as an output adapter

                        PDF system internally
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
                }

                paragraph(
                    #"""
                    This is recursive composition rather than conceptual circularity. At each meaningful boundary, ask the operational questions relative to that operation.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "What is the intent?",
                        "What requires resolution?",
                        "What preparation or planning is meaningful?",
                        "What performs effects?",
                        "What observations are temporal?",
                        "What is the authoritative outcome?",
                        "What adaptation belongs outward?",
                    ]
                )

                quote(
                    #"""
                    The answers are relative to the operation; the model is a structural discipline, not one universal inheritance hierarchy.
                    """#
                )
            }
        }
    }
}
