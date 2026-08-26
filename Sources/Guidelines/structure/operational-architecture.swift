public enum OperationalArchitectureGuideline: String, Sendable, Hashable, CaseIterable {
    case meaningful_boundaries
    case abstraction_and_layering_separate
    case preserve_meaningful_information
    case dependency_direction
    case composition_roots_join_concerns

    public var content: GuidelineContent {
        switch self {
        case .meaningful_boundaries:
            .init(
                title: "Use meaningful boundaries, not mandatory layers",
                summary: #"""
                Separate intent, preparation, execution, observation, outcome, and
                presentation where those distinctions are independently meaningful;
                do not treat conceptual roles as mandatory layers.
                """#
            ) {
                paragraph(
                    #"""
                    Operational roles are useful because they help us reason about where meaning changes. They are not a requirement that every operation be decomposed into the same fixed stack of types or stages.
                    """#
                )

                quote(
                    #"""
                    Design operations so intent, preparation, execution, observation, outcome, and presentation are separable at meaningful boundaries. Collapse them when the operation is simple; preserve them when separation improves determinism, inspectability, reuse, readability, or adaptability.
                    """#
                )

                example("Keep domain operations usable from different consumers") {
                    code(
                        language: "text",
                        content: #"""
                        domain operation
                            ├── CLI
                            ├── GUI
                            ├── server
                            ├── scheduled process
                            ├── Agentic tool
                            ├── test flow
                            └── another Swift library
                        """#
                    )

                    paragraph(
                        #"""
                        These consumers may compose, observe, or present the same operation differently without forcing the domain implementation itself to depend on each consumer.
                        """#
                    )
                }

                paragraph(
                    #"""
                    The Operational Model chapter governs when conceptual roles deserve dedicated representations and when they should collapse. Operational Architecture instead governs where independently meaningful boundaries and dependency directions belong.
                    """#
                )
            }

        case .abstraction_and_layering_separate:
            .init(
                title: "Abstraction and layering are separate decisions",
                summary: #"""
                Centralize repeated semantics without assuming that every abstraction
                also requires additional operational carrier types or stages.
                """#
            ) {
                paragraph(
                    #"""
                    Repeated semantics may deserve one reusable abstraction even when the operation remains structurally tiny. Conversely, a meaningful operational boundary may deserve separation even when there is little repeated implementation.
                    """#
                )

                example("Centralize meaning without manufacturing layers") {
                    paragraph(
                        #"""
                        A decimal tolerance comparison may deserve one canonical reusable function because otherwise the same comparison semantics are implemented repeatedly. That does not imply that every comparison needs dedicated input, planning, execution, and result carrier types.
                        """#
                    )

                    code(
                        language: "text",
                        content: #"""
                        abstraction
                            centralizes reusable meaning

                        layering
                            separates independently meaningful stages
                            or representations
                        """#
                    )
                }

                list(
                    style: .unordered,
                    items: [
                        "Introduce an abstraction when repeated or independently useful meaning deserves one canonical expression.",
                        "Introduce a layer or carrier when a stage, representation, invariant, ownership boundary, or lifecycle distinction has independent value.",
                        "Do not infer the need for additional operational types merely from the existence of a reusable abstraction.",
                        "Do not avoid a meaningful operational boundary merely because its implementation is currently small.",
                    ]
                )
            }

        case .preserve_meaningful_information:
            .init(
                title: "Preserve meaningful information",
                summary: #"""
                Preserve meaningful information and boundaries while avoiding
                representations that add no independent semantic value.
                """#
            ) {
                quote(
                    #"""
                    Preserve meaningful information and meaningful boundaries; avoid representations that add no independent meaning.
                    """#
                )

                paragraph(
                    #"""
                    This rule protects against both architectural over-modeling and premature collapse. A representation should not exist merely to satisfy a diagram, but useful semantic information should not be discarded simply because one current consumer needs a narrower form.
                    """#
                )

                example("Preserve a reusable projection before rendering") {
                    code(
                        language: "text",
                        content: #"""
                        Difference
                            ↓
                        DifferenceLayout
                            ├── basic renderer
                            ├── terminal renderer
                            └── other consumers
                        """#
                    )

                    paragraph(
                        #"""
                        A reusable `DifferenceLayout` may preserve information and optionality that would be lost by immediately producing a terminal string.
                        """#
                    )
                }

                list(
                    style: .unordered,
                    items: [
                        "Do not introduce types or stages that add no independently useful meaning.",
                        "Do not irreversibly lower a rich semantic value merely because the first consumer needs a narrow representation.",
                        "Treat normalization that discards information as an intentional domain decision rather than a mechanical cleanup step.",
                        "Preserve optionality when several legitimate consumers may need different projections of the same semantic result.",
                    ]
                )
            }

        case .dependency_direction:
            .init(
                title: "Dependency direction",
                summary: #"""
                Keep domain operations generally usable without the interface that
                exposes them, while allowing deliberate lightweight conformances that do
                not distort the domain.
                """#
            ) {
                paragraph(
                    #"""
                    Domain code should generally remain usable without the interface that happens to expose it. Consumer-specific representation and behavior should therefore point inward toward domain meaning rather than forcing that consumer into the semantic core.
                    """#
                )

                example("Adapt domain results outward") {
                    code(
                        language: "text",
                        content: #"""
                        Concatenation.Result
                            ↓
                        Agentic adapter
                            ↓
                        AgentToolResult

                        BuildResult
                            ↓
                        Terminal presenter
                            ↓
                        ANSI output

                        Accounting.Report
                            ↓
                        PDF adapter
                            ↓
                        PDF DSL
                        """#
                    )
                }

                paragraph(
                    #"""
                    This is a strong default rather than an absolute prohibition against every outward-facing dependency. A lightweight integration protocol may reasonably be adopted directly when it faithfully exposes existing domain meaning and an adapter would add representation without meaningful isolation.
                    """#
                )

                paragraph(
                    #"""
                    The Boundary Adaptation chapter governs that exception in more detail, including dependency cost, native conformances, retroactive-conformance cost, and the point at which adaptation becomes substantial enough to belong outward.
                    """#
                )
            }

        case .composition_roots_join_concerns:
            .init(
                title: "Composition roots may join concerns",
                summary: #"""
                Allow outer composition roots to coordinate independently defined
                execution, observation, logging, presentation, lifecycle, and interface
                concerns.
                """#
            ) {
                paragraph(
                    #"""
                    Separation does not mean independently defined concerns can never appear together. Composition roots are precisely where the system may intentionally join them.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "execution",
                        "events and observation",
                        "logging",
                        "presentation",
                        "process lifecycle",
                        "interface behavior",
                    ]
                )

                example("Compose observation with presentation outside the operation") {
                    code(
                        language: "text",
                        content: #"""
                        domain operation emits Event
                            ↓
                        CLI composition observes Event
                            ↓
                        spinner / terminal presentation
                        """#
                    )

                    paragraph(
                        #"""
                        The important boundary is that the domain operation does not require the spinner in order to exist. The composition root joins those independently defined concerns for this particular application.
                        """#
                    )
                }
            }
        }
    }
}
