public enum ExecutionGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
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
                Execution should receive sufficiently resolved intent or a plan and
                perform the domain work rather than repeatedly rediscovering what should
                happen.
                """#
            ) {
                paragraph(
                    #"""
                    Execution should be boring.
                    """#
                )

                paragraph(
                    #"""
                    By the time an operation reaches execution, as much ambiguity as reasonably possible should already have been removed.
                    """#
                )

                paragraph(
                    #"""
                    Execution receives either:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    Resolved Input
                    """#
                )

                paragraph(
                    #"""
                    or, for operations where planning is valuable:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    Plan
                    """#
                )

                paragraph(
                    #"""
                    and performs the domain work.
                    """#
                )

                paragraph(
                    #"""
                    This is where the intended side effects happen.
                    """#
                )
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
                    A plan may become stale after it is prepared.
                    """#
                )

                paragraph(
                    #"""
                    Before effectful execution, verify domain-relevant preconditions when changed state could materially alter what the approved or inspected plan means.
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    file fingerprint changed
                    sync source changed
                    deployment input changed
                    accounting state changed
                    Git base revision moved
                    remote resource version changed
                    """#
                )

                paragraph(
                    #"""
                    When material drift is detected, reject the stale plan, re-plan, or explicitly re-resolve according to domain policy.
                    """#
                )

                paragraph(
                    #"""
                    Do not silently execute materially different work under an earlier preview, approval, test, or expectation.
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
                    Execution may:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    write files
                    run subprocesses
                    update records
                    move artifacts
                    send requests
                    compile output
                    perform synchronization
                    """#
                )

                paragraph(
                    #"""
                    It should not need to decide:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    how output is colored
                    whether JSON or pretty text is desired
                    what terminal width is
                    how an Agentic result should be phrased
                    how a GUI displays progress
                    """#
                )

                paragraph(
                    #"""
                    Execution should know how to do the work, not how every possible consumer wants that work represented.
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
                    Ambient output may be useful for presentation, diagnostics, or observation.
                    """#
                )

                paragraph(
                    #"""
                    It should not be the only place where a reusable operation communicates its meaningful outcome.
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    final semantic outcome
                        -> return Result / domain value

                    temporal progress
                        -> emit Event / structured observation

                    human-facing output
                        -> presenter / interface
                    """#
                )

                paragraph(
                    #"""
                    A CLI may print the returned result and render emitted events. Another Swift caller should be able to use the same operation without parsing those prints.
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
                    Execution may emit typed events.
                    """#
                )

                paragraph(
                    #"""
                    That does not mean it prints progress itself.
                    """#
                )

                paragraph(
                    #"""
                    The same event stream can be:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    rendered by a CLI
                    recorded by Agentic
                    shown by a GUI
                    written to structured logs
                    ignored by another library
                    """#
                )

                paragraph(
                    #"""
                    without changing the execution surface.
                    """#
                )
            }

        case .domain_neutral_cancellation_failure:
            .init(
                title: "Cancellation and failure remain domain-neutral",
                summary: #"""
                Keep cancellation, interruption, and typed execution failures
                independent of presentation wherever practical.
                """#
            ) {
                paragraph(
                    #"""
                    Long-running execution may support cancellation or interruption.
                    """#
                )

                paragraph(
                    #"""
                    Those mechanics should remain independent of presentation wherever practical.
                    """#
                )

                paragraph(
                    #"""
                    Likewise, execution failures should be expressed as meaningful typed errors rather than presentation strings.
                    """#
                )
            }
        }
    }
}
