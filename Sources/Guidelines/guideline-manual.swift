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
            ) {
                paragraph(
                    #"""
                    Source conventions govern the visible shape of code: indentation, vertical layout, call and initializer formatting, and other low-level presentation choices. Use them to make source structure legible without turning formatting into ceremony.
                    """#
                )
            },

            .init(
                area: .design,
                key: "symbol_design",
                title: "Symbol Design",
                guidelines: SymbolDesignGuideline.allCases.map {
                    .symbol_design($0)
                }
            ) {
                paragraph(
                    #"""
                    Symbol design governs the vocabulary carried by identifiers themselves. Prefer names that preserve the domain term, remove context already supplied elsewhere, and remain concise without becoming cryptic.
                    """#
                )
            },

            .init(
                area: .design,
                key: "casing_conventions",
                title: "Casing Conventions",
                guidelines: CasingConventionGuideline.allCases.map {
                    .casing_conventions($0)
                }
            ) {
                paragraph(
                    #"""
                    Casing conventions decide how visible word boundaries are represented once the vocabulary itself is settled. Prefer ordinary Swift casing by default, but let local readability and real external interfaces justify deliberate exceptions.
                    """#
                )
            },

            .init(
                area: .web_design,
                key: "interface_design",
                title: "Web Interface Design",
                guidelines: WebDesignGuideline.allCases.map {
                    .web_interface_design($0)
                }
            ) {
                paragraph(
                    #"""
                    Web interface design governs the rendered browser contract rather than a particular framework, language, or utility-class vocabulary. Prefer durable platform semantics: accessible structure, keyboard and touch operability, resilient content, addressable navigation state, stable media and layout, locale-aware presentation, and measured performance.
                    """#
                )

                paragraph(
                    #"""
                    Apply these principles to the behavior ultimately emitted by HTML, CSS, JavaScript, generated components, or higher-level DSLs. Where an abstraction already knows the semantic role of a component, encode the invariant in that abstraction instead of requiring every call site to reconstruct low-level browser details.
                    """#
                )
            },

            .init(
                area: .ergonomics,
                key: "dsl_design",
                title: "DSL Design",
                guidelines: DSLDesignGuideline.allCases.map {
                    .dsl_design($0)
                }
            ) {
                paragraph(
                    #"""
                    DSL design governs the grammar of domain-facing call sites. Start from the sentence users should write most often, let defaults and overloads remove structural ceremony, and keep the resulting vocabulary small, regular, composable, and progressively discoverable.
                    """#
                )
            },

            .init(
                area: .ergonomics,
                key: "nested_apis",
                title: "Nested APIs",
                guidelines: NestedAPIGuideline.allCases.map {
                    .nested_apis($0)
                }
            ) {
                paragraph(
                    #"""
                    Nested APIs decide how meaning is distributed across an access path. Give each level real semantic work: move shared context left into wrappers or accessors when that makes children smaller and clearer, but do not manufacture hierarchy merely to shorten a symbol or add another dot.
                    """#
                )
            },

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
                        "Prefer dependencies we own and can keep purpose-fit; accept external dependencies only from explicitly trusted sources when owning the capability would be materially harder or more costly than carrying the dependency.",
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
                    The detailed chapters are authoritative for how these principles apply to dependency ownership, command-line architecture, input, parsing, resolution, planning, preflight, execution, events, results, artifacts, projection, adaptation, caching, recursive composition, abstraction, and compaction.
                    """#
                )
            },

            .init(
                area: .structure,
                key: "dependency_architecture",
                title: "Dependency Architecture",
                guidelines: DependencyArchitectureGuideline.allCases.map {
                    .dependency_architecture($0)
                }
            ) {
                paragraph(
                    #"""
                    Dependency architecture governs which capabilities we own, when external code is admitted, and how dependency weight affects package boundaries. Prefer purpose-fit first-party libraries; make external dependencies a deliberate exception based on explicit trust and disproportionate replacement cost.
                    """#
                )
            },

            .init(
                area: .structure,
                key: "command_line_architecture",
                title: "Command-Line Architecture",
                guidelines: CommandLineArchitectureGuideline.allCases.map {
                    .command_line_architecture($0)
                }
            ) {
                paragraph(
                    #"""
                    Command-line architecture applies dependency and boundary rules to Swift executables. Use the first-party Arguments library as the default parser, allow faithful lightweight argument conformances on native values, and structure non-trivial CLIs around typed root commands, semantic options, thin command routers, and explicit runners while retaining the DSL as a valid alternate style.
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
            ) {
                paragraph(
                    #"""
                    Operational architecture governs where independently meaningful boundaries belong across intent, preparation, execution, observation, outcome, and presentation. Preserve those distinctions when they improve the system, collapse them when they do not, and keep dependency direction oriented around reusable domain meaning rather than mandatory layers.
                    """#
                )
            },

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
                    No operation has to instantiate every box. The diagram describes possible semantic roles, not required concrete types; collapse or expand the shape according to the meaningful distinctions the operation actually needs.
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
            ) {
                paragraph(
                    #"""
                    Input governs how caller intent enters a domain operation. Adapt external interface syntax into domain meaning, keep small operations direct when arguments already express the request clearly, introduce dedicated input carriers only when the request becomes a cohesive value of its own, and parse loose external representations before carrying them deeper into the semantic core.
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
            ) {
                paragraph(
                    #"""
                    Parsing governs how loose or externally supplied representations become stronger domain values. Prefer successful interpretation that becomes structural, keep loose parsing helpers subordinate to strong public boundaries, use validation when inspection is itself the operation, and treat normalization or raw-input retention as explicit information decisions.
                    """#
                )
            },

            .init(
                area: .structure,
                key: "resolution",
                title: "Resolution",
                guidelines: ResolutionGuideline.allCases.map {
                    .resolution($0)
                }
            ) {
                paragraph(
                    #"""
                    Resolution governs the boundary where meaningful but environment-dependent intent becomes concrete meaning. Resolve interpretation once where practical, preserve the distinction from parsing, and introduce dedicated resolved representations only when the resulting value is significant enough to earn them.
                    """#
                )
            },

            .init(
                area: .structure,
                key: "planning",
                title: "Planning",
                guidelines: PlanningGuideline.allCases.map {
                    .planning($0)
                }
            ) {
                paragraph(
                    #"""
                    Planning governs when intended work deserves a concrete representation before execution. Introduce plans when inspection, approval, testing, resumability, previewability, or deterministic execution benefits from them; preserve the relationship between the work that was inspected and the work that executes; and keep plans expressed in domain-native meaning rather than consumer presentation.
                    """#
                )
            },

            .init(
                area: .structure,
                key: "preflight",
                title: "Preflight",
                guidelines: PreflightGuideline.allCases.map {
                    .preflight($0)
                }
            ) {
                paragraph(
                    #"""
                    Preflight governs analysis of whether and how intended work may proceed under current conditions. Keep that analysis distinct from the plan when the distinction is meaningful, preserve useful findings as domain information rather than reducing them prematurely to presentation or a boolean gate, and do not let preflight secretly perform the effects it claims only to analyze.
                    """#
                )
            },

            .init(
                area: .structure,
                key: "execution",
                title: "Execution",
                guidelines: ExecutionGuideline.allCases.map {
                    .execution($0)
                }
            ) {
                paragraph(
                    #"""
                    Execution governs the boundary where already meaningful work actually performs its domain effects. Remove avoidable ambiguity before that boundary, preserve the identity of inspected or approved work when plans are involved, expose semantic results and structured observation instead of ambient presentation, and keep cancellation and failure independent of consumer-specific rendering.
                    """#
                )
            },

            .init(
                area: .structure,
                key: "events",
                title: "Events",
                guidelines: EventGuideline.allCases.map {
                    .events($0)
                }
            ) {
                paragraph(
                    #"""
                    Events carry temporal observations about execution without becoming presentation or authoritative final state. Keep them structured and domain-native so different consumers may render, record, or ignore the same observations, and ensure callers can still obtain the complete semantic result without reconstructing it from the event stream.
                    """#
                )
            },

            .init(
                area: .structure,
                key: "results",
                title: "Results",
                guidelines: ResultGuideline.allCases.map {
                    .results($0)
                }
            ) {
                paragraph(
                    #"""
                    Results carry the authoritative semantic outcome of an operation. Preserve final meaning independently of logs, events, and presentation; delay irreversible lowering while richer information remains reusable; and introduce result or intermediate types only when their structure contributes real semantic value.
                    """#
                )
            },

            .init(
                area: .structure,
                key: "artifacts",
                title: "Artifacts",
                guidelines: ArtifactGuideline.allCases.map {
                    .artifacts($0)
                }
            ) {
                paragraph(
                    #"""
                    Artifacts are produced material associated with an operation but distinct from its semantic result. Keep artifacts domain-addressable, let results reference them without embedding unnecessary material, and distinguish artifact production from the presentation surfaces that later expose or describe those artifacts.
                    """#
                )
            },

            .init(
                area: .structure,
                key: "failures_and_outcomes",
                title: "Domain Outcomes and Execution Errors",
                guidelines: FailureAndOutcomeGuideline.allCases.map {
                    .failures_and_outcomes($0)
                }
            ) {
                paragraph(
                    #"""
                    Domain outcomes and execution errors distinguish meaningful states produced by successfully executed logic from failures that prevent an operation from fulfilling its contract. Model legitimate non-happy-path states as typed outcomes, avoid redundant success wrappers, and preserve enough typed failure meaning for outer interfaces to recover or present errors without parsing strings.
                    """#
                )
            },

            .init(
                area: .structure,
                key: "presentation_and_adaptation",
                title: "Presentation and Projection",
                guidelines: PresentationAndAdaptationGuideline.allCases.map {
                    .presentation_and_adaptation($0)
                }
            ) {
                paragraph(
                    #"""
                    Presentation and projection govern how already meaningful domain information is adapted outward. Delay irreversible lowering while richer structure remains reusable, introduce shared projections only when real consumers benefit from them, keep consumer-specific policy outside the domain, and let presenters display decisions rather than become the authority that makes them.
                    """#
                )
            },

            .init(
                area: .structure,
                key: "boundary_adaptation",
                title: "Boundary Adaptation",
                guidelines: BoundaryAdaptationGuideline.allCases.map {
                    .boundary_adaptation($0)
                }
            ) {
                paragraph(
                    #"""
                    Boundary adaptation governs how semantic values cross into interface, transport, presentation, and other consumer domains. Prefer outward adaptation for substantial concerns, while judging lightweight direct conformances by the real coupling, dependency cost, duplication, and isolation they create rather than by boundary purity alone.
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
            ) {
                paragraph(
                    #"""
                    Recursive composition applies the operational discipline relative to each meaningful operation. A library that serves as an adapter or presentation dependency at one level may itself contain input, resolution, planning, execution, observation, result, and adaptation roles internally without creating conceptual circularity.
                    """#
                )
            },

            .init(
                area: .structure,
                key: "caching",
                title: "Caching",
                guidelines: CachingGuideline.allCases.map {
                    .caching($0)
                }
            ) {
                paragraph(
                    #"""
                    Caching governs how reusable work is avoided without changing the meaning of the operation. Keep cache mechanics beneath domain execution or resolution, expose useful activity through semantic observations when warranted, preserve warm/cold semantic equivalence, and keep cache state independent of presentation state.
                    """#
                )
            },

            .init(
                area: .structure,
                key: "operation_abstractions",
                title: "Operation Abstractions",
                guidelines: OperationAbstractionGuideline.allCases.map {
                    .operation_abstractions($0)
                }
            ) {
                paragraph(
                    #"""
                    Operation abstractions are justified by repeated real convergence across domains, not by the visual symmetry of the operational model. Keep generic protocols microscopic, test them against actual native APIs, and prefer the structural discipline itself over a universal abstraction when domains do not naturally fit.
                    """#
                )
            },

            .init(
                area: .structure,
                key: "compaction_passes",
                title: "Compaction Passes",
                guidelines: CompactionPassGuideline.allCases.map {
                    .compaction_passes($0)
                }
            ) {
                paragraph(
                    #"""
                    Compaction is the deliberate reduction step after implementation stabilizes. Remove discovery scaffolding, duplicate paths, speculative portability, and intermediates that add no durable domain, reuse, compatibility, readability, or boundary value while preserving structure that has actually earned its place.
                    """#
                )
            },

        ]
    }
}
