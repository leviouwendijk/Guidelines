public enum OperationalArchitectureGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
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
                presentation where those distinctions are independently meaningful; do not
                treat conceptual roles as mandatory layers.
                """#
            ) {
                paragraph(
                    #"""
                    The general structural discipline is:
                    """#
                )

                quote(
                    #"""
                    Design operations so intent, preparation, execution, observation, outcome, and presentation are separable at meaningful boundaries. Collapse the layers when the operation is simple; preserve them when separating them increases determinism, inspectability, reuse, readability, or adaptability.
                    """#
                )

                paragraph(
                    #"""
                    This is a general operational architecture rather than an Agentic-specific architecture.
                    """#
                )

                paragraph(
                    #"""
                    The same domain operation should be usable from:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    CLI
                    GUI
                    server
                    scheduled process
                    Agentic tool
                    test flow
                    another Swift library
                    """#
                )

                paragraph(
                    #"""
                    without its actual domain implementation unnecessarily depending on those consumers.
                    """#
                )

                paragraph(
                    #"""
                    The architecture applies to meaningful operational boundaries.
                    """#
                )

                paragraph(
                    #"""
                    The Operational Model chapter describes how these roles collapse for smaller operations and when a role earns a dedicated type. This chapter is concerned with where meaningful boundaries and dependency direction belong.
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
                    Repeated semantics can justify abstraction without justifying additional operational layers.
                    """#
                )

                paragraph(
                    #"""
                    For example, a repeated decimal tolerance comparison may deserve one canonical reusable function because the same meaning otherwise gets implemented repeatedly.
                    """#
                )

                paragraph(
                    #"""
                    That does not mean the comparison also needs dedicated input and result carrier types.
                    """#
                )

                paragraph(
                    #"""
                    A useful distinction is:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    abstraction
                        centralizes a reusable meaning
                    
                    layering
                        separates independently meaningful stages or representations
                    """#
                )

                paragraph(
                    #"""
                    Both can be useful.
                    """#
                )

                paragraph(
                    #"""
                    Neither automatically implies the other.
                    """#
                )

                paragraph(
                    #"""
                    Prefer centralizing repeated meaning without adding representational ceremony that has no independent value.
                    """#
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
                paragraph(
                    #"""
                    A useful cross-cutting rule is:
                    """#
                )

                quote(
                    #"""
                    Preserve meaningful information and meaningful boundaries; avoid representations that add no independent meaning.
                    """#
                )

                paragraph(
                    #"""
                    This means we should be cautious in both directions.
                    """#
                )

                paragraph(
                    #"""
                    Do not introduce types merely to satisfy an architectural diagram.
                    """#
                )

                paragraph(
                    #"""
                    But also do not collapse a useful semantic result into a narrower representation too early.
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
                    Difference
                        -> reusable DifferenceLayout
                        -> renderer-specific output
                    """#
                )

                paragraph(
                    #"""
                    may preserve useful optionality that would be lost by immediately producing a terminal string.
                    """#
                )

                paragraph(
                    #"""
                    Likewise, normalization that discards information should be intentional and justified by the domain rather than applied mechanically.
                    """#
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
                    Domain code should generally remain usable without the interface that happens to expose it.
                    """#
                )

                paragraph(
                    #"""
                    Prefer:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    domain
                        ↓
                    adapter
                        ↓
                    interface
                    """#
                )

                paragraph(
                    #"""
                    over embedding substantial interface-specific behavior in the domain.
                    """#
                )

                paragraph(
                    #"""
                    Examples:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    Concatenation.Result
                        -> Agentic adapter
                        -> AgentToolResult
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    BuildResult
                        -> Terminal presenter
                        -> ANSI output
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    Accounting.Report
                        -> PDF adapter
                        -> PDF DSL
                    """#
                )

                paragraph(
                    #"""
                    This is a dependency-direction preference, not an absolute prohibition against every lightweight outward-facing protocol conformance.
                    """#
                )

                paragraph(
                    #"""
                    Some intentionally lightweight integration protocols may reasonably be adopted directly by a domain type when the conformance faithfully exposes the same existing domain value and avoids otherwise redundant mirror types or retroactive-conformance boilerplate.
                    """#
                )

                paragraph(
                    #"""
                    See BoundaryAdaptationGuideline.
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
                    Separation does not mean separated concerns can never appear together.
                    """#
                )

                paragraph(
                    #"""
                    An outer orchestration or composition boundary may intentionally coordinate:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    execution
                    events
                    logging
                    presentation
                    process lifecycle
                    interface behavior
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
                    domain operation emits Event
                        ↓
                    CLI command observes Event
                        ↓
                    spinner / terminal presentation
                    """#
                )

                paragraph(
                    #"""
                    The important boundary is that the domain operation does not need the spinner in order to exist.
                    """#
                )

                paragraph(
                    #"""
                    Composition is where independently defined concerns are allowed to meet.
                    """#
                )
            }

        }
    }
}
