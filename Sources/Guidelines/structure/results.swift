public enum ResultGuideline: String, Sendable, Hashable, CaseIterable {
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
                    A result describes the authoritative semantic outcome of an operation. It should preserve the meaningful state produced by the operation rather than merely report how one consumer happened to present that state.
                    """#
                )

                example("Ask what another consumer would need") {
                    quote(
                        #"""
                        What durable or meaningful state came out of this operation?
                        """#
                    )

                    paragraph(
                        #"""
                        That is a stronger design question than asking what the current CLI printed, which log lines appeared, or whether a presenter displayed a success indicator.
                        """#
                    )
                }

                example("Return domain information, not presentation state") {
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

                        SyncResult
                            created
                            updated
                            deleted
                            skipped
                            bytes transferred
                            post-actions

                        CompilationResult
                            model
                            diagnostics
                            generated entries
                            output
                        """#
                    )
                }

                quote(
                    #"""
                    If a completely different front-end consumed this tomorrow, would the result still be useful?
                    """#
                )

                paragraph(
                    #"""
                    A result that survives that test is likely carrying semantic information rather than presentation state. It also need not collapse every meaningful outcome into a boolean success flag.
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
                    Meaningful final state belongs in the operation result. Events, logs, terminal output, and presenter state may describe or project what happened, but they should not become the only place from which callers can reconstruct the authoritative outcome.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "Events describe observations during execution.",
                        "Logs provide diagnostic or operational records.",
                        "Terminal and GUI output present information for a particular interface.",
                        "The result carries the semantically meaningful final information that later code may depend on.",
                    ]
                )

                quote(
                    #"""
                    Callers should consume final meaning from the result, not reverse-engineer it from observations.
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
                    Preserve the richest reasonably reusable semantic representation until a real boundary requires something narrower. Early irreversible projection makes the first consumer convenient by making later consumers reconstruct information that the operation already knew.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "terminal strings",
                        "JSON payloads",
                        "HTML",
                        "GUI rows or view state",
                        "Agentic messages or envelopes",
                    ]
                )

                example("Preserve a reusable projection before terminal lowering") {
                    code(
                        language: "text",
                        content: #"""
                        // Prefer when several consumers need shared layout meaning.
                        TextDifference
                            ↓
                        DifferenceLayout
                            ├── basic renderer
                            ├── terminal renderer
                            └── other consumers

                        // Avoid irreversible narrowing when richer meaning is reusable.
                        TextDifference
                            ↓
                        terminal String
                        """#
                    )

                    paragraph(
                        #"""
                        `DifferenceLayout` earns its place when it preserves information shared by several legitimate output paths. If no such reusable meaning exists, an intermediate projection should not be manufactured merely to delay rendering.
                        """#
                    )
                }
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
                    An intermediate model is useful when it contributes independent semantic or architectural value. Do not create one merely because another box can be drawn between computation and presentation.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "Preserve information needed by several consumers.",
                        "Add reusable semantic enrichment that is meaningful independently of one presenter.",
                        "Support useful independent inspection or testing.",
                        "Create a stable boundary between domain computation and output adaptation.",
                        "Materially improve readability or cohesion by naming a real intermediate concept.",
                    ]
                )

                paragraph(
                    #"""
                    If an intermediate value has one trivial consumer and no independent meaning, keeping it private or collapsing it is usually the cleaner design.
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
                    A dedicated result type should represent useful result structure. When an existing primitive or domain type already expresses the complete outcome, wrapping it only to make the return value look architectural adds representation without adding meaning.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "Bool",
                        "Int",
                        "String",
                        "Decimal",
                        "URL",
                        "an existing domain type that already represents the complete outcome",
                    ]
                )

                example("Do not rename a primitive without adding structure") {
                    code(
                        language: "swift",
                        content: #"""
                        // Sufficient when the complete semantic question is boolean.
                        Compare.Number.Decimal.exceeds(...)
                            -> Bool

                        // Avoid when the wrapper adds no additional meaning.
                        DecimalComparisonResult(
                            exceedsTolerance: true
                        )
                        """#
                    )
                }

                paragraph(
                    #"""
                    Introduce a result struct when there is actual result structure to preserve: several meaningful fields, invariants, behavior, identity, reusable projections, or other semantics that cannot be expressed adequately by the existing value.
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
                    An operation can complete meaningfully without producing a mutation or conventional success payload. When the absence of change is part of the domain's expected state space, model it as an outcome rather than forcing it into an exceptional failure path.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "no changes",
                        "already up to date",
                        "zero matches",
                        "cache miss",
                        "conflict detected",
                    ]
                )

                paragraph(
                    #"""
                    Whether a particular state is a normal result, a distinguished no-op, or a failure is a domain decision. The Failure and Outcome chapter governs that distinction more broadly.
                    """#
                )
            }
        }
    }
}
