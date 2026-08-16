public enum PlanningGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
    case plan_when_valuable
    case inspect_what_executes
    case domain_native_plans

    public var content: GuidelineContent {
        switch self {
        case .plan_when_valuable:
            .init(
                title: "Introduce planning when concrete work benefits from inspection",
                summary: #"""
                Use a plan when work is sufficiently multi-step, expensive, mutating,
                reviewable, resumable, cacheable, approvable, or worth previewing; keep
                simple operations direct.
                """#
            ) {
                paragraph(
                    #"""
                    A plan is an executable description of intended work.
                    """#
                )

                paragraph(
                    #"""
                    Not every operation needs one.
                    """#
                )

                paragraph(
                    #"""
                    For operations such as:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    read a file
                    calculate a hash
                    parse a value
                    render a string
                    """#
                )

                paragraph(
                    #"""
                    a direct input-to-result path may already be correct.
                    """#
                )

                paragraph(
                    #"""
                    Planning becomes valuable when work is:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    multi-step
                    expensive
                    mutating
                    reviewable
                    resumable
                    cacheable
                    approvable
                    worth previewing
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
                    Input
                        "sync these projects"
                    
                            ↓
                    
                    Plan
                        resolved source
                        resolved destination
                        files to create
                        files to update
                        files to remove
                        commands to run
                        expected bytes
                    """#
                )

                paragraph(
                    #"""
                    Then prefer a shape such as:
                    """#
                )

                code(
                    language: "swift",
                    content: #"""
                    let plan = try synchronizer.plan(input)
                    let result = try await synchronizer.run(plan)
                    """#
                )

                paragraph(
                    #"""
                    over inspecting one interpretation and later having `run(input)` independently rediscover what should happen.
                    """#
                )
            }

        case .inspect_what_executes:
            .init(
                title: "Inspected work should be executed work",
                summary: #"""
                Where reasonable, execute the same concrete plan that was inspected,
                approved, tested, or previewed rather than independently replanning at
                execution time.
                """#
            ) {
                paragraph(
                    #"""
                    A central invariant is:
                    """#
                )

                quote(
                    #"""
                    **The thing inspected should, wherever reasonable, be the thing executed.**
                    """#
                )

                paragraph(
                    #"""
                    This is useful for human confirmation, Agentic approval, dry runs, testing, resumability, and deterministic execution.
                    """#
                )

                paragraph(
                    #"""
                    If environmental state can invalidate a plan between planning and execution, that should be handled explicitly through preflight, freshness checks, plan invalidation, or another domain-appropriate mechanism.
                    """#
                )

                paragraph(
                    #"""
                    It should not silently turn execution into a second independent planning pass.
                    """#
                )
            }

        case .domain_native_plans:
            .init(
                title: "Plans remain domain-native",
                summary: #"""
                Keep plans focused on concrete domain work rather than terminal, GUI,
                HTTP, Agentic, or other presentation concerns.
                """#
            ) {
                paragraph(
                    #"""
                    A plan describes domain work.
                    """#
                )

                paragraph(
                    #"""
                    It should not need to know:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    terminal color
                    JSON formatting
                    GUI layout
                    Agentic approval wording
                    HTTP response shape
                    """#
                )

                paragraph(
                    #"""
                    Those concerns belong outside the plan.
                    """#
                )
            }
        }
    }
}
