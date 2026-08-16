public enum ResolutionGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
    case environment_dependent_intent
    case resolve_once
    case resolved_type_earned
    case local_tuples
    case distinct_from_parsing

    public var content: GuidelineContent {
        switch self {
        case .environment_dependent_intent:
            .init(
                title: "Resolve requested intent against the current environment",
                summary: #"""
                Turn meaningful but environment-dependent requests into concrete meaning
                before later stages depend on paths, aliases, targets, accounts,
                configurations, or similar resolved state.
                """#
            ) {
                paragraph(
                    #"""
                    Resolution turns requested intent into concrete meaning in the current environment.
                    """#
                )

                paragraph(
                    #"""
                    Input may contain values such as:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    "master"
                    "~/foo"
                    target name
                    configuration alias
                    environment
                    glob
                    date range
                    account alias
                    sync route
                    """#
                )

                paragraph(
                    #"""
                    These are meaningful requests, but they may still require interpretation.
                    """#
                )

                paragraph(
                    #"""
                    Conceptually:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    Input
                        requested intent
                    
                            ↓ resolution
                    
                    Resolved meaning
                        intent interpreted against the current environment
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
                    BuildRequest
                        target: "server-package"
                        configuration: release
                    """#
                )

                paragraph(
                    #"""
                    may resolve to:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    ResolvedBuildRequest
                        packageRoot: /actual/path
                        target: server-package
                        configuration: release
                        executableDestination: /actual/sbm-bin/...
                    """#
                )
            }

        case .resolve_once:
            .init(
                title: "Resolve once where practical",
                summary: #"""
                Resolve environment-dependent intent once where practical and let later
                stages operate on that concrete meaning instead of independently
                reinterpreting it.
                """#
            ) {
                paragraph(
                    #"""
                    Execution should not continuously reinterpret caller intent.
                    """#
                )

                paragraph(
                    #"""
                    If a path, alias, target, account, environment, or configuration has already been resolved, later stages should generally operate on that concrete meaning rather than independently resolving it again.
                    """#
                )

                paragraph(
                    #"""
                    This improves:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    determinism
                    inspectability
                    testability
                    planning
                    approval
                    reuse
                    """#
                )

                paragraph(
                    #"""
                    It also makes environmental interpretation a visible boundary rather than an incidental side effect scattered through execution.
                    """#
                )
            }

        case .resolved_type_earned:
            .init(
                title: "Resolution does not automatically imply a Resolved type",
                summary: #"""
                Create a named resolved type only when the resolved value becomes
                significant, reusable, traveling, invariant-bearing, readable, or
                cohesive enough to earn one.
                """#
            ) {
                paragraph(
                    #"""
                    The resolution role can exist without introducing a dedicated carrier type.
                    """#
                )

                paragraph(
                    #"""
                    For example, a small resolver may return:
                    """#
                )

                code(
                    language: "swift",
                    content: #"""
                    (code: String, id: Int)
                    """#
                )

                paragraph(
                    #"""
                    or:
                    """#
                )

                code(
                    language: "swift",
                    content: #"""
                    URL
                    """#
                )

                paragraph(
                    #"""
                    when the result is tiny, local, and has one obvious consumer.
                    """#
                )

                paragraph(
                    #"""
                    A named resolved type becomes more useful when the result:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    is significant to the domain
                    is passed through several later stages
                    has several consumers
                    needs dedicated behavior
                    carries invariants
                    is stored or transported
                    would otherwise produce difficult tuple signatures
                    substantially improves readability or cohesion
                    """#
                )

                paragraph(
                    #"""
                    For example:
                    """#
                )

                code(
                    language: "swift",
                    content: #"""
                    struct ResolvedAutoCloseTargets {
                        let netIncome: Target
                        let equity: Target
                    }
                    """#
                )

                paragraph(
                    #"""
                    may be preferable when the pair is a meaningful unit in later accounting logic.
                    """#
                )

                paragraph(
                    #"""
                    The purpose of the type is not to prove that resolution occurred.
                    """#
                )

                paragraph(
                    #"""
                    The purpose is to give a meaningful resolved value an appropriate representation.
                    """#
                )
            }

        case .local_tuples:
            .init(
                title: "Tuples are acceptable for limited local results",
                summary: #"""
                Use tuples or primitives for small local resolved values with limited
                consumers, and introduce a named type when the value begins to travel,
                grow, repeat, or gain identity.
                """#
            ) {
                paragraph(
                    #"""
                    A tuple is not architecturally inferior merely because a named type could exist.
                    """#
                )

                paragraph(
                    #"""
                    For a small local operation with a limited consumer:
                    """#
                )

                code(
                    language: "swift",
                    content: #"""
                    (
                        ni: (code: String, id: Int),
                        equity: (code: String, id: Int)
                    )
                    """#
                )

                paragraph(
                    #"""
                    may be sufficient.
                    """#
                )

                paragraph(
                    #"""
                    Prefer a type when the tuple begins to travel, repeat, grow, or acquire independent meaning.
                    """#
                )

                paragraph(
                    #"""
                    This is partly a readability and cohesion decision rather than a mechanical architecture rule.
                    """#
                )
            }

        case .distinct_from_parsing:
            .init(
                title: "Resolution and parsing are related but distinct",
                summary: #"""
                Keep parsing of loose representations conceptually distinct from
                resolving already meaningful intent against environment-dependent state.
                """#
            ) {
                paragraph(
                    #"""
                    Parsing asks whether an external or loose representation can become a stronger domain value.
                    """#
                )

                paragraph(
                    #"""
                    Resolution interprets an already meaningful request against environment-dependent state.
                    """#
                )

                paragraph(
                    #"""
                    They may happen together in simple cases, but they should not be conceptually confused merely because both occur before execution.
                    """#
                )
            }
        }
    }
}
