public enum ParseDontValidateGuideline: String, Sendable, Hashable, CaseIterable {
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
                summary: #"""
                When successful interpretation establishes an invariant, return a strong
                type that carries that guarantee instead of validating and returning the
                same loose value.
                """#
            ) {
                paragraph(
                    #"""
                    Prefer construction that changes the representation of successfully interpreted input. A standalone validation step is easy to forget, skip, duplicate, or separate from the value it supposedly proved valid.
                    """#
                )

                quote(
                    #"""
                    Be loose in what we accept, and stringent in what we return.
                    """#
                )

                paragraph(
                    #"""
                    When successful interpretation establishes an invariant, make that invariant travel with the returned value so downstream code does not need to remember which loose values happened to pass an earlier control-flow check.
                    """#
                )

                example("Make successful interpretation visible in the type") {
                    code(
                        language: "swift",
                        content: #"""
                        // Prefer when validity is the important semantic fact.
                        let identifier = try ProjectIdentifier(raw)

                        // Weaker when this still returns an indistinguishable String.
                        let identifier = try parseProjectIdentifier(raw)
                        """#
                    )
                }

                example("Construct a strong value at the boundary") {
                    code(
                        language: "swift",
                        content: #"""
                        // Avoid leaving the successfully checked value as String.
                        let rawEmail = payload.email

                        guard EmailValidator.isValid(rawEmail) else {
                            throw LeadError.invalidEmail
                        }

                        try sendLeadEmail(
                            reply_to: rawEmail
                        )

                        // Prefer structural success.
                        let email = try EmailAddress(payload.email)

                        try sendLeadEmail(
                            reply_to: email
                        )
                        """#
                    )

                    paragraph(
                        #"""
                        Either construction produces an `EmailAddress`, or it fails. There is no ambiguous middle state in which one `String` is supposedly validated but remains structurally identical to every other string.
                        """#
                    )
                }

                example("Let downstream APIs require the stronger value") {
                    code(
                        language: "swift",
                        content: #"""
                        func sendLeadEmail(
                            reply_to: EmailAddress
                        ) async throws {
                            try await mailer.send(
                                reply_to: reply_to.rawValue
                            )
                        }
                        """#
                    )
                }

                quote(
                    #"""
                    Validation asks whether a value is acceptable; parsing should change the shape of the successful value so the rest of the program cannot ignore that answer.
                    """#
                )
            }

        case .subordinate_helpers:
            .init(
                title: "Parsing helpers may exist beneath the strong boundary",
                summary: #"""
                Loose parsing helpers may exist internally, but they should remain
                subordinate to the strong public construction boundary.
                """#
            ) {
                paragraph(
                    #"""
                    Internal parsing machinery does not need to return the final public type at every intermediate step. Primitive helpers are reasonable when they remain implementation details beneath a stronger construction boundary.
                    """#
                )

                example("Keep loose helpers subordinate to construction") {
                    code(
                        language: "swift",
                        content: #"""
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
                        """#
                    )
                }

                example("Do not make the weaker helper the semantic API") {
                    code(
                        language: "swift",
                        content: #"""
                        // Weaker public boundary.
                        public func parseStringIdentifierValue(
                            _ value: String
                        ) throws -> String

                        // Stronger public boundary.
                        public init(
                            _ value: String
                        ) throws
                        """#
                    )

                    paragraph(
                        #"""
                        The helper is not wrong because it returns a primitive. The problem appears when that primitive escapes as the authoritative representation after the invariant has supposedly been established.
                        """#
                    )
                }
            }

        case .validation_as_operation:
            .init(
                title: "Validation is legitimate when validation is the operation",
                summary: #"""
                Validation is appropriate when inspection or reporting is itself the
                requested operation rather than a substitute for strong construction.
                """#
            ) {
                paragraph(
                    #"""
                    Some operations genuinely ask whether existing state satisfies a policy or what findings are present. In those cases validation is not a discarded construction step; validation is the domain operation.
                    """#
                )

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
                    #"""
                    The meaningful output may therefore be a validation report, diagnostics, or even a `Bool` when that is the complete question the caller asked.
                    """#
                )

                quote(
                    #"""
                    Do not use a disposable validation result where successful interpretation should instead be represented structurally.
                    """#
                )

                paragraph(
                    #"""
                    The distinction follows the requested operation: inspect existing state with validation; turn loose input into stronger domain meaning with parsing or construction.
                    """#
                )
            }

        case .normalization:
            .init(
                title: "Normalization may be part of parsing",
                summary: #"""
                Normalize during parsing only when discarded information is not meaningful
                to correctness, diagnostics, auditability, caller intent, or later
                processing.
                """#
            ) {
                paragraph(
                    #"""
                    Parsing does not require rejecting every non-canonical representation. A parser may normalize several representations into one value when the domain intentionally treats them as equivalent.
                    """#
                )

                example("Normalize genuine representational equivalence") {
                    code(
                        language: "text",
                        content: #"""
                        "   levi   " → "levi"
                        """#
                    )

                    paragraph(
                        #"""
                        This may be appropriate for an identifier when surrounding whitespace has no domain meaning.
                        """#
                    )
                }

                paragraph(
                    #"""
                    Normalization is information loss. Before discarding information, determine whether that information may matter to:
                    """#
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

                example("Do not confuse invalid intent with another spelling") {
                    code(
                        language: "text",
                        content: #"""
                        -15 → 0
                        """#
                    )

                    paragraph(
                        #"""
                        A negative context count may represent invalid caller intent rather than a harmless alternate representation of zero.
                        """#
                    )
                }

                quote(
                    #"""
                    Normalize only when the discarded distinction is intentionally meaningless in this domain.
                    """#
                )
            }

        case .preserve_raw_input:
            .init(
                title: "Preserve raw input when the domain needs it",
                summary: #"""
                Preserve raw input when the domain has a concrete need for both original
                and normalized representations; do not retain or discard it mechanically.
                """#
            ) {
                paragraph(
                    #"""
                    Sometimes downstream logic needs the normalized value while diagnostics, auditability, recovery, or another domain concern still needs the original representation.
                    """#
                )

                example("Model both representations when both have consumers") {
                    code(
                        language: "swift",
                        content: #"""
                        struct ParsedValue {
                            let raw: String
                            let normalized: String
                        }
                        """#
                    )

                    paragraph(
                        #"""
                        The original may instead live in diagnostics, source information, audit records, or another domain-appropriate representation; it does not have to be stored beside the normalized value.
                        """#
                    )
                }

                list(
                    style: .unordered,
                    items: [
                        "Do not preserve raw input merely because it existed.",
                        "Do not discard raw input merely because normalized meaning is available.",
                        "Keep both forms only when the original has a concrete semantic or operational consumer.",
                        "Discard the original only when doing so cannot destroy information the domain may reasonably need.",
                    ]
                )
            }
        }
    }
}
