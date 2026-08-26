public enum CompactionPassGuideline: String, Sendable, Hashable, CaseIterable {
    case compact_after_stabilization

    public var content: GuidelineContent {
        switch self {
        case .compact_after_stabilization:
            .init(
                title: "Compact after implementation stabilizes",
                summary: #"""
                After a feature works, remove scaffolding, duplicate paths, speculative
                portability, and intermediates that carry no durable domain or boundary
                value.
                """#
            ) {
                paragraph(
                    #"""
                    Implementation often accumulates helpers, wrappers, extensions, compatibility shims, temporary aliases, alternate entry points, and small adapters while the problem is still being discovered. That is normal construction scaffolding, not evidence that every layer belongs in the finished design.
                    """#
                )

                quote(
                    #"""
                    After the feature works, compact the implementation back down to the smallest shape that still expresses the domain clearly.
                    """#
                )

                example("Collapse intermediates that carry no durable meaning") {
                    code(
                        language: "swift",
                        content: #"""
                        // Avoid when each layer merely restates the next.
                        extension Lead {
                            func emailAddressValue() throws -> EmailAddress {
                                try EmailAddress(email)
                            }
                        }

                        extension Lead {
                            func validatedEmail() throws -> EmailAddress {
                                try emailAddressValue()
                            }
                        }

                        extension LeadMailer {
                            func sendValidatedLeadEmail(
                                lead: Lead
                            ) async throws {
                                let email = try lead.validatedEmail()

                                try await sendLeadEmail(
                                    reply_to: email
                                )
                            }
                        }
                        """#
                    )

                    code(
                        language: "swift",
                        content: #"""
                        // Prefer the direct semantic path.
                        extension LeadMailer {
                            func send(
                                lead: Lead
                            ) async throws {
                                try await sendLeadEmail(
                                    reply_to: EmailAddress(lead.email)
                                )
                            }
                        }
                        """#
                    )

                    paragraph(
                        #"""
                        More named steps are not inherently more designed. An intermediate symbol should survive because it carries stable domain meaning, reuse, readability, compatibility, or boundary value.
                        """#
                    )
                }

                paragraph(
                    #"""
                    A compaction pass should ask:
                    """#
                )

                list(
                    style: .ordered,
                    items: [
                        "Did this extension survive because it is useful, or because it was convenient while building?",
                        "Does this helper name a real concept, or only restate the line inside it?",
                        "Does this wrapper improve the call site or ownership boundary, or merely move code sideways?",
                        "Is this indirection required by a real portability boundary, or is it speculative?",
                        "Can the same behavior be expressed with fewer public symbols without losing meaning?",
                    ]
                )

                example("Do not preserve speculative portability") {
                    code(
                        language: "swift",
                        content: #"""
                        // Avoid before a real second conformer or boundary exists.
                        protocol LeadEmailProviding {
                            var leadEmailValue: String? { get }
                        }

                        extension Lead: LeadEmailProviding {
                            var leadEmailValue: String? {
                                email
                            }
                        }

                        func email(
                            from provider: LeadEmailProviding
                        ) throws -> EmailAddress {
                            try EmailAddress(provider.leadEmailValue)
                        }

                        // Prefer while Lead is the actual domain input.
                        func email(
                            from lead: Lead
                        ) throws -> EmailAddress {
                            try EmailAddress(lead.email)
                        }
                        """#
                    )

                    paragraph(
                        #"""
                        The protocol earns its place once several real conforming types exist or the protocol itself is a meaningful boundary. Until then it widens the surface without reducing complexity.
                        """#
                    )
                }

                example("Keep compatibility deliberately when it is real") {
                    code(
                        language: "swift",
                        content: #"""
                        extension LeadMailer {
                            @available(*, deprecated, renamed: "send(lead:)")
                            func sendValidatedLeadEmail(
                                lead: Lead
                            ) async throws {
                                try await send(
                                    lead: lead
                                )
                            }
                        }
                        """#
                    )

                    paragraph(
                        #"""
                        Backward compatibility can justify retaining an otherwise redundant path. Keep it intentionally, make the migration path explicit, and distinguish compatibility scaffolding from the preferred API.
                        """#
                    )
                }

                paragraph(
                    #"""
                    Compaction is not rewriting for its own sake. It is the reduction step after growth: remove discovery scaffolding, collapse duplicate paths, delete speculative portability, and retain only structure with durable semantic or boundary value.
                    """#
                )
            }
        }
    }
}
