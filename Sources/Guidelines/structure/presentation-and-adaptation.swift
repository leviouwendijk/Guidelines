public enum PresentationAndAdaptationGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
    case project_after_domain_meaning
    case delay_irreversible_projection
    case shared_projections
    case domain_representation_not_consumer_presentation
    case replaceable_presentation
    case adapt_at_boundaries
    case composition_roots_coordinate
    case presenters_consume_decisions

    public var content: GuidelineContent {
        switch self {
        case .project_after_domain_meaning:
            .init(
                title: "Present and adapt after domain meaning exists",
                summary: #"""
                Project domain results, events, plans, or preflight information outward
                after domain meaning exists instead of letting presenters redo domain
                decisions.
                """#
            ) {
                paragraph(
                    #"""
                    Presentation happens after domain meaning exists.
                    """#
                )

                paragraph(
                    #"""
                    Conceptually:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    Result + Events + maybe Plan/Preflight
                                     ↓
                                  Adapter
                                     ↓
                                 Presenter
                    """#
                )

                paragraph(
                    #"""
                    A presenter or adapter should project domain information outward.
                    """#
                )

                paragraph(
                    #"""
                    It should not generally redo domain decisions.
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
                    BuildResult
                        -> terminal summary
                    
                    BuildEvent
                        -> progress line
                    
                    BuildResult
                        -> JSON response
                    
                    BuildResult
                        -> web response DTO
                    
                    BuildResult
                        -> Agentic tool output
                    
                    BuildResult
                        -> GUI view model
                    """#
                )
            }

        case .delay_irreversible_projection:
            .init(
                title: "Delay irreversible projection",
                summary: #"""
                Preserve reusable structured information until a real consumer requires
                a narrower representation-specific projection.
                """#
            ) {
                paragraph(
                    #"""
                    Prefer retaining reusable structured information until the point where a particular consumer requires a narrower representation.
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
                        ↓
                    DifferenceLayout
                        ├── terminal renderer
                        ├── plain renderer
                        └── other consumers
                    """#
                )

                paragraph(
                    #"""
                    can preserve more architectural flexibility than:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    Difference
                        ↓
                    terminal String
                    """#
                )

                paragraph(
                    #"""
                    The important distinction is not whether an intermediate type is called a result, layout, projection, report, or model.
                    """#
                )

                paragraph(
                    #"""
                    The important distinction is whether it preserves or adds reusable meaning before the final representation-specific lowering step.
                    """#
                )
            }

        case .shared_projections:
            .init(
                title: "Shared projections may be legitimate intermediate models",
                summary: #"""
                Use a shared intermediate projection when it provides real reusable
                enrichment, readability, or boundary value for several consumers, not
                merely hypothetical future flexibility.
                """#
            ) {
                paragraph(
                    #"""
                    Sometimes the domain result is not itself the ideal direct input for every renderer.
                    """#
                )

                paragraph(
                    #"""
                    A shared projection may enrich or reorganize domain information for several later consumers:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    DomainResult
                        ↓
                    SharedProjection
                        ├── Terminal
                        ├── HTML
                        ├── GUI
                        └── Agentic
                    """#
                )

                paragraph(
                    #"""
                    That is a legitimate intermediate boundary when the projection has shared semantic utility.
                    """#
                )

                paragraph(
                    #"""
                    Do not introduce such a layer merely in anticipation of hypothetical consumers.
                    """#
                )

                paragraph(
                    #"""
                    It earns its place through real reuse, enrichment, readability, or boundary value.
                    """#
                )
            }

        case .domain_representation_not_consumer_presentation:
            .init(
                title: "Domain representation is not automatically consumer presentation",
                summary: #"""
                Distinguish stable domain-owned representations from formatting and
                interface state that belong to a particular outward consumer.
                """#
            ) {
                paragraph(
                    #"""
                    A domain type may expose useful stable representations such as:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    relative path
                    display label
                    canonical description
                    structured summary
                    """#
                )

                paragraph(
                    #"""
                    without necessarily becoming coupled to a particular UI.
                    """#
                )

                paragraph(
                    #"""
                    The stronger warning applies to representation policy tied to a specific consumer:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    ANSI color
                    terminal width
                    GUI row state
                    HTTP status formatting
                    localized interface prose
                    Agentic result envelopes
                    """#
                )

                paragraph(
                    #"""
                    The question is whether the representation belongs to the domain or to a particular outward vehicle.
                    """#
                )
            }

        case .replaceable_presentation:
            .init(
                title: "Presentation is replaceable",
                summary: #"""
                A new CLI, GUI, web, Agentic, JSON, or TUI surface should usually
                require a new adapter or presenter rather than a new inner execution
                model.
                """#
            ) {
                paragraph(
                    #"""
                    A healthy domain operation can gain a new presentation surface without changing its actual execution model.
                    """#
                )

                paragraph(
                    #"""
                    Adding:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    CLI
                    GUI
                    web API
                    Agentic
                    JSON
                    TUI
                    """#
                )

                paragraph(
                    #"""
                    should usually mean adding an adapter or presenter, not teaching the inner operation about the new consumer.
                    """#
                )
            }

        case .adapt_at_boundaries:
            .init(
                title: "Adaptation occurs at boundaries",
                summary: #"""
                Perform substantial semantic translation between domain results and
                consumer types at explicit boundaries rather than embedding
                consumer-specific state in the result.
                """#
            ) {
                paragraph(
                    #"""
                    Prefer:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    Domain.Result
                        -> ConsumerAdapter
                        -> Consumer.Type
                    """#
                )

                paragraph(
                    #"""
                    over embedding substantial consumer-specific state directly into the domain result.
                    """#
                )

                paragraph(
                    #"""
                    The adapter is where semantic translation between domains normally belongs.
                    """#
                )

                paragraph(
                    #"""
                    See BoundaryAdaptationGuideline for lightweight protocol-conformance exceptions.
                    """#
                )
            }

        case .composition_roots_coordinate:
            .init(
                title: "Composition roots may coordinate presentation and execution",
                summary: #"""
                Allow outer orchestration to join execution, events, and presentation
                while keeping the inner domain operation independent of the chosen
                presenter.
                """#
            ) {
                paragraph(
                    #"""
                    Separation does not require execution and presentation to exist in different processes, binaries, or even different orchestration functions.
                    """#
                )

                paragraph(
                    #"""
                    For example, a CLI command may legitimately do this:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    run domain operation
                        ↓
                    observe Event
                        ↓
                    update spinner
                        ↓
                    receive Result
                        ↓
                    render summary
                    """#
                )

                paragraph(
                    #"""
                    The important property is that the domain operation itself does not require that spinner or terminal renderer.
                    """#
                )

                paragraph(
                    #"""
                    The outer composition layer is allowed to bring independently defined concerns together.
                    """#
                )
            }

        case .presenters_consume_decisions:
            .init(
                title: "Presenters consume decisions; they do not make them",
                summary: #"""
                Let presenters choose what and how to show, but keep authoritative
                domain decisions inward of presentation.
                """#
            ) {
                paragraph(
                    #"""
                    A presenter may select what information to show and how to format it.
                    """#
                )

                paragraph(
                    #"""
                    It should not silently reinterpret which files should be changed, which target should be built, whether a domain operation succeeded, or what the authoritative result was.
                    """#
                )

                paragraph(
                    #"""
                    Those decisions belong inward of presentation.
                    """#
                )
            }
        }
    }
}
