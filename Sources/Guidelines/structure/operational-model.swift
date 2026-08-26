public enum OperationalModelGuideline: String, Sendable, Hashable, CaseIterable {
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
                paragraph(
                    #"""
                    Operational roles are a vocabulary for recognizing meaningful boundaries, not a pipeline every operation must instantiate. Choose the smallest shape that still preserves the distinctions the operation actually needs.
                    """#
                )

                section("Tiny pure operation") {
                    code(
                        language: "text",
                        content: #"""
                        values → value
                        """#
                    )

                    example("Direct values may already express the whole operation") {
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
                            Do not manufacture input, result, planning, or execution carriers around a tiny operation when its arguments and return value already express the complete meaning clearly.
                            """#
                        )
                    }
                }

                section("Small structured operation") {
                    code(
                        language: "text",
                        content: #"""
                        Input → Result
                        """#
                    )

                    paragraph(
                        #"""
                        A named input or result becomes useful when the value itself has enough meaning to deserve identity, reuse, invariants, storage, inspection, or clearer reading.
                        """#
                    )
                }

                section("Read or query operation") {
                    code(
                        language: "text",
                        content: #"""
                        Input → Resolution → Result
                        """#
                    )

                    paragraph(
                        #"""
                        Resolution may be an internal stage. It does not require a dedicated `ResolvedInput` type when the resolved value is tiny and local.
                        """#
                    )
                }

                section("Long-running pure operation") {
                    code(
                        language: "text",
                        content: #"""
                        Input → Execution → Events + Result
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
                            → Plan
                            → Preflight
                            → Execution
                            → Events + Result
                        """#
                    )

                    paragraph(
                        #"""
                        Planning and preflight become useful when inspection, approval, reproducibility, safety, or determinism justify independently representing those roles.
                        """#
                    )
                }

                section("Complex externally presented operation") {
                    code(
                        language: "text",
                        content: #"""
                        Input
                            → Resolution
                            → Plan
                            → Preflight
                            → Execution
                            → Events
                            → Result + Artifacts
                            → Projection
                            → Presenter
                        """#
                    )

                    paragraph(
                        #"""
                        Intermediate projections may be useful when several real consumers need a shared enriched representation before final output.
                        """#
                    )
                }

                quote(
                    #"""
                    Add a role when it preserves meaningful separation; collapse it when it adds only ceremony.
                    """#
                )
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
                    The conceptual existence of a stage is weaker than the need for a dedicated carrier type. A type earns its place when the represented value becomes meaningfully useful beyond one short-lived local step.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "The value has independent semantic identity.",
                        "The value is consumed in several places.",
                        "The value travels across meaningful boundaries or stages.",
                        "The value is persisted or transported.",
                        "The value carries invariants.",
                        "The value needs dedicated behavior.",
                        "The type substantially improves readability or cohesion.",
                    ]
                )

                paragraph(
                    #"""
                    A tuple, primitive, existing domain type, or local value may remain preferable for a tiny stage with one obvious consumer.
                    """#
                )

                quote(
                    #"""
                    The architecture is a vocabulary for separation, not a checklist requiring one struct for every named role.
                    """#
                )
            }
        }
    }
}
