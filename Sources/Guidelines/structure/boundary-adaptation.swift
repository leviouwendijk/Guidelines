public enum BoundaryAdaptationGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
    case adapt_at_boundaries
    case dependency_direction_default
    case lightweight_native_conformance
    case dependency_cost
    case retroactive_conformance_cost
    case substantial_adaptation_outward
    case domain_specific_adapters

    public var content: GuidelineContent {
        switch self {
        case .adapt_at_boundaries:
            .init(
                title: "Adapt substantial outer-domain concerns at meaningful boundaries",
                summary: #"""
                Keep substantial consumer-specific behavior and representation outside
                the semantic core, adapting domain results outward at meaningful
                boundaries.
                """#
            ) {
                paragraph(
                    #"""
                    Adaptation should generally happen at meaningful boundaries.
                    """#
                )

                paragraph(
                    #"""
                    A strong default is:
                    """#
                )

                quote(
                    #"""
                    Do not drag substantial outer-domain behavior or representation inward merely because one current consumer requires it.
                    """#
                )

                paragraph(
                    #"""
                    Avoid:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    Concatenation.Result contains AgentToolResult
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
                    Concatenation.Result
                        -> AgenticDomains adapter
                        -> AgentToolResult
                    """#
                )

                paragraph(
                    #"""
                    Avoid:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    Executable.BuildResult contains ANSI strings
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
                    BuildResult
                        -> Terminal presenter
                        -> ANSI output
                    """#
                )

                paragraph(
                    #"""
                    Avoid:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    Accounting parser produces PDF DSL nodes
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
                    Accounting.Report
                        -> Report/PDF adapter
                        -> PDF DSL
                    """#
                )

                paragraph(
                    #"""
                    This preserves composition because the inner domain can exist without substantial knowledge of the outer consumer.
                    """#
                )
            }

        case .dependency_direction_default:
            .init(
                title: "Dependency direction is a default, not an absolute ban",
                summary: #"""
                Prefer outward dependency direction, but do not manufacture adapters
                when a lightweight direct conformance creates more cohesion than
                isolation.
                """#
            ) {
                paragraph(
                    #"""
                    Where practical:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    domain
                        <- adapter depends on domain
                        <- interface depends on adapter/domain
                    """#
                )

                paragraph(
                    #"""
                    is preferable to:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    domain depends heavily on interface
                    """#
                )

                paragraph(
                    #"""
                    But not every outward-facing protocol conformance requires a mirror type or adapter.
                    """#
                )

                paragraph(
                    #"""
                    The architecture should avoid boilerplate as well as coupling.
                    """#
                )
            }

        case .lightweight_native_conformance:
            .init(
                title: "Lightweight integration conformances may remain native",
                summary: #"""
                Allow a domain type to adopt a lightweight integration protocol when the
                dependency is controlled, faithful, low-cost, and does not distort the
                domain.
                """#
            ) {
                paragraph(
                    #"""
                    A domain type may reasonably conform directly to a lightweight integration protocol when all of the following are substantially true:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    the dependency is intentionally lightweight
                    the dependency is stable and controlled
                    the conformance faithfully exposes the existing domain value
                    the conformance does not add substantial consumer-specific state
                    the conformance does not distort the domain model
                    an adapter would mostly mirror the same type
                    the direct conformance avoids repeated boilerplate or undesirable retroactive conformances
                    """#
                )

                paragraph(
                    #"""
                    A command-line argument protocol is a good example of a possible exception.
                    """#
                )

                paragraph(
                    #"""
                    Suppose:
                    """#
                )

                code(
                    language: "swift",
                    content: #"""
                    public enum BusinessEntity: String, Sendable, Codable {
                        case vof
                    }
                    """#
                )

                paragraph(
                    #"""
                    already represents the exact values the CLI should accept.
                    """#
                )

                paragraph(
                    #"""
                    If a lightweight Arguments protocol can express that directly, this may be preferable:
                    """#
                )

                code(
                    language: "swift",
                    content: #"""
                    public enum BusinessEntity:
                        String,
                        Sendable,
                        Codable,
                        ArgumentValue
                    {
                        case vof
                    }
                    """#
                )

                paragraph(
                    #"""
                    to manufacturing:
                    """#
                )

                code(
                    language: "swift",
                    content: #"""
                    enum BusinessEntityArgument {
                        case vof
                    
                        var businessEntity: BusinessEntity {
                            .vof
                        }
                    }
                    """#
                )

                paragraph(
                    #"""
                    purely to keep the domain target theoretically free from all interface protocol conformances.
                    """#
                )

                paragraph(
                    #"""
                    The adapter would add another representation without adding another meaning.
                    """#
                )
            }

        case .dependency_cost:
            .init(
                title: "Evaluate the cost of the dependency itself",
                summary: #"""
                Judge direct integration partly by semantic and transitive dependency
                cost rather than by the mere fact that an outward-facing protocol is
                imported.
                """#
            ) {
                paragraph(
                    #"""
                    The acceptability of direct conformance depends partly on what is imported.
                    """#
                )

                paragraph(
                    #"""
                    A heavy interface framework that brings substantial runtime behavior, policy, or transitive dependencies inward is materially different from a microscopic protocol-only library intended to support such conformances.
                    """#
                )

                paragraph(
                    #"""
                    The question is not merely:
                    """#
                )

                quote(
                    #"""
                    Does the domain import something outward-facing?
                    """#
                )

                paragraph(
                    #"""
                    The better questions are:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    What semantic coupling does this introduce?
                    What dependency weight does it introduce?
                    Does the conformance distort the domain?
                    Does an adapter actually provide isolation?
                    Would the adapter merely duplicate the same value?
                    """#
                )
            }

        case .retroactive_conformance_cost:
            .init(
                title: "Retroactive conformance can itself be a cost",
                summary: #"""
                Treat duplicate mappings, retroactive conformances, mirror types, and
                fragmented canonical knowledge as real costs of excessive boundary
                purity.
                """#
            ) {
                paragraph(
                    #"""
                    Moving every conformance outward can produce:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    repeated retroactive conformances
                    warnings
                    duplicated mappings
                    mirror enums
                    boilerplate adapters
                    fragmented knowledge about the same canonical value
                    """#
                )

                paragraph(
                    #"""
                    Those costs are real.
                    """#
                )

                paragraph(
                    #"""
                    Boundary purity should not be pursued mechanically when it makes the system less cohesive without creating meaningful isolation.
                    """#
                )
            }

        case .substantial_adaptation_outward:
            .init(
                title: "Substantial adaptation still belongs outward",
                summary: #"""
                Keep rendering, transport models, interface lifecycle, and other
                substantial consumer behavior outside core domain types.
                """#
            ) {
                paragraph(
                    #"""
                    The lightweight-conformance exception does not justify embedding:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    terminal rendering
                    HTTP response construction
                    Agentic result envelopes
                    database transport models
                    GUI state
                    framework lifecycle
                    """#
                )

                paragraph(
                    #"""
                    into core domain types merely because a protocol could technically expose them.
                    """#
                )

                paragraph(
                    #"""
                    When adopting the protocol meaningfully changes what the type represents or how the domain must behave, prefer an adapter.
                    """#
                )
            }

        case .domain_specific_adapters:
            .init(
                title: "Adapters may be domain-specific",
                summary: #"""
                Prefer small explicit adapters between real domains over universal
                translation frameworks that anticipate hypothetical consumers.
                """#
            ) {
                paragraph(
                    #"""
                    Do not force all adaptation into one generic translation framework.
                    """#
                )

                paragraph(
                    #"""
                    A small explicit adapter between two real domains is often clearer than a universal abstraction intended to anticipate every future consumer.
                    """#
                )
            }
        }
    }
}
