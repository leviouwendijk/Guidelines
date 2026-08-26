public enum PreflightGuideline: String, Sendable, Hashable, CaseIterable {
    case separate_plan_and_preflight
    case domain_information
    case no_secret_execution

    public var content: GuidelineContent {
        switch self {
        case .separate_plan_and_preflight:
            .init(
                title: "Distinguish planned work from preflight analysis",
                summary: #"""
                Treat a plan as the executable description of intended work and
                preflight as analysis of whether and how that work may proceed,
                combining them only when one type genuinely serves both roles.
                """#
            ) {
                paragraph(
                    #"""
                    Planning and preflight are related because both may occur before effects begin, but they answer different questions. A plan describes the concrete work that is intended to execute. Preflight analyzes the current conditions under which that work may proceed.
                    """#
                )

                example("Distinguish intended work from current applicability") {
                    code(
                        language: "text",
                        content: #"""
                        Plan
                            copy A
                            replace B
                            remove C

                                ↓ preflight

                        PreflightReport
                            3 paths affected
                            28 MB copied
                            destination writable
                            warning: B changed since the cache snapshot
                        """#
                    )

                    paragraph(
                        #"""
                        The plan states what execution means. The preflight report describes relevant facts about attempting that plan now.
                        """#
                    )
                }

                example("One useful composition") {
                    code(
                        language: "text",
                        content: #"""
                        resolved intent
                            ↓
                        plan
                            ↓
                        preflight
                            ↓
                        policy / approval
                            ↓
                        execution
                        """#
                    )

                    paragraph(
                        #"""
                        This is a semantic decomposition, not a mandatory pipeline. Simple operations may collapse several roles, and some domains may combine a plan with its preflight information when one representation genuinely serves both purposes.
                        """#
                    )
                }
            }

        case .domain_information:
            .init(
                title: "Preflight is domain information",
                summary: #"""
                Keep preflight reports domain-native and richer than a boolean gate when
                useful, so outer adapters can present the same findings through terminal,
                Agentic, GUI, HTTP, or other surfaces.
                """#
            ) {
                paragraph(
                    #"""
                    Preflight may discover useful domain information. Do not reduce it to `Bool` merely because one current consumer only needs permission to continue.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "affected resources or paths",
                        "predicted sizes or counts",
                        "capability or permission findings",
                        "state-drift findings",
                        "warnings",
                        "conflicts or blockers",
                        "other domain facts useful to review before execution",
                    ]
                )

                example("Keep the report semantic and adapt it outward") {
                    code(
                        language: "text",
                        content: #"""
                        Sync.PreflightReport
                            ├── terminal confirmation
                            ├── Agentic approval
                            ├── GUI warning
                            └── HTTP response
                        """#
                    )

                    paragraph(
                        #"""
                        The domain report remains authoritative for what preflight discovered. Each outer interface may choose how to present, summarize, or act on that information.
                        """#
                    )
                }
            }

        case .no_secret_execution:
            .init(
                title: "Preflight should not secretly execute",
                summary: #"""
                Allow preflight to inspect state required for safety or feasibility, but
                do not hide the domain mutation it claims only to analyze.
                """#
            ) {
                paragraph(
                    #"""
                    Preflight may inspect whatever state is genuinely required to determine applicability, safety, feasibility, or useful review information. Inspection does not become execution merely because it performs real computation or reads external state.
                    """#
                )

                example("Inspect without performing the intended effect") {
                    code(
                        language: "text",
                        content: #"""
                        reasonable preflight work
                            read metadata
                            inspect revisions
                            check permissions
                            compare expected before-state
                            calculate predicted changes

                        not preflight merely because it happens early
                            rewrite the target files
                            create the intended resources
                            push the intended revision
                            deploy the intended release
                        """#
                    )
                }

                quote(
                    #"""
                    Preflight may determine whether execution may proceed; it should not secretly perform the execution it claims only to analyze.
                    """#
                )

                paragraph(
                    #"""
                    If an inspection operation itself has meaningful external effects, model those effects deliberately rather than hiding them under the word preflight. The boundary should remain truthful about what has already happened.
                    """#
                )
            }
        }
    }
}
