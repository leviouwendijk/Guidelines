public enum BoundaryAdaptationGuideline: String, Sendable, Hashable, CaseIterable {
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
                    Adaptation belongs where one meaningful domain or representation meets another. Keep the semantic core expressed in its own vocabulary and project it outward when a particular consumer requires different representation or behavior.
                    """#
                )

                quote(
                    #"""
                    Do not drag substantial outer-domain behavior or representation inward merely because one current consumer requires it.
                    """#
                )

                example("Project consumer-specific forms outward") {
                    code(
                        language: "text",
                        content: #"""
                        // Avoid.
                        Concatenation.Result contains AgentToolResult

                        // Prefer.
                        Concatenation.Result
                            ↓
                        AgenticDomains adapter
                            ↓
                        AgentToolResult

                        // Avoid.
                        Executable.BuildResult contains ANSI strings

                        // Prefer.
                        BuildResult
                            ↓
                        Terminal presenter
                            ↓
                        ANSI output

                        // Avoid.
                        Accounting parser produces PDF DSL nodes

                        // Prefer.
                        Accounting.Report
                            ↓
                        Report/PDF adapter
                            ↓
                        PDF DSL
                        """#
                    )

                    paragraph(
                        #"""
                        In each preferred form, the inner value can exist independently of the current outer consumer. The adapter owns the translation between the two meanings.
                        """#
                    )
                }
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
                    Prefer dependency direction that lets the domain remain useful without substantial knowledge of its consumers. Apply that preference according to the actual coupling created rather than as a mechanical ban on every outward-facing protocol.
                    """#
                )

                example("Prefer outward adaptation for substantial dependencies") {
                    code(
                        language: "text",
                        content: #"""
                        domain
                            ← adapter depends on domain
                            ← interface depends on adapter/domain

                        rather than

                        domain depends heavily on interface
                        """#
                    )
                }

                list(
                    style: .unordered,
                    items: [
                        "Prefer outward adaptation when the consumer introduces substantial representation, runtime behavior, lifecycle, policy, or transitive dependency weight.",
                        "Allow direct conformance when the dependency is deliberately lightweight and the conformance faithfully exposes meaning the domain already has.",
                        "Do not manufacture a mirror type merely to make the dependency graph look theoretically pure.",
                        "Judge the boundary by the isolation it actually creates, not by the number of adapter types present.",
                    ]
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
                    A direct conformance can be the more cohesive design when the protocol expresses an interface the domain value already satisfies and adding an adapter would merely duplicate the same representation.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "The dependency is intentionally lightweight.",
                        "The dependency is stable and controlled.",
                        "The conformance faithfully exposes the existing domain value.",
                        "The conformance does not add substantial consumer-specific state or behavior.",
                        "The conformance does not distort the domain model.",
                        "An adapter would mostly mirror the same type or mapping.",
                        "Direct conformance avoids repeated boilerplate or undesirable retroactive conformances.",
                    ]
                )

                example("Do not manufacture a mirror value for a faithful lightweight conformance") {
                    code(
                        language: "swift",
                        content: #"""
                        public enum BusinessEntity: String, Sendable, Codable {
                            case vof
                        }

                        // Reasonable when ArgumentValue is deliberately lightweight
                        // and represents exactly the same accepted values.
                        public enum BusinessEntity: String, Sendable, Codable, ArgumentValue {
                            case vof
                        }

                        // Avoid manufacturing another representation only
                        // to preserve theoretical boundary purity.
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
                        The mirror type adds another representation without adding another meaning. That is different from an adapter that genuinely isolates a substantial consumer domain.
                        """#
                    )
                }
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
                    The architectural cost of direct integration depends on what the dependency actually brings inward. A microscopic protocol-only library is materially different from a framework carrying runtime behavior, policy, lifecycle, or a large transitive graph.
                    """#
                )

                example("Evaluate coupling, not merely import direction") {
                    quote(
                        #"""
                        Does the domain import something outward-facing?
                        """#
                    )

                    paragraph(
                        #"""
                        That question is too weak on its own. Ask instead:
                        """#
                    )

                    list(
                        style: .unordered,
                        items: [
                            "What semantic coupling does this introduce?",
                            "What runtime or transitive dependency weight does it introduce?",
                            "Does the conformance distort the domain?",
                            "Does an adapter actually provide meaningful isolation?",
                            "Would the adapter merely duplicate the same value?",
                        ]
                    )
                }
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
                    Pushing every integration conformance outward can make the system less cohesive even while making the dependency graph appear purer.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "repeated retroactive conformances",
                        "compiler warnings or ownership ambiguity around those conformances",
                        "duplicated mappings",
                        "mirror enums and wrapper values",
                        "boilerplate adapters",
                        "fragmented knowledge about one canonical value",
                    ]
                )

                paragraph(
                    #"""
                    Those are real architectural costs. Boundary purity should not be pursued mechanically when it adds duplication without creating meaningful isolation.
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
                    The lightweight-conformance exception has a clear limit. If adopting the consumer interface changes what the domain type must represent or how the domain must behave, the adaptation is no longer lightweight.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "terminal rendering and ANSI presentation",
                        "HTTP response construction and transport concerns",
                        "Agentic result envelopes",
                        "database transport models",
                        "GUI state",
                        "framework lifecycle and runtime behavior",
                    ]
                )

                paragraph(
                    #"""
                    Keep those concerns outside core domain types even when a protocol could technically be made to expose them. Prefer an adapter when the integration introduces substantial new representation, behavior, ownership, or dependency weight.
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
                    An adapter only needs to solve the boundary that actually exists. A small explicit translation between two real domains is often clearer than a universal framework designed around hypothetical future consumers.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "Name the domains being connected clearly.",
                        "Keep translation logic near the boundary whose semantics it understands.",
                        "Generalize only after several real adapters demonstrate reusable common structure.",
                        "Do not introduce a universal adaptation protocol merely because multiple adapters can be imagined.",
                    ]
                )
            }
        }
    }
}
