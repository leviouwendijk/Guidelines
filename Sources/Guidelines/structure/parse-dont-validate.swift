public enum ParseDontValidateGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
    case strong_result
    case subordinate_helpers
    case validation_as_operation
    case normalization
    case preserve_raw_input

    public var content: GuidelineContent {
        switch self {
        case .strong_result:
            .init(
                title: "Successful parsing should become structural",
                summary: """
                When successful interpretation establishes an invariant,
                return a strong type that carries that guarantee instead
                of validating and returning the same loose value.
                """
            ) {
                paragraph(
                    """
                    Generally prefer using the initializer of a type
                    instead of a loose validation pass that throws its
                    result away.
                    """
                )

                paragraph(
                    """
                    There are two primary reasons.
                    """
                )

                paragraph(
                    """
                    First, separate validation guards are control-flow
                    steps. They may be misimplemented, forgotten,
                    skipped, or become difficult to reason about when
                    mutation and branching are involved. A strong type
                    whose initializer establishes its own requirements
                    cannot accidentally represent an invalid value after
                    successful construction.
                    """
                )

                paragraph(
                    """
                    Second, standalone validation often produces a weak
                    result such as a `Bool`, or simply returns another
                    instance of the same loose type. The caller is then
                    expected to remember that the otherwise
                    indistinguishable value has supposedly been
                    validated.
                    """
                )

                paragraph(
                    """
                    Where useful, parsing may accept a looser payload and
                    construct a stronger throwing type from it.
                    """
                )

                quote(
                    "Be loose in what we accept, and stringent in what we return."
                )

                paragraph(
                    """
                    When successful interpretation establishes an
                    invariant, prefer making that invariant structural
                    in the value returned to the rest of the program.
                    """
                )

                example("Strong construction") {
                    paragraph("Prefer:")

                    code(
                        language: "swift",
                        content: """
                        let identifier = try ProjectIdentifier(raw)
                        """
                    )

                    paragraph("over:")

                    code(
                        language: "swift",
                        content: """
                        let identifier = try parseProjectIdentifier(raw)
                        """
                    )

                    paragraph(
                        """
                        when the important semantic fact is that the value
                        is now a valid `ProjectIdentifier`.
                        """
                    )
                }

                paragraph(
                    """
                    A throwing initializer is especially useful because
                    successful construction itself establishes the
                    guarantee.
                    """
                )

                paragraph(
                    """
                    Code receiving a `ProjectIdentifier` does not need to
                    remember whether some earlier branch happened to
                    validate a `String`.
                    """
                )

                paragraph(
                    """
                    The invariant travels with the type.
                    """
                )

                paragraph(
                    """
                    The same principle applies to other domain values.
                    """
                )

                example("Email construction") {
                    paragraph("Not:")

                    code(
                        language: "swift",
                        content: """
                        let rawEmail = payload.email

                        guard EmailValidator.isValid(rawEmail) else {
                            throw LeadError.invalidEmail
                        }

                        try sendLeadEmail(
                            reply_to: rawEmail
                        )
                        """
                    )

                    paragraph("Prefer:")

                    code(
                        language: "swift",
                        content: """
                        let email = try EmailAddress(payload.email)

                        try sendLeadEmail(
                            reply_to: email.rawValue
                        )
                        """
                    )

                    paragraph(
                        """
                        The preferred version makes the boundary explicit.
                        Either the value becomes an `EmailAddress`, or
                        construction fails. There is no ambiguous middle
                        state where a `String` has supposedly been validated
                        but still looks exactly like every other string.
                        """
                    )
                }

                paragraph(
                    """
                    This improves downstream APIs as well.
                    """
                )

                example("Strong downstream API") {
                    paragraph("Not:")

                    code(
                        language: "swift",
                        content: """
                        func sendLeadEmail(
                            reply_to: String
                        ) async throws {
                            guard EmailValidator.isValid(reply_to) else {
                                throw LeadError.invalidEmail
                            }

                            try await mailer.send(
                                reply_to: reply_to
                            )
                        }
                        """
                    )

                    paragraph("Prefer:")

                    code(
                        language: "swift",
                        content: """
                        func sendLeadEmail(
                            reply_to: EmailAddress
                        ) async throws {
                            try await mailer.send(
                                reply_to: reply_to.rawValue
                            )
                        }
                        """
                    )
                }

                paragraph(
                    """
                    Validation asks whether a value is acceptable.
                    """
                )

                paragraph(
                    """
                    Parsing changes the shape of the value so the rest of
                    the program cannot ignore that answer.
                    """
                )
            }

        case .subordinate_helpers:
            .init(
                title: "Parsing helpers may exist beneath the strong boundary",
                summary: """
                Loose parsing helpers may exist internally, but they should
                remain subordinate to the strong public construction
                boundary.
                """
            ) {
                paragraph(
                    """
                    Internal parsing machinery does not itself need to
                    return the final public type at every intermediate
                    step.
                    """
                )

                example {
                    code(
                        language: "swift",
                        content: """
                        private func parsedIdentifierValue(
                            _ rawValue: String
                        ) throws -> String {
                            ...
                        }

                        public struct ProjectIdentifier {
                            public let rawValue: String

                            public init(
                                _ rawValue: String
                            ) throws {
                                self.rawValue = try parsedIdentifierValue(
                                    rawValue
                                )
                            }
                        }
                        """
                    )

                    paragraph(
                        """
                        This can be reasonable implementation machinery.
                        """
                    )
                }

                paragraph(
                    """
                    The important distinction is that the loose helper is
                    subordinate to the strong construction boundary.
                    """
                )

                paragraph(
                    """
                    Avoid making a same-type parsing helper the preferred
                    public semantic API when a stronger domain type can
                    represent the successful result.
                    """
                )

                example("Public boundary") {
                    paragraph("This:")

                    code(
                        language: "swift",
                        content: """
                        public func parseStringIdentifierValue(
                            _ value: String
                        ) throws -> String
                        """
                    )

                    paragraph(
                        """
                        is weaker as a public semantic boundary than:
                        """
                    )

                    code(
                        language: "swift",
                        content: """
                        public init(
                            _ value: String
                        ) throws
                        """
                    )

                    paragraph(
                        """
                        on the identifier type itself.
                        """
                    )
                }

                paragraph(
                    """
                    The helper is not wrong merely because it returns a
                    primitive. What matters is whether that primitive
                    escapes as the authoritative representation after the
                    invariant has supposedly been established.
                    """
                )
            }

        case .validation_as_operation:
            .init(
                title: "Validation is legitimate when validation is the operation",
                summary: """
                Validation is appropriate when inspection or reporting is
                itself the requested operation rather than a substitute for
                strong construction.
                """
            ) {
                paragraph(
                    """
                    Some validation mechanisms should intentionally remain
                    validators rather than being transformed into throwing
                    construction APIs.
                    """
                )

                paragraph(
                    """
                    Validation is especially legitimate when validation
                    itself is the requested operation.
                    """
                )

                paragraph("Examples include:")

                list(
                    style: .unordered,
                    items: [
                        "configuration inspection",
                        "preflight",
                        "schema diagnostics",
                        "policy checking",
                        "consistency reports",
                        "linting",
                        "audit reports",
                    ]
                )

                paragraph(
                    """
                    In those cases the meaningful output may genuinely be a
                    `ValidationReport`, diagnostics, or a `Bool`, because
                    the caller asked to inspect an existing value rather
                    than convert loose input into a stronger value.
                    """
                )

                paragraph("The principle is not:")

                quote("Never validate.")

                paragraph("It is:")

                quote(
                    """
                    Do not use a disposable validation result where
                    successful interpretation should instead be represented
                    structurally.
                    """
                )

                paragraph(
                    """
                    The distinction follows the requested operation.
                    """
                )

                paragraph(
                    """
                    If the caller wants to know whether existing state
                    satisfies a policy, validation may be exactly the right
                    semantic operation.
                    """
                )

                paragraph(
                    """
                    If the caller is interpreting loose input into a domain
                    value, successful interpretation should normally become
                    part of the returned representation.
                    """
                )
            }

        case .normalization:
            .init(
                title: "Normalization may be part of parsing",
                summary: """
                Normalize during parsing only when discarded information is
                not meaningful to correctness, diagnostics, auditability,
                caller intent, or later processing.
                """
            ) {
                paragraph(
                    """
                    Parsing does not mean every non-canonical representation
                    must be rejected.
                    """
                )

                paragraph(
                    """
                    A parser may normalize inputs where the domain
                    intentionally treats several representations as the
                    same value.
                    """
                )

                example {
                    code(
                        language: "text",
                        content: """
                        "   levi   "
                            -> "levi"
                        """
                    )

                    paragraph(
                        """
                        This may be completely appropriate for an identifier
                        if surrounding whitespace has no meaning in the
                        intended domain.
                        """
                    )
                }

                paragraph(
                    """
                    Normalization is an information-losing transformation,
                    however.
                    """
                )

                paragraph(
                    """
                    Before silently normalizing, ask:
                    """
                )

                quote(
                    """
                    Does the information being discarded have any meaning
                    we may reasonably need?
                    """
                )

                paragraph(
                    """
                    Relevant reasons to retain, reject, or separately record
                    the original value may include:
                    """
                )

                list(
                    style: .unordered,
                    items: [
                        "correctness",
                        "diagnostics",
                        "auditability",
                        "caller feedback",
                        "recovery",
                        "future processing",
                        "domain meaning",
                    ]
                )

                paragraph(
                    """
                    These transformations are not automatically equivalent.
                    """
                )

                example("Lossless domain equivalence") {
                    code(
                        language: "text",
                        content: """
                        "   levi   " -> "levi"
                        """
                    )
                }

                example("Potentially invalid caller intent") {
                    code(
                        language: "text",
                        content: """
                        -15 -> 0
                        """
                    )

                    paragraph(
                        """
                        A negative context count may represent invalid caller
                        intent rather than merely another spelling of zero.
                        """
                    )
                }

                paragraph(
                    """
                    Whether a value should be rejected, normalized, or
                    retained depends on the semantics and consumers of that
                    particular system.
                    """
                )

                paragraph(
                    """
                    Normalization should therefore be a domain decision, not
                    a generic instinct to make unusual input convenient.
                    """
                )
            }

        case .preserve_raw_input:
            .init(
                title: "Preserve raw input when the domain needs it",
                summary: """
                Preserve raw input when the domain has a concrete need for
                both original and normalized representations; do not retain
                or discard it mechanically.
                """
            ) {
                paragraph(
                    """
                    Sometimes the normalized value is what downstream code
                    needs while the original representation remains useful.
                    """
                )

                paragraph(
                    """
                    In those cases it may be appropriate to model both:
                    """
                )

                example {
                    code(
                        language: "swift",
                        content: """
                        struct ParsedValue {
                            let raw: String
                            let normalized: String
                        }
                        """
                    )
                }

                paragraph(
                    """
                    The original may instead be retained through diagnostics,
                    source information, audit records, or another
                    domain-appropriate representation.
                    """
                )

                paragraph(
                    """
                    Do not preserve raw input mechanically.
                    """
                )

                paragraph(
                    """
                    Do not discard it mechanically either.
                    """
                )

                paragraph(
                    """
                    The decision follows the information needs of the domain.
                    """
                )

                paragraph(
                    """
                    Keeping both forms earns its representation when the
                    original value has an actual consumer or semantic
                    purpose. Otherwise it is merely additional state.
                    """
                )

                paragraph(
                    """
                    Likewise, discarding the original is appropriate only
                    when doing so does not destroy information the domain may
                    reasonably need.
                    """
                )
            }
        }
    }
}
