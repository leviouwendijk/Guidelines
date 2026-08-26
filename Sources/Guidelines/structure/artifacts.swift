public enum ArtifactGuideline: String, Sendable, Hashable, CaseIterable {
    case semantic_outcome_vs_material
    case domain_addressable
    case production_not_presentation

    public var content: GuidelineContent {
        switch self {
        case .semantic_outcome_vs_material:
            .init(
                title: "Separate semantic results from produced artifacts",
                summary: #"""
                Treat semantic outcome and produced material as related but distinct, and
                let results reference artifacts without forcing large material into every
                result.
                """#
            ) {
                paragraph(
                    #"""
                    Results and artifacts describe different aspects of an operation. The result carries the semantic outcome; an artifact is material the operation produced.
                    """#
                )

                example("Keep outcome and material distinct") {
                    code(
                        language: "text",
                        content: #"""
                        Result
                            compilation succeeded with 4 warnings

                        Artifacts
                            compiled .ec output
                            generated report
                            PDF
                            executable
                            concatenated document
                            diff
                        """#
                    )

                    paragraph(
                        #"""
                        A result may reference one or more artifacts without embedding all produced material directly. This preserves the relationship between what happened and what was produced without bloating every result representation.
                        """#
                    )
                }
            }

        case .domain_addressable:
            .init(
                title: "Artifacts remain domain-addressable",
                summary: #"""
                Refer to produced material through stable domain information such as paths,
                URLs, identifiers, metadata, fingerprints, or artifact records.
                """#
            ) {
                paragraph(
                    #"""
                    Where practical, results should refer to produced material through stable domain information rather than through interface-specific wrappers.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "path",
                        "URL",
                        "identifier",
                        "metadata",
                        "content fingerprint",
                        "artifact record",
                    ]
                )

                paragraph(
                    #"""
                    Choose the reference shape according to the artifact's domain identity and lifecycle rather than according to whichever presenter first exposes it.
                    """#
                )
            }

        case .production_not_presentation:
            .init(
                title: "Artifact production is not presentation by definition",
                summary: #"""
                Do not classify produced material as presentation merely because it is
                externally visible; an artifact may itself be the meaningful domain
                product.
                """#
            ) {
                paragraph(
                    #"""
                    A generated executable, file, report, compiled representation, or other material may itself be the meaningful product of domain execution. External visibility does not make that production step presentation.
                    """#
                )

                example("Present an artifact without redefining its production") {
                    code(
                        language: "text",
                        content: #"""
                        domain execution
                            ↓
                        produced artifact
                            ↓
                        terminal / GUI / HTTP / Agentic exposure
                        """#
                    )

                    paragraph(
                        #"""
                        The outer surface may describe, link to, download, render, or otherwise expose the artifact while the artifact remains a domain product.
                        """#
                    )
                }
            }
        }
    }
}
