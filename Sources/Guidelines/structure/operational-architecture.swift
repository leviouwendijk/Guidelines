public enum OperationalArchitectureGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
    case meaningful_boundaries
    case abstraction_and_layering_separate
    case roles_not_required_types
    case preserve_meaningful_information
    case dependency_direction
    case composition_roots_join_concerns
    case collapse_when_appropriate

    public var content: GuidelineContent {
        switch self {
        case .meaningful_boundaries:
            .init(
                title: "Use meaningful boundaries, not mandatory layers",
                summary: #"""
                Separate intent, preparation, execution, observation, outcome, and
                presentation where that separation adds value, and collapse roles when a
                smaller representation preserves the same meaning.
                """#
            ) {
                paragraph(
                    #"""
                    The general structural discipline is:
                    """#
                )

                quote(
                    #"""
                    **Design operations so intent, preparation, execution, observation, outcome, and presentation are separable at meaningful boundaries. Collapse the layers when the operation is simple; preserve them when separating them increases determinism, inspectability, reuse, readability, or adaptability.**
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
                    It does not require every function, method, or helper to become an operation object.
                    """#
                )

                paragraph(
                    #"""
                    A small operation may already be expressed completely by:
                    """#
                )

                code(
                    language: "swift",
                    content: #"""
                    Compare.Number.Decimal.exceeds(
                        difference,
                        tolerance: tolerance
                    )
                    """#
                )

                paragraph(
                    #"""
                    Turning the same operation into:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    DecimalComparisonInput
                        -> DecimalComparisonOperation
                        -> DecimalComparisonResult
                    """#
                )

                paragraph(
                    #"""
                    is not automatically more architectural.
                    """#
                )

                paragraph(
                    #"""
                    The additional types should exist only when they carry useful meaning of their own.
                    """#
                )

                paragraph(
                    #"""
                    Examples of reasons a value may earn a type include:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    it has invariants
                    it is reused or passed around
                    it crosses a boundary
                    it needs to be inspected independently
                    it is stored or transported
                    it has a lifecycle beyond one call
                    it improves readability or cohesion
                    it is significant enough that callers benefit from naming it
                    """#
                )

                paragraph(
                    #"""
                    The smallest representation that preserves the meaningful architecture is generally preferred.
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

        case .roles_not_required_types:
            .init(
                title: "Roles",
                summary: #"""
                Treat Input, Resolution, Plan, Preflight, Execution, Event, Result,
                Artifact, and Presentation as architectural roles rather than mandatory
                concrete types.
                """#
            ) {
                paragraph(
                    #"""
                    The richest form of the model is:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    Input
                        ↓
                    Resolution
                        ↓
                    Plan? / Preparation?
                        ↓
                    Preflight?
                        ↓
                    Execution ──────► Event*
                        ↓
                    Result ─────────► Artifact*
                        ↓
                    Projection / Adaptation
                        ↓
                    Presentation / Integration
                    """#
                )

                paragraph(
                    #"""
                    These are roles, not mandatory concrete types.
                    """#
                )

                paragraph(
                    #"""
                    The architecture is a vocabulary for finding meaningful boundaries. It is not a requirement that every operation manufacture an `Input`, `ResolvedInput`, `Plan`, `Preflight`, `Event`, `Result`, and `Presenter`.
                    """#
                )

                paragraph(
                    #"""
                    A role may be represented by:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    a dedicated type
                    an existing domain type
                    a tuple
                    a primitive
                    a helper function
                    a stage internal to another operation
                    """#
                )

                paragraph(
                    #"""
                    depending on the needs of the operation.
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
                    **Preserve meaningful information and meaningful boundaries; avoid representations that add no independent meaning.**
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
                    See `boundary-adaptation.md`.
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

        case .collapse_when_appropriate:
            .init(
                title: "Collapse the model when appropriate",
                summary: #"""
                Use the smallest operational shape that preserves meaningful intent,
                effects, observation, outcome, and presentation boundaries for the
                operation at hand.
                """#
            ) {
                paragraph(
                    #"""
                    A tiny pure operation may remain:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    values -> value
                    """#
                )

                paragraph(
                    #"""
                    or:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    Input -> Result
                    """#
                )

                paragraph(
                    #"""
                    A read or query may be:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    Input -> Resolution -> Result
                    """#
                )

                paragraph(
                    #"""
                    A long-running pure operation may be:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    Input -> Execution -> Events + Result
                    """#
                )

                paragraph(
                    #"""
                    A mutating operation may warrant:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    Input
                        -> Resolution
                        -> Plan
                        -> Preflight
                        -> Execution
                        -> Events
                        -> Result + Artifacts
                    """#
                )

                paragraph(
                    #"""
                    The test is not whether every box exists.
                    """#
                )

                paragraph(
                    #"""
                    The test is whether domain intent, effects, observation, semantic outcome, and outward presentation remain separable where that separation has real value.
                    """#
                )
            }
        }
    }
}
