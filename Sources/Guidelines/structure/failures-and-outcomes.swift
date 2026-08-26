public enum FailureAndOutcomeGuideline: String, Sendable, Hashable, CaseIterable {
    case outcome_vs_failure
    case avoid_success_wrappers
    case typed_boundary_failures

    public var content: GuidelineContent {
        switch self {
        case .outcome_vs_failure:
            .init(
                title: "Distinguish domain outcomes from execution failures",
                summary: #"""
                Represent meaningful non-happy-path outcomes as domain results or reports,
                and reserve failure for cases where the operation cannot fulfill its
                contract.
                """#
            ) {
                paragraph(
                    #"""
                    Not every non-happy-path state is an error. If a state is a meaningful and expected possibility of successfully executed domain logic, represent it as an outcome rather than forcing it into the failure channel.
                    """#
                )

                example("Separate valid outcomes from contract failures") {
                    paragraph(
                        #"""
                        Meaningful domain outcomes may include:
                        """#
                    )

                    list(
                        style: .unordered,
                        items: [
                            "no changes",
                            "already up to date",
                            "validation findings",
                            "zero matches",
                            "cache miss",
                            "conflict detected",
                            "nothing eligible to process",
                        ]
                    )

                    paragraph(
                        #"""
                        Execution failures may include:
                        """#
                    )

                    list(
                        style: .unordered,
                        items: [
                            "cannot read a required file",
                            "malformed internal state",
                            "permission denied",
                            "subprocess unexpectedly vanished",
                            "corrupt cache record",
                            "required dependency unavailable",
                        ]
                    )
                }

                paragraph(
                    #"""
                    The exact classification is domain-relative. The useful distinction is whether the operation fulfilled its contract and produced a meaningful state, or whether it could not complete that contract.
                    """#
                )
            }

        case .avoid_success_wrappers:
            .init(
                title: "Do not manufacture success wrappers everywhere",
                summary: #"""
                Use throwing for semantically exceptional failures and typed results for
                meaningful outcomes instead of layering bespoke success flags around
                another result.
                """#
            ) {
                paragraph(
                    #"""
                    Do not add an application-specific success envelope merely to repeat information already expressed by the language's throwing model and the operation's semantic result.
                    """#
                )

                example("Avoid redundant success state") {
                    code(
                        language: "text",
                        content: #"""
                        // Avoid redundant layering.
                        OperationResponse
                            success: Bool
                            result: Result<ActualResult, Error>

                        // Prefer the ordinary operation contract when it fits.
                        throws -> ActualResult
                        """#
                    )
                }

                list(
                    style: .unordered,
                    items: [
                        "Use throwing when failure means the operation could not fulfill its contract and throwing is appropriate for the API.",
                        "Use typed domain results or reports for meaningful outcomes, including legitimate non-happy-path states.",
                        "Add an explicit outcome enum or result carrier when the domain has several meaningful states that need to travel as values.",
                        "Do not add a `success` boolean that merely duplicates information already expressed by the returned value or thrown failure.",
                    ]
                )
            }

        case .typed_boundary_failures:
            .init(
                title: "Boundary failures should remain typed",
                summary: #"""
                Preserve enough typed meaning in parsing, resolution, planning, preflight,
                and execution failures for outer adapters to recover or present them
                without parsing strings.
                """#
            ) {
                paragraph(
                    #"""
                    Different operational boundaries may fail for different reasons. They do not require a separate error hierarchy merely because the boundary has a name, but failures should preserve enough semantic information for callers to distinguish meaningful cases without scraping prose.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "Preserve identifiers, paths, revisions, fields, or other structured context when that information matters to recovery.",
                        "Keep machine-meaningful failure categories separate from human-facing wording.",
                        "Let outer adapters choose terminal diagnostics, HTTP responses, Agentic errors, GUI state, retry behavior, or other presentation from the typed failure.",
                        "Do not reduce a recoverable boundary failure to a string before the boundary that actually requires prose.",
                    ]
                )

                quote(
                    #"""
                    Presentation may stringify a failure; reusable domain code should not require callers to parse that string back into meaning.
                    """#
                )
            }
        }
    }
}
