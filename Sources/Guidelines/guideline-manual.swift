public enum GuidelineManual {
    public static var chapters: [GuidelineChapter] {
        [
            .init(
                area: .design,
                key: "source_conventions",
                title: "Source Conventions",
                guidelines: SourceConventionGuideline.allCases.map {
                    .source_conventions($0)
                }
            ),

            .init(
                area: .design,
                key: "symbol_design",
                title: "Symbol Design",
                guidelines: SymbolDesignGuideline.allCases.map {
                    .symbol_design($0)
                }
            ),

            .init(
                area: .design,
                key: "casing_conventions",
                title: "Casing Conventions",
                guidelines: CasingConventionGuideline.allCases.map {
                    .casing_conventions($0)
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
                key: "nested_apis",
                title: "Nested APIs",
                guidelines: NestedAPIGuideline.allCases.map {
                    .nested_apis($0)
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
                area: .ai,
                key: "web_interface_interactions",
                title: "Web-based Interface Interactions",
                guidelines: WebInterfaceInteractionGuideline.allCases.map {
                    .web_interface_interactions($0)
                }
            ) {
                paragraph(
                    #"""
                    Instructions for AI-assisted coding work performed through a web or chat interface, where source context and terminal state are supplied to the assistant and changes are returned for local application.
                    """#
                )

                paragraph(
                    #"""
                    The objective is accurate, auditable handoff: use supplied state, address edits precisely, preserve the user's local session, and prove changes through the repository's real execution path.
                    """#
                )
            },

            .init(
                area: .ai,
                key: "mutation_execution_workflows",
                title: "Mutation Execution Workflows",
                guidelines: MutationExecutionWorkflowGuideline.allCases.map {
                    .mutation_execution_workflows($0)
                }
            ) {
                paragraph(
                    #"""
                    Instructions for safely applying larger AI-assisted mutations, gating dependent stages, surfacing failures at useful boundaries, presenting workflow state without coupling it to execution semantics, and avoiding transport-related ambiguity.
                    """#
                )

                paragraph(
                    #"""
                    Recurring workflows use stable shorthand: LRP for line-ranged manual patches, ZMP for pasteable zsh mutation passes, BMP for the equivalent bash mutation passes, SDP for staged dependency-aware operations, ATP for manifest-grounded governed Agentic tool execution, GPR for the Guidelines publish-refresh sequence, and CR for final-state Concatenation context refresh. ZMP and BMP passes use an outer subshell as their default interactive execution boundary. Optional workflow_section, workflow_step, and workflow_diag hooks provide structured terminal presentation when available, with compact plain-text fallbacks otherwise.
                    """#
                )
            },

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
                        "Do not manufacture representation merely because an architectural role can be named.",
                        "Keep domain operations usable independently of particular outer interfaces unless a deliberate lightweight conformance creates more cohesion than isolation.",
                        "Interpret loose intent into domain meaning before carrying it deeply into execution.",
                        "Separate preparation, effects, observation, outcome, and presentation where doing so increases determinism, inspectability, reuse, readability, or adaptability.",
                        "When work is inspected before execution, preserve the relationship between what was inspected and what executes, and detect material state drift explicitly.",
                        "Return authoritative semantic outcomes; expose temporal progress separately; do not make ambient presentation output the semantic API.",
                        "Project and adapt at boundaries rather than pulling consumer-specific representation and lifecycle into the semantic core.",
                        "Let abstractions follow repeated real meaning rather than forcing domains into speculative generics or mandatory layers.",
                        "Once implementation stabilizes, compact scaffolding that has no durable domain, reuse, compatibility, readability, or boundary value.",
                    ]
                )

                paragraph(
                    #"""
                    The aim is not maximal layering.
                    """#
                )

                paragraph(
                    #"""
                    The detailed chapters are authoritative for how these principles apply to input, parsing, resolution, planning, preflight, execution, events, results, artifacts, projection, adaptation, caching, recursive composition, abstraction, and compaction.
                    """#
                )
            },

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
                key: "input",
                title: "Input",
                guidelines: InputGuideline.allCases.map {
                    .input($0)
                }
            ),

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
                key: "resolution",
                title: "Resolution",
                guidelines: ResolutionGuideline.allCases.map {
                    .resolution($0)
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
                key: "execution",
                title: "Execution",
                guidelines: ExecutionGuideline.allCases.map {
                    .execution($0)
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
                key: "results",
                title: "Results",
                guidelines: ResultGuideline.allCases.map {
                    .results($0)
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
                key: "failures_and_outcomes",
                title: "Domain Outcomes and Execution Errors",
                guidelines: FailureAndOutcomeGuideline.allCases.map {
                    .failures_and_outcomes($0)
                }
            ),

            .init(
                area: .structure,
                key: "presentation_and_adaptation",
                title: "Presentation and Projection",
                guidelines: PresentationAndAdaptationGuideline.allCases.map {
                    .presentation_and_adaptation($0)
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
                key: "recursive_composition",
                title: "Recursive Composition",
                guidelines: RecursiveCompositionGuideline.allCases.map {
                    .recursive_composition($0)
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
                key: "operation_abstractions",
                title: "Operation Abstractions",
                guidelines: OperationAbstractionGuideline.allCases.map {
                    .operation_abstractions($0)
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

        ]
    }
}
