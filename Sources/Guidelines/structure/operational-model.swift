public enum OperationalModelGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
    case collapsed_forms
    case role_does_not_require_type

    public var content: GuidelineContent {
        switch self {
        case .collapsed_forms:
            .init(
                title: "Choose the operational shape proportionally",
                summary: #"""
                Collapse the operational model to the smallest form that preserves the
                meaningful roles required by a tiny, structured, read, long-running,
                mutating, or externally presented operation.
                """#
            ) {
                section("Tiny pure operation") {
                    paragraph(
                        #"""
                        Often the cleanest architecture is simply:
                        """#
                    )

                    code(
                        language: "text",
                        content: #"""
                        values -> value
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
                        Compare.Number.Decimal.exceeds(
                            difference,
                            tolerance: tolerance
                        )
                        """#
                    )

                    paragraph(
                        #"""
                        There is no requirement to manufacture an input or result type around a small operation when the arguments and return value already express its meaning clearly.
                        """#
                    )
                }

                section("Small structured operation") {
                    code(
                        language: "text",
                        content: #"""
                        Input -> Result
                        """#
                    )

                    paragraph(
                        #"""
                        A named input or result becomes useful when the value itself has enough meaning to deserve identity, reuse, invariants, storage, inspection, or clearer reading.
                        """#
                    )
                }

                section("Read/query operation") {
                    code(
                        language: "text",
                        content: #"""
                        Input -> Resolution -> Result
                        """#
                    )

                    paragraph(
                        #"""
                        Resolution does not require a ResolvedInput type when the resolved value is tiny and local.
                        """#
                    )

                    paragraph(
                        #"""
                        It may instead be an internal stage.
                        """#
                    )
                }

                section("Long-running pure operation") {
                    code(
                        language: "text",
                        content: #"""
                        Input -> Execution -> Events + Result
                        """#
                    )

                    paragraph(
                        #"""
                        Events become useful when temporal observation matters independently of the final result.
                        """#
                    )
                }

                section("Mutating operation") {
                    code(
                        language: "text",
                        content: #"""
                        Input
                            -> Plan
                            -> Preflight
                            -> Execution
                            -> Events + Result
                        """#
                    )

                    paragraph(
                        #"""
                        Planning and preflight become useful when inspection, approval, reproducibility, safety, or determinism justify them.
                        """#
                    )
                }

                section("Complex externally presented operation") {
                    code(
                        language: "text",
                        content: #"""
                        Input
                            -> Resolution
                            -> Plan
                            -> Preflight
                            -> Execution
                            -> Events
                            -> Result + Artifacts
                            -> Projection
                            -> Presenter
                        """#
                    )

                    paragraph(
                        #"""
                        Intermediate projections may be useful when several consumers need a shared enriched representation before final output.
                        """#
                    )
                }
            }

        case .role_does_not_require_type:
            .init(
                title: "A role does not automatically earn a type",
                summary: #"""
                Create a dedicated carrier type only when the represented value gains
                enough identity, reuse, invariants, transport, behavior, readability, or
                cohesion to justify it.
                """#
            ) {
                paragraph(
                    #"""
                    The conceptual existence of a stage is weaker than the need for a dedicated carrier type.
                    """#
                )

                paragraph(
                    #"""
                    A type is more justified when its value:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    has independent semantic identity
                    is consumed in several places
                    is passed across layers
                    is persisted or transported
                    carries invariants
                    needs dedicated behavior
                    substantially improves readability
                    """#
                )

                paragraph(
                    #"""
                    A tuple, primitive, or local value may remain preferable for a tiny short-lived stage with one obvious consumer.
                    """#
                )

                paragraph(
                    #"""
                    The architecture is a vocabulary for separation, not a checklist requiring seven structs.
                    """#
                )
            }
        }
    }
}
