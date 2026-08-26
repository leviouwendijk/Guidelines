public enum PresentationAndAdaptationGuideline: String, Sendable, Hashable, CaseIterable {
    case project_after_domain_meaning
    case delay_irreversible_projection
    case shared_projections
    case domain_representation_not_consumer_presentation
    case replaceable_presentation
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
                    Presentation and projection consume domain meaning that already exists. They may select, organize, format, or translate that meaning for an outward consumer without becoming the place where the underlying domain decision is made.
                    """#
                )

                example("Project semantic values outward") {
                    code(
                        language: "text",
                        content: #"""
                        Result + Events + maybe Plan / Preflight
                                         ↓
                                      Adapter
                                         ↓
                                     Presenter
                        """#
                    )

                    list(
                        style: .unordered,
                        items: [
                            "BuildResult → terminal summary",
                            "BuildEvent → progress line",
                            "BuildResult → JSON response",
                            "BuildResult → web response DTO",
                            "BuildResult → Agentic tool output",
                            "BuildResult → GUI view model",
                        ]
                    )
                }
            }

        case .delay_irreversible_projection:
            .init(
                title: "Delay irreversible projection",
                summary: #"""
                Preserve reusable structured information until a real consumer requires a
                narrower representation-specific projection.
                """#
            ) {
                paragraph(
                    #"""
                    Keep reusable structured information until an actual boundary requires a narrower representation. Do not make the first presenter convenient by irreversibly discarding meaning that several consumers could have shared.
                    """#
                )

                example("Preserve reusable structure before final lowering") {
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

                    code(
                        language: "text",
                        content: #"""
                        // Narrower too early when richer meaning is reusable.
                        Difference
                            ↓
                        terminal String
                        """#
                    )
                }

                paragraph(
                    #"""
                    The name of the intermediate representation is secondary. It may be a result, layout, projection, report, or model; what matters is whether it preserves or adds reusable meaning before the final representation-specific lowering step.
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
                    The domain result is not always the ideal direct input for every renderer. A shared projection can legitimately reorganize or enrich domain information for several real consumers.
                    """#
                )

                example("Share one enriched projection across real consumers") {
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
                }

                list(
                    style: .unordered,
                    items: [
                        "Introduce the projection when several consumers genuinely share its enriched structure.",
                        "Keep it when it materially improves readability or creates a useful stable boundary.",
                        "Do not add the layer only because hypothetical future consumers can be imagined.",
                        "Collapse it when it has one trivial consumer and no independent semantic value.",
                    ]
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
                    A domain type may expose stable representations that belong to the domain without thereby becoming coupled to a particular UI.
                    """#
                )

                example("Distinguish domain-owned representation from consumer policy") {
                    paragraph(
                        #"""
                        Domain-owned representation may include:
                        """#
                    )

                    list(
                        style: .unordered,
                        items: [
                            "relative path",
                            "display label",
                            "canonical description",
                            "structured summary",
                        ]
                    )

                    paragraph(
                        #"""
                        Consumer-specific presentation may include:
                        """#
                    )

                    list(
                        style: .unordered,
                        items: [
                            "ANSI color",
                            "terminal width",
                            "GUI row state",
                            "HTTP status formatting",
                            "localized interface prose",
                            "Agentic result envelopes",
                        ]
                    )
                }

                quote(
                    #"""
                    Ask whether the representation belongs to the domain or to the outward vehicle that happens to display it.
                    """#
                )
            }

        case .replaceable_presentation:
            .init(
                title: "Presentation is replaceable",
                summary: #"""
                A new CLI, GUI, web, Agentic, JSON, or TUI surface should usually require
                a new adapter or presenter rather than a new inner execution model.
                """#
            ) {
                paragraph(
                    #"""
                    A healthy domain operation can gain a new presentation surface without changing the operation's semantic execution model.
                    """#
                )

                example("Add consumers outward") {
                    code(
                        language: "text",
                        content: #"""
                        domain operation
                            ├── CLI
                            ├── GUI
                            ├── web API
                            ├── Agentic
                            ├── JSON
                            └── TUI
                        """#
                    )

                    paragraph(
                        #"""
                        Adding one of these surfaces should usually mean adding or adapting an outward projection, not teaching the inner operation about a new consumer.
                        """#
                    )
                }
            }

        case .presenters_consume_decisions:
            .init(
                title: "Presenters consume decisions; they do not make them",
                summary: #"""
                Let presenters choose what and how to show, but keep authoritative domain
                decisions inward of presentation.
                """#
            ) {
                paragraph(
                    #"""
                    A presenter may decide which available information to show and how to format it. It should not silently reinterpret authoritative domain decisions.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "which files should be changed",
                        "which target should be built",
                        "whether the domain operation fulfilled its contract",
                        "what the authoritative result was",
                        "which semantic outcome occurred",
                    ]
                )

                quote(
                    #"""
                    Presentation may choose a view of the decision; it should not become the authority that makes the decision.
                    """#
                )
            }
        }
    }
}
