public enum ExecutionGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
    case remove_ambiguity_before_execution
    case owns_domain_effects
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
