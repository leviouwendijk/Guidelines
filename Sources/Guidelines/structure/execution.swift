public enum ExecutionGuideline: String, Sendable, Hashable, CaseIterable {
    case remove_ambiguity_before_execution
    case reject_material_plan_drift
    case owns_domain_effects
    case no_ambient_semantic_output
    case observation_not_presentation
    case domain_neutral_cancellation_failure

    public var content: GuidelineContent {
        switch self {
        case .remove_ambiguity_before_execution:
            .init(
                title: "Remove avoidable ambiguity before execution",
                summary: #"""
                Execution should receive sufficiently resolved intent or a concrete plan
                and perform the domain work rather than repeatedly rediscovering what
                should happen.
                """#
            ) {
                quote(
                    #"""
                    Execution should be boring.
                    """#
                )

                paragraph(
                    #"""
                    By the time an operation reaches execution, remove as much avoidable interpretive ambiguity as practical. Execution should primarily carry out already meaningful work rather than re-parse loose input, re-resolve ordinary intent, or silently invent a new plan.
                    """#
                )

                example("Let execution receive concrete meaning") {
                    code(
                        language: "text",
                        content: #"""
                        simple operation
                            Resolved Input
                                ↓
                            Execution
                                ↓
                            Result

                        planned operation
                            Plan
                                ↓
                            Execution
                                ↓
                            Result
                        """#
                    )

                    paragraph(
                        #"""
                        This is the boundary where intended domain effects occur. Resolution and planning may be omitted when they add no independent value, but ambiguity should not survive into execution merely because earlier roles were collapsed.
                        """#
                    )
                }
            }

        case .reject_material_plan_drift:
            .init(
                title: "Reject material plan drift",
                summary: #"""
                When execution depends on a previously prepared plan, detect material
                state drift and reject, re-plan, or explicitly re-resolve rather than
                silently executing different work.
                """#
            ) {
                paragraph(
                    #"""
                    A concrete plan may become stale after inspection or approval. Before effectful execution, re-check the domain preconditions whose change could materially alter the work the plan represents.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "file fingerprints or expected before-state changed",
                        "sync source or destination identity changed",
                        "deployment input changed",
                        "accounting state changed",
                        "Git base revision moved",
                        "remote resource version changed",
                    ]
                )

                quote(
                    #"""
                    Do not execute materially different work under an earlier preview, approval, test, or expectation.
                    """#
                )

                paragraph(
                    #"""
                    When material drift is detected, reject the stale plan, produce a new plan, or explicitly re-resolve according to domain policy. If the resulting work is materially different, treat it as new work for any inspection or approval guarantees that matter.
                    """#
                )
            }

        case .owns_domain_effects:
            .init(
                title: "Execution owns domain effects",
                summary: #"""
                Execution owns intended domain effects while remaining independent of
                terminal, GUI, JSON, Agentic, and other presentation policy.
                """#
            ) {
                paragraph(
                    #"""
                    Execution is where the operation performs the effects that belong to the domain. Those effects may be substantial; what should remain outside is consumer-specific presentation and interaction policy.
                    """#
                )

                example("Keep effect ownership separate from presentation ownership") {
                    paragraph(
                        #"""
                        Execution may legitimately:
                        """#
                    )

                    list(
                        style: .unordered,
                        items: [
                            "write files",
                            "run subprocesses",
                            "update records",
                            "move artifacts",
                            "send requests",
                            "compile output",
                            "perform synchronization",
                        ]
                    )

                    paragraph(
                        #"""
                        Execution should not need to decide:
                        """#
                    )

                    list(
                        style: .unordered,
                        items: [
                            "how output is colored",
                            "whether JSON or pretty text is desired",
                            "what the terminal width is",
                            "how an Agentic result should be phrased",
                            "how a GUI displays progress",
                        ]
                    )
                }

                paragraph(
                    #"""
                    Execution should know how to do the work and what semantic outcome it produced, not how every possible consumer wants that work represented.
                    """#
                )
            }

        case .no_ambient_semantic_output:
            .init(
                title: "Do not use ambient output as the semantic API",
                summary: #"""
                Reusable operations should return semantic outcomes and expose structured
                observation rather than requiring callers to infer meaning from stdout,
                stderr, logs, terminal state, or other ambient presentation channels.
                """#
            ) {
                paragraph(
                    #"""
                    Ambient output may be useful for presentation, diagnostics, or observation. It should not be the only place where a reusable operation communicates meaningful state.
                    """#
                )

                example("Give each kind of information an explicit semantic path") {
                    code(
                        language: "text",
                        content: #"""
                        final semantic outcome
                            → Result / domain value

                        temporal progress
                            → Event / structured observation

                        human-facing output
                            → presenter / interface
                        """#
                    )
                }

                paragraph(
                    #"""
                    A CLI may print the returned result and render emitted events. Another Swift caller should be able to use the same operation without parsing those prints, scraping logs, or observing terminal state.
                    """#
                )
            }

        case .observation_not_presentation:
            .init(
                title: "Observation is not presentation",
                summary: #"""
                Execution may emit typed observations without printing or otherwise
                binding those observations to a particular presentation surface.
                """#
            ) {
                paragraph(
                    #"""
                    Typed events let execution expose temporal domain information without taking ownership of how that information is shown.
                    """#
                )

                example("Project one event stream into different consumers") {
                    code(
                        language: "text",
                        content: #"""
                        execution emits Event
                            ├── CLI renders progress
                            ├── Agentic records runtime observation
                            ├── GUI updates state
                            ├── structured logger records it
                            └── another library ignores it
                        """#
                    )
                }

                paragraph(
                    #"""
                    The execution surface remains the same regardless of which observers are attached. The Events chapter governs the event representation and its relationship to authoritative results.
                    """#
                )
            }

        case .domain_neutral_cancellation_failure:
            .init(
                title: "Cancellation and failure remain domain-neutral",
                summary: #"""
                Keep cancellation, interruption, and typed execution failures independent
                of presentation wherever practical.
                """#
            ) {
                paragraph(
                    #"""
                    Long-running execution may support cancellation or interruption, and execution may fail while carrying out its contract. Those mechanics should remain expressible without requiring terminal, GUI, HTTP, or Agentic presentation concepts.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "Represent cancellation or interruption through execution semantics rather than presenter state.",
                        "Preserve typed failure meaning instead of reducing failures to display strings.",
                        "Let outer interfaces decide whether a failure becomes terminal diagnostics, an HTTP response, a GUI state, or another projection.",
                        "Do not make presentation callbacks or ambient output the only signal that execution stopped or failed.",
                    ]
                )
            }
        }
    }
}
