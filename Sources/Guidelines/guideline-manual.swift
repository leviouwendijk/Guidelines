public enum GuidelineManual {
    public static var chapters: [GuidelineChapter] {
        [
            .init(
                area: .design,
                key: "casing",
                title: "Casing",
                guidelines: CasingGuideline.allCases.map {
                    .casing($0)
                }
            ),

            .init(
                area: .design,
                key: "identifiers",
                title: "Identifiers",
                guidelines: IdentifierGuideline.allCases.map {
                    .identifiers($0)
                }
            ),

            .init(
                area: .design,
                key: "snake_or_camel",
                title: "On snake or camel",
                guidelines: SnakeOrCamelGuideline.allCases.map {
                    .snake_or_camel($0)
                }
            ),

            .init(
                area: .ergonomics,
                key: "dsl_design",
                title: "DSL Design",
                guidelines: DSLDesignGuideline.allCases.map {
                    .dsl_design($0)
                }
            ),

            .init(
                area: .ergonomics,
                key: "nested_api_designs",
                title: "Nested API Designs",
                guidelines: NestedAPIDesignGuideline.allCases.map {
                    .nested_api_designs($0)
                }
            ),

            .init(
                area: .ergonomics,
                key: "option_clustering",
                title: "Option Clustering",
                guidelines: OptionClusteringGuideline.allCases.map {
                    .option_clustering($0)
                }
            ),

            .init(
                area: .ergonomics,
                key: "source_organization",
                title: "Source Organization",
                guidelines: SourceOrganizationGuideline.allCases.map {
                    .source_organization($0)
                }
            ),

            .init(
                area: .structure,
                key: "artifacts",
                title: "Artifacts",
                guidelines: ArtifactGuideline.allCases.map {
                    .artifacts($0)
                }
            ),

            .init(
                area: .structure,
                key: "boundary_adaptation",
                title: "Boundary Adaptation",
                guidelines: BoundaryAdaptationGuideline.allCases.map {
                    .boundary_adaptation($0)
                }
            ),

            .init(
                area: .structure,
                key: "caching",
                title: "Caching",
                guidelines: CachingGuideline.allCases.map {
                    .caching($0)
                }
            ),

            .init(
                area: .structure,
                key: "compaction_passes",
                title: "Compaction Passes",
                guidelines: CompactionPassGuideline.allCases.map {
                    .compaction_passes($0)
                }
            ),

            .init(
                area: .structure,
                key: "events",
                title: "Events",
                guidelines: EventGuideline.allCases.map {
                    .events($0)
                }
            ),

            .init(
                area: .structure,
                key: "execution",
                title: "Execution",
                guidelines: ExecutionGuideline.allCases.map {
                    .execution($0)
                }
            ),

            .init(
                area: .structure,
                key: "failures_and_outcomes",
                title: "Domain Outcomes and Execution Errors",
                guidelines: FailureAndOutcomeGuideline.allCases.map {
                    .failures_and_outcomes($0)
                }
            ),

            .init(
                area: .structure,
                key: "input",
                title: "Input",
                guidelines: InputGuideline.allCases.map {
                    .input($0)
                }
            ),

            .init(
                area: .structure,
                key: "operation_abstractions",
                title: "Operation Abstractions",
                guidelines: OperationAbstractionGuideline.allCases.map {
                    .operation_abstractions($0)
                }
            ),

            .init(
                area: .structure,
                key: "operational_architecture",
                title: "Operational Architecture",
                guidelines: OperationalArchitectureGuideline.allCases.map {
                    .operational_architecture($0)
                }
            ),

            .init(
                area: .structure,
                key: "operational_model",
                title: "Operational Model",
                guidelines: OperationalModelGuideline.allCases.map {
                    .operational_model($0)
                }
            ) {
                paragraph(
                    #"""
                    The richest operational shape is:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                              ┌──────────────┐
                              │    Input     │
                              └──────┬───────┘
                                     │
                                     ▼
                              ┌──────────────┐
                              │  Resolution  │
                              └──────┬───────┘
                                     │
                                     ▼
                         ┌───────────────────────┐
                         │ Plan? / Preparation?  │
                         └───────────┬───────────┘
                                     │
                               ┌─────▼─────┐
                               │ Preflight?│
                               └─────┬─────┘
                                     │
                                     ▼
                              ┌──────────────┐
                              │  Execution   │──────► Event*
                              └──────┬───────┘
                                     │
                                     ▼
                              ┌──────────────┐
                              │    Result    │──────► Artifact*
                              └──────┬───────┘
                                     │
                                     ▼
                          ┌────────────────────┐
                          │ Projection/Adapter │
                          └─────────┬──────────┘
                                    │
                     ┌──────────────┼───────────────┐
                     ▼              ▼               ▼
                    CLI          Agentic           GUI/API
                    """#
                )

                paragraph(
                    #"""
                    No operation has to instantiate every box.
                    """#
                )

                paragraph(
                    #"""
                    The boxes describe possible semantic roles, not required concrete types.
                    """#
                )
            },

            .init(
                area: .structure,
                key: "parse_dont_validate",
                title: "Parse, don't validate",
                guidelines: ParseDontValidateGuideline.allCases.map {
                    .parse_dont_validate($0)
                }
            ),

            .init(
                area: .structure,
                key: "planning",
                title: "Planning",
                guidelines: PlanningGuideline.allCases.map {
                    .planning($0)
                }
            ),

            .init(
                area: .structure,
                key: "preflight",
                title: "Preflight",
                guidelines: PreflightGuideline.allCases.map {
                    .preflight($0)
                }
            ),

            .init(
                area: .structure,
                key: "presentation_and_adaptation",
                title: "Presentation and Adaptation",
                guidelines: PresentationAndAdaptationGuideline.allCases.map {
                    .presentation_and_adaptation($0)
                }
            ),

            .init(
                area: .structure,
                key: "principles",
                title: "Structural Principles",
                guidelines: []
            ) {
                list(
                    style: .ordered,
                    items: [
                        "Preserve meaningful information and meaningful boundaries; avoid representations that add no independent meaning.",
                        "Domain operations should not require a particular outer interface to exist unless a deliberate lightweight integration conformance provides more cohesion than isolation.",
                        "Inputs describe requested domain intent rather than interface syntax.",
                        "Do not manufacture input, result, operation, plan, or other carrier types merely because the architectural role can be named.",
                        "A representation earns a type when it gains useful identity, invariants, reuse, transportability, inspectability, lifecycle, readability, or cohesion.",
                        "Abstraction and layering are separate decisions.",
                        "Centralize repeated meaning without automatically adding representational ceremony.",
                        "External or loose values should be parsed into stronger types when successful interpretation establishes meaningful invariants.",
                        "Prefer a throwing initializer or equivalent strong construction boundary when successful parsing should guarantee the resulting type is valid.",
                        "A loose parsing helper may exist as implementation machinery, but should not normally replace the stronger public semantic boundary when one is available.",
                        "Validation remains legitimate when inspection itself is the requested operation.",
                        "Normalization is domain-relative. Silently discard information only when the discarded information is not meaningfully needed by the intended system.",
                        "Preserve raw input, reject it, or normalize it according to correctness, diagnostics, auditability, recovery, and domain needs rather than one global normalization rule.",
                        "Resolution interprets environment-dependent intent once where practical.",
                        "Resolution does not automatically require a named Resolved type; create one when the resolved value becomes significant, reusable, readable, cohesive, or independently meaningful.",
                        "Small local tuples and primitive results are acceptable when introducing a carrier type would add little meaning.",
                        "Plans describe concrete intended work when planning adds determinism, inspectability, reviewability, reuse, approval, or reproducibility.",
                        "The thing inspected should, wherever reasonable, be the thing executed.",
                        "Preflight inspects work; it does not become presentation itself.",
                        "Execution owns domain effects, not UI policy.",
                        "Events describe temporal progress and are optional to consume.",
                        "Events are not authoritative final state.",
                        "Results describe authoritative semantic outcomes.",
                        "A result does not need a dedicated result struct when a primitive or existing type already expresses the complete outcome cleanly.",
                        "Preserve the richest reasonably reusable semantic result until a consumer actually requires a narrower representation.",
                        "Intermediate projections earn their existence through shared enrichment, reuse, readability, or boundary value rather than hypothetical future consumers.",
                        "Artifacts are produced material and need not be embedded directly into results.",
                        "Presenters and adapters project domain information outward.",
                        "Domain-owned stable representations are different from consumer-specific formatting and interface state.",
                        "Lightweight protocol conformances may live directly on domain types when they faithfully expose the same value, introduce little dependency weight, avoid redundant mirror types, and do not distort the domain.",
                        "Substantial outer-domain behavior, representation, and lifecycle should remain outside the semantic core.",
                        "Composition roots may intentionally coordinate domain execution, events, logging, presentation, and process lifecycle; separation means those concerns remain independently defined, not that they can never meet.",
                        "Domain outcomes and execution failures should remain distinct concepts.",
                        "Caching belongs beneath execution/resolution rather than presentation.",
                        "The operational pattern is recursive: adapters and DSLs may themselves contain operations that follow the same discipline.",
                        "Generic operation protocols are optional abstractions, not the source of the architecture.",
                        "Once implementation has stabilized, perform a compaction pass and remove scaffolding that has no durable domain, reuse, compatibility, readability, or boundary value.",
                    ]
                )

                paragraph(
                    #"""
                    The aim is not maximal layering.
                    """#
                )

                paragraph(
                    #"""
                    The aim is code whose domain meaning remains clear, whose representation is proportional to that meaning, and whose operations can be reused, inspected, observed, adapted, and presented from different contexts without unnecessary coupling or unnecessary ceremony.
                    """#
                )
            },

            .init(
                area: .structure,
                key: "recursive_composition",
                title: "Recursive Composition",
                guidelines: RecursiveCompositionGuideline.allCases.map {
                    .recursive_composition($0)
                }
            ),

            .init(
                area: .structure,
                key: "resolution",
                title: "Resolution",
                guidelines: ResolutionGuideline.allCases.map {
                    .resolution($0)
                }
            ),

            .init(
                area: .structure,
                key: "results",
                title: "Results",
                guidelines: ResultGuideline.allCases.map {
                    .results($0)
                }
            ),
        ]
    }
}
