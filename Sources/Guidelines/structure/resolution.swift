public enum ResolutionGuideline: String, Sendable, Hashable, CaseIterable {
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
                    Resolution turns already meaningful intent into concrete meaning in the environment where the operation will proceed. The caller may know what it wants without yet knowing the exact path, identifier, target, configuration, or other environment-specific value that represents that intent.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "branch or revision names such as `master`",
                        "paths such as `~/foo`",
                        "target names",
                        "configuration aliases",
                        "environment names",
                        "globs and date ranges",
                        "account aliases",
                        "sync routes and similar environment-dependent selections",
                    ]
                )

                example("Turn requested build intent into resolved build meaning") {
                    code(
                        language: "text",
                        content: #"""
                        BuildRequest
                            target: "server-package"
                            configuration: release

                                ↓ resolution

                        ResolvedBuildRequest
                            packageRoot: /actual/path
                            target: server-package
                            configuration: release
                            executableDestination: /actual/sbm-bin/...
                        """#
                    )

                    paragraph(
                        #"""
                        The request already contains domain intent. Resolution interprets that intent against current state so later stages can depend on concrete meaning rather than repeatedly rediscovering it.
                        """#
                    )
                }
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
                    Once environment-dependent intent has been resolved, later stages should generally consume the resolved meaning rather than independently interpreting the caller's original request again.
                    """#
                )

                example("Make resolution a visible boundary") {
                    code(
                        language: "text",
                        content: #"""
                        requested intent
                            ↓
                        resolution
                            ↓
                        resolved meaning
                            ├── planning
                            ├── approval
                            ├── execution
                            └── result construction
                        """#
                    )
                }

                list(
                    style: .unordered,
                    items: [
                        "Improve determinism by preventing later stages from observing different interpretations of the same request.",
                        "Improve inspectability by making the interpreted value explicit before effects occur.",
                        "Improve testability by allowing later behavior to be exercised against known resolved inputs.",
                        "Improve planning and approval by letting those stages reason about the same concrete targets execution will use.",
                        "Improve reuse by keeping environmental interpretation separate from operations that only require resolved values.",
                    ]
                )

                paragraph(
                    #"""
                    Re-resolution may still be intentional when the domain specifically requires fresh environmental state. The default is simply not to make reinterpretation an incidental behavior scattered throughout later execution.
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
                    Resolution is a semantic role, not a requirement that every resolver manufacture a dedicated carrier type. A tiny local resolved value may already have an adequate representation.
                    """#
                )

                example("Keep a tiny local result simple") {
                    code(
                        language: "swift",
                        content: #"""
                        (code: String, id: Int)

                        URL
                        """#
                    )

                    paragraph(
                        #"""
                        These can be sufficient when the result is small, local, and has one obvious consumer.
                        """#
                    )
                }

                list(
                    style: .unordered,
                    items: [
                        "Introduce a named resolved type when the value is significant to the domain.",
                        "Prefer a named type when the value travels through several later stages or has several consumers.",
                        "Prefer a named type when the value needs dedicated behavior or carries invariants.",
                        "Prefer a named type when the value is stored or transported.",
                        "Prefer a named type when tuples or primitive signatures become difficult to read or maintain.",
                        "Prefer a named type when it materially improves cohesion by naming a meaningful unit.",
                    ]
                )

                example("Name a resolved value that has become a domain unit") {
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
                        The type earns its existence when the pair is meaningful in later accounting logic. Its purpose is to represent that meaningful unit, not merely to prove that a resolution step occurred.
                        """#
                    )
                }
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
                    A tuple is not architecturally inferior merely because a named type could exist. For a small local operation, a tuple can communicate the complete resolved value without adding another declaration.
                    """#
                )

                example("Keep a small paired result local") {
                    code(
                        language: "swift",
                        content: #"""
                        (
                            ni: (code: String, id: Int),
                            equity: (code: String, id: Int)
                        )
                        """#
                    )
                }

                list(
                    style: .unordered,
                    items: [
                        "Keep a tuple when its meaning is obvious from a small local scope and it has limited consumers.",
                        "Introduce a named type when the value begins to travel across stages or API boundaries.",
                        "Introduce a named type when the structure repeats, grows, gains behavior, carries invariants, or develops independent identity.",
                        "Treat the choice as a readability and cohesion decision rather than a mechanical preference for named types.",
                    ]
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
                    Parsing and resolution may both occur before execution, but they answer different questions. Parsing strengthens representation; resolution interprets meaningful intent against current environmental state.
                    """#
                )

                example("Distinguish representation from environmental interpretation") {
                    code(
                        language: "text",
                        content: #"""
                        parsing
                            loose external representation
                                ↓
                            stronger domain value

                        resolution
                            meaningful requested intent
                                ↓
                            concrete meaning in the current environment
                        """#
                    )
                }

                paragraph(
                    #"""
                    A simple operation may perform both concerns close together, but proximity does not make them the same semantic role.
                    """#
                )
            }
        }
    }
}
