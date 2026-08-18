public enum InputGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
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
                    Input expresses what the caller wants in domain terms.
                    """#
                )

                paragraph(
                    #"""
                    It should not encode the accidental syntax of the interface that supplied the request.
                    """#
                )

                paragraph(
                    #"""
                    Avoid making the real operation consume:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    ["--recursive", "--force", "./foo"]
                    """#
                )

                paragraph(
                    #"""
                    when the actual domain request can be represented as:
                    """#
                )

                code(
                    language: "swift",
                    content: #"""
                    ConcatenationRequest
                    SyncRequest
                    BuildRequest
                    CompilationRequest
                    """#
                )

                paragraph(
                    #"""
                    The interface performs the adaptation:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    CLI arguments ─────┐
                    Agentic JSON ──────┤
                    GUI state ─────────┼──> domain input
                    HTTP payload ──────┤
                    Swift caller ──────┘
                    """#
                )

                paragraph(
                    #"""
                    This is one of the primary portability boundaries.
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
                    Do not manufacture an input wrapper merely to conform to the architecture.
                    """#
                )

                paragraph(
                    #"""
                    This is already a good input surface:
                    """#
                )

                code(
                    language: "swift",
                    content: #"""
                    fingerprint(of: data)
                    """#
                )

                paragraph(
                    #"""
                    Likewise:
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
                    already expresses a small operation clearly.
                    """#
                )

                paragraph(
                    #"""
                    Wrapping those values in:
                    """#
                )

                code(
                    language: "swift",
                    content: #"""
                    FingerprintInput
                    DecimalComparisonInput
                    """#
                )

                paragraph(
                    #"""
                    would only be useful if the grouped value itself acquired meaning beyond the immediate function call.
                    """#
                )
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
                    A dedicated input type becomes more useful when the requested intent:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    contains several related values
                    is passed through multiple stages
                    is stored or transported
                    needs invariants
                    is reused by several callers
                    is inspected before execution
                    has meaningful defaults or policy
                    benefits substantially from a named cohesive representation
                    """#
                )

                paragraph(
                    #"""
                    The number of parameters alone is not the rule.
                    """#
                )

                paragraph(
                    #"""
                    The question is whether the request has become a meaningful value of its own.
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
                    A small helper may deserve centralization because the same semantic operation occurs throughout several libraries.
                    """#
                )

                paragraph(
                    #"""
                    That does not mean its arguments must become a carrier type.
                    """#
                )

                paragraph(
                    #"""
                    Prefer centralizing repeated meaning while keeping the public representation proportional to the operation.
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
                    External representations may begin loose.
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
                    JSON
                    CLI strings
                    environment variables
                    database rows
                    HTTP fields
                    """#
                )

                paragraph(
                    #"""
                    When those values have structural or semantic requirements, parse them into stronger domain types before carrying them deeper into the operation.
                    """#
                )

                paragraph(
                    #"""
                    See ParseDontValidateGuideline.
                    """#
                )

                paragraph(
                    #"""
                    The inner operation should receive domain meaning wherever practical, rather than repeatedly reinterpreting raw interface values.
                    """#
                )
            }
        }
    }
}
