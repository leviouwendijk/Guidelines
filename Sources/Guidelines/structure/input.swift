public enum InputGuideline: String, Sendable, Hashable, CaseIterable {
    case domain_intent
    case no_forced_input_struct
    case input_type_earned
    case abstraction_no_input_type
    case parse_external_boundary

    public var content: GuidelineContent {
        switch self {
        case .domain_intent:
            .init(
                title: "Express input as domain intent",
                summary: #"""
                Let interfaces adapt their syntax into domain intent so the operation
                does not depend on CLI arguments, JSON shape, GUI state, HTTP payloads,
                or other accidental input vehicles.
                """#
            ) {
                paragraph(
                    #"""
                    Input expresses what the caller wants in domain terms. The operation should not depend on the accidental syntax or state representation of the interface that supplied that request.
                    """#
                )

                example("Adapt interface syntax before the domain operation") {
                    code(
                        language: "text",
                        content: #"""
                        CLI arguments ─────┐
                        Agentic JSON ──────┤
                        GUI state ─────────┼──→ domain input
                        HTTP payload ──────┤
                        Swift caller ──────┘
                        """#
                    )

                    code(
                        language: "text",
                        content: #"""
                        // Avoid as the real operation input.
                        ["--recursive", "--force", "./foo"]

                        // Prefer domain meaning.
                        ConcatenationRequest
                        SyncRequest
                        BuildRequest
                        CompilationRequest
                        """#
                    )
                }

                paragraph(
                    #"""
                    This adaptation boundary keeps domain operations portable across interfaces without requiring each operation to understand every external request vehicle.
                    """#
                )
            }

        case .no_forced_input_struct:
            .init(
                title: "Input does not imply an Input struct",
                summary: #"""
                Do not manufacture an input wrapper when arguments or an existing value
                already express a small operation clearly.
                """#
            ) {
                paragraph(
                    #"""
                    An operation having input does not imply that its input needs a dedicated carrier type.
                    """#
                )

                example("Keep small input surfaces direct") {
                    code(
                        language: "swift",
                        content: #"""
                        fingerprint(of: data)

                        Compare.Number.Decimal.exceeds(
                            difference,
                            tolerance: tolerance
                        )
                        """#
                    )

                    paragraph(
                        #"""
                        These calls already express small operations clearly. `FingerprintInput` or `DecimalComparisonInput` would add representation only if the grouped value acquired meaning beyond the immediate call.
                        """#
                    )
                }
            }

        case .input_type_earned:
            .init(
                title: "When an input type earns its existence",
                summary: #"""
                Create a dedicated input type when requested intent becomes a meaningful
                cohesive value with reuse, invariants, transport, inspection, defaults,
                or policy of its own.
                """#
            ) {
                paragraph(
                    #"""
                    A dedicated input type becomes useful when the request itself has become a meaningful cohesive value rather than merely a list of function arguments.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "It contains several related values whose grouping is meaningful.",
                        "It passes through multiple stages or boundaries.",
                        "It is stored or transported.",
                        "It carries invariants.",
                        "Several callers reuse the same request shape.",
                        "It is inspected before execution.",
                        "It has meaningful defaults or policy.",
                        "Naming the grouped value substantially improves cohesion or readability.",
                    ]
                )

                quote(
                    #"""
                    Parameter count is a signal, not the rule; the question is whether the requested intent has become a value of its own.
                    """#
                )
            }

        case .abstraction_no_input_type:
            .init(
                title: "Abstraction does not require an input type",
                summary: #"""
                Centralize repeated semantics without automatically adding an input
                carrier type that contributes no independent meaning.
                """#
            ) {
                paragraph(
                    #"""
                    A small helper may deserve centralization because the same semantic operation appears throughout several libraries. That reusable abstraction does not imply that its arguments must also become a carrier type.
                    """#
                )

                quote(
                    #"""
                    Centralize repeated meaning while keeping the public representation proportional to the operation.
                    """#
                )
            }

        case .parse_external_boundary:
            .init(
                title: "Parse external representations at the boundary",
                summary: #"""
                Parse loose external representations into stronger domain values at the
                boundary so inner operations receive domain meaning wherever practical.
                """#
            ) {
                paragraph(
                    #"""
                    External request vehicles often begin with loose representations that should not be carried unchanged through the semantic core.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "JSON fields",
                        "CLI strings",
                        "environment variables",
                        "database rows",
                        "HTTP fields",
                    ]
                )

                paragraph(
                    #"""
                    When those values have structural or semantic requirements, parse them into stronger domain values before carrying them deeper into the operation. The Parse, don't validate chapter governs how successful interpretation should become structural and when validation remains the actual requested operation.
                    """#
                )
            }
        }
    }
}
