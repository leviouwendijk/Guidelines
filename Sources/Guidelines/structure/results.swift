public enum ResultGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
    case authoritative_semantic_outcome
    case authoritative_final_state
    case delay_lowering
    case intermediate_result_earned
    case result_struct_earned
    case no_op_outcomes

    public var content: GuidelineContent {
        switch self {
        case .authoritative_semantic_outcome:
            .init(
                title: "Return authoritative semantic outcomes",
                summary: #"""
                Make an operation result describe durable or meaningful domain outcome
                rather than what a particular consumer printed or displayed.
                """#
            ) {
                paragraph(
                    #"""
                    A result describes the authoritative semantic outcome of an operation.
                    """#
                )

                paragraph(
                    #"""
                    It should answer:
                    """#
                )

                quote(
                    #"""
                    What durable or meaningful state came out of this operation?
                    """#
                )

                paragraph(
                    #"""
                    It should not primarily answer:
                    """#
                )

                quote(
                    #"""
                    What did I print?
                    """#
                )

                paragraph(
                    #"""
                    And it does not need to collapse every meaningful outcome into a boolean success flag.
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
                    BuildResult
                        product
                        artifact
                        configuration
                        duration
                        compilation status
                        generated metadata
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    SyncResult
                        created
                        updated
                        deleted
                        skipped
                        bytes transferred
                        post-actions
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    CompilationResult
                        model
                        diagnostics
                        generated entries
                        output
                    """#
                )

                paragraph(
                    #"""
                    A useful test is:
                    """#
                )

                quote(
                    #"""
                    If a completely different front-end consumed this tomorrow, would the result still be useful?
                    """#
                )

                paragraph(
                    #"""
                    If yes, the result is probably carrying domain information rather than presentation state.
                    """#
                )
            }

        case .authoritative_final_state:
            .init(
                title: "Results are authoritative",
                summary: #"""
                Put meaningful final state in the result so callers do not reconstruct
                it from events, logs, terminal output, or presenter state.
                """#
            ) {
                paragraph(
                    #"""
                    Callers should not have to reconstruct meaningful final state by inspecting progress events, terminal output, logs, or presenter state.
                    """#
                )

                paragraph(
                    #"""
                    Those are observations or projections.
                    """#
                )

                paragraph(
                    #"""
                    The result is where semantically meaningful final information belongs.
                    """#
                )
            }

        case .delay_lowering:
            .init(
                title: "Do not lower a reusable result too early",
                summary: #"""
                Preserve the richest reasonably reusable semantic result until an actual
                boundary requires a narrower terminal, JSON, HTML, GUI, Agentic, or
                other projection.
                """#
            ) {
                paragraph(
                    #"""
                    Prefer preserving the richest reasonably reusable semantic representation until a boundary actually requires a narrower one.
                    """#
                )

                paragraph(
                    #"""
                    Avoid prematurely turning:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    DomainResult
                    """#
                )

                paragraph(
                    #"""
                    into:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    terminal String
                    JSON
                    HTML
                    GUI row
                    Agentic message
                    """#
                )

                paragraph(
                    #"""
                    when later consumers may reasonably need the underlying semantic information.
                    """#
                )

                paragraph(
                    #"""
                    Early irreversible projection often causes a later refactor when another consumer appears.
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
                    TextDifference
                        ↓
                    DifferenceLayout
                        ├── basic renderer
                        ├── terminal renderer
                        └── other consumers
                    """#
                )

                paragraph(
                    #"""
                    may be preferable to:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    TextDifference
                        ↓
                    terminal String
                    """#
                )

                paragraph(
                    #"""
                    when DifferenceLayout preserves information shared by several output paths.
                    """#
                )
            }

        case .intermediate_result_earned:
            .init(
                title: "Intermediate results must still earn their existence",
                summary: #"""
                Introduce an intermediate result or projection only when it preserves
                shared information, adds reusable meaning, supports inspection, creates
                a stable boundary, or materially improves cohesion.
                """#
            ) {
                paragraph(
                    #"""
                    Do not introduce an intermediate model merely because another stage can be drawn on an architecture diagram.
                    """#
                )

                paragraph(
                    #"""
                    An intermediate representation is especially useful when it:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    preserves information needed by several consumers
                    adds reusable semantic enrichment
                    can be inspected independently
                    provides a stable boundary between domain computation and output
                    substantially improves readability or cohesion
                    """#
                )

                paragraph(
                    #"""
                    If an intermediate value has only one trivial consumer and no independent meaning, keeping it private or collapsing it may be cleaner.
                    """#
                )
            }

        case .result_struct_earned:
            .init(
                title: "Results do not always need result structs",
                summary: #"""
                Return a primitive or existing type when it already expresses the
                complete semantic result; do not manufacture result structs merely to
                name the role.
                """#
            ) {
                paragraph(
                    #"""
                    A tiny operation may legitimately return:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    Bool
                    Int
                    String
                    Decimal
                    URL
                    """#
                )

                paragraph(
                    #"""
                    when that value already is the complete semantic result.
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
                    Compare.Number.Decimal.exceeds(...)
                        -> Bool
                    """#
                )

                paragraph(
                    #"""
                    does not become more meaningful merely by returning:
                    """#
                )

                code(
                    language: "swift",
                    content: #"""
                    DecimalComparisonResult(
                        exceedsTolerance: true
                    )
                    """#
                )

                paragraph(
                    #"""
                    A result type should represent useful result structure, not merely rename a primitive.
                    """#
                )
            }

        case .no_op_outcomes:
            .init(
                title: "No-op states can be real results",
                summary: #"""
                Represent meaningful no-op and non-error states such as no changes,
                already up to date, zero matches, cache misses, or conflicts as domain
                outcomes when appropriate.
                """#
            ) {
                paragraph(
                    #"""
                    Outcomes such as:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    no changes
                    already up to date
                    0 matches
                    cache miss
                    conflict detected
                    """#
                )

                paragraph(
                    #"""
                    may be legitimate typed domain outcomes rather than exceptional failures.
                    """#
                )

                paragraph(
                    #"""
                    See FailureAndOutcomeGuideline.
                    """#
                )
            }
        }
    }
}
