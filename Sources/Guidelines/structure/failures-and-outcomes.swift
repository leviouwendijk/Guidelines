public enum FailureAndOutcomeGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
    case outcome_vs_failure
    case avoid_success_wrappers
    case typed_boundary_failures

    public var content: GuidelineContent {
        switch self {
        case .outcome_vs_failure:
            .init(
                title: "Distinguish domain outcomes from execution failures",
                summary: #"""
                Represent meaningful non-happy-path outcomes as domain results or
                reports, and reserve failure for cases where the operation cannot
                fulfill its contract.
                """#
            ) {
                paragraph(
                    #"""
                    Not every non-happy-path state is an error.
                    """#
                )

                paragraph(
                    #"""
                    If something is a meaningful domain outcome, it often belongs in a typed result or report.
                    """#
                )

                paragraph(
                    #"""
                    Examples:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    no changes
                    already up to date
                    validation findings
                    0 matches
                    cache miss
                    conflict detected
                    nothing eligible to process
                    """#
                )

                paragraph(
                    #"""
                    These may be completely valid outcomes of successfully executed domain logic.
                    """#
                )

                paragraph(
                    #"""
                    By contrast, if the operation could not fulfill its contract:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    cannot read required file
                    malformed internal state
                    permission denied
                    subprocess unexpectedly vanished
                    corrupt cache record
                    required dependency unavailable
                    """#
                )

                paragraph(
                    #"""
                    throwing may be appropriate.
                    """#
                )
            }

        case .avoid_success_wrappers:
            .init(
                title: "Do not manufacture success wrappers everywhere",
                summary: #"""
                Use throwing for semantically exceptional failures and typed results for
                meaningful outcomes instead of bespoke success flags around another
                result.
                """#
            ) {
                paragraph(
                    #"""
                    Avoid routinely turning operations into shapes equivalent to:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    Result<ActualResult, Error>
                    """#
                )

                paragraph(
                    #"""
                    inside another bespoke object that also contains a success flag.
                    """#
                )

                paragraph(
                    #"""
                    Use the language's throwing model for failures when throwing is semantically appropriate.
                    """#
                )

                paragraph(
                    #"""
                    Use typed domain results for meaningful outcomes.
                    """#
                )
            }

        case .typed_boundary_failures:
            .init(
                title: "Boundary failures should remain typed",
                summary: #"""
                Preserve enough typed meaning in parsing, resolution, planning, and
                execution failures for outer adapters to recover or present them without
                parsing strings.
                """#
            ) {
                paragraph(
                    #"""
                    Parsing, resolution, planning, and execution may fail for different reasons.
                    """#
                )

                paragraph(
                    #"""
                    They do not always need separate error hierarchies, but errors should preserve enough domain meaning that outer adapters can decide how to present or recover from them without parsing strings.
                    """#
                )
            }
        }
    }
}
