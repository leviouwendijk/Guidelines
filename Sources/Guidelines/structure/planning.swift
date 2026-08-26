public enum PlanningGuideline: String, Sendable, Hashable, CaseIterable {
    case plan_when_valuable
    case inspect_what_executes
    case preserve_plan_preconditions
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
                    A plan is an executable description of intended work. Introduce one when representing the concrete work independently before execution creates useful inspection, control, reuse, or determinism. Planning is not a mandatory stage for every operation.
                    """#
                )

                example("Keep simple operations direct") {
                    paragraph(
                        #"""
                        Operations such as these often need no independently modeled plan:
                        """#
                    )

                    list(
                        style: .unordered,
                        items: [
                            "read a file",
                            "calculate a hash",
                            "parse a value",
                            "render a string",
                        ]
                    )

                    paragraph(
                        #"""
                        A direct input-to-result path may already express the complete operation cleanly.
                        """#
                    )
                }

                paragraph(
                    #"""
                    Planning becomes more valuable as concrete work becomes expensive to rediscover or important to inspect before effects begin.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "multi-step",
                        "expensive",
                        "mutating",
                        "reviewable",
                        "resumable",
                        "cacheable",
                        "approvable",
                        "worth previewing or testing independently",
                    ]
                )

                example("Represent a concrete sync before running it") {
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

                    code(
                        language: "swift",
                        content: #"""
                        let plan = try synchronizer.plan(input)
                        let result = try await synchronizer.run(plan)
                        """#
                    )

                    paragraph(
                        #"""
                        This shape lets inspection, testing, approval, and execution refer to the same concrete work rather than inspecting one interpretation and having `run(input)` independently rediscover another.
                        """#
                    )
                }
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
                quote(
                    #"""
                    The thing inspected should, wherever reasonable, be the thing executed.
                    """#
                )

                paragraph(
                    #"""
                    Inspection is meaningful only while it remains connected to execution. Human confirmation, Agentic approval, dry runs, tests, resumability, and deterministic execution all become weaker when execution silently performs a second independent planning pass.
                    """#
                )

                example("Preserve one concrete work identity") {
                    code(
                        language: "text",
                        content: #"""
                        requested intent
                            ↓
                        concrete plan
                            ├── inspect
                            ├── test
                            ├── approve
                            └── execute
                        """#
                    )

                    paragraph(
                        #"""
                        The different consumers may observe different projections of the plan, but execution should still be grounded in the same concrete work identity.
                        """#
                    )
                }

                paragraph(
                    #"""
                    If the domain genuinely requires replanning against fresh state, make that transition explicit. A materially different plan should be treated as new work and re-inspected or re-approved when those guarantees matter.
                    """#
                )
            }

        case .preserve_plan_preconditions:
            .init(
                title: "Preserve state-dependent plan preconditions",
                summary: #"""
                When a plan depends on mutable state, retain enough precondition
                information to detect material drift before execution.
                """#
            ) {
                paragraph(
                    #"""
                    A plan prepared from mutable state should preserve enough information to determine whether the work it describes is still the work that was inspected. The goal is not to snapshot the entire environment; it is to retain the assumptions whose change would materially alter execution.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "content fingerprints",
                        "versions or revisions",
                        "resource identifiers",
                        "expected before-state",
                        "base commits",
                        "ETags or equivalent remote versions",
                        "resolved source and destination identities",
                    ]
                )

                quote(
                    #"""
                    A reviewed plan should not silently become different work because its environment changed.
                    """#
                )

                paragraph(
                    #"""
                    Choose guards according to the domain. Preserve only the preconditions needed to detect drift that would materially change the meaning, applicability, or safety of execution.
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
                    A plan describes domain work. It may expose enough semantic information for many consumers to inspect that work, but it should not encode the presentation or interaction vocabulary of whichever consumer happens to inspect it first.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "terminal color",
                        "JSON formatting",
                        "GUI layout",
                        "Agentic approval wording",
                        "HTTP response shape",
                    ]
                )

                example("Project the same plan into different consumers") {
                    code(
                        language: "text",
                        content: #"""
                        Domain Plan
                            ├── terminal preview
                            ├── Agentic approval projection
                            ├── GUI review
                            ├── test inspection
                            └── execution
                        """#
                    )

                    paragraph(
                        #"""
                        Those consumers may render or summarize the plan differently without changing the domain-native work the plan represents.
                        """#
                    )
                }
            }
        }
    }
}
