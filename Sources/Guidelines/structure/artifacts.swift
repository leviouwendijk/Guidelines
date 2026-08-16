public enum ArtifactGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
    case semantic_outcome_vs_material
    case domain_addressable
    case production_not_presentation

    public var content: GuidelineContent {
        switch self {
        case .semantic_outcome_vs_material:
            .init(
                title: "Separate semantic results from produced artifacts",
                summary: #"""
                Treat semantic outcome and produced material as related but distinct,
                and let results reference artifacts without forcing large material into
                every result.
                """#
            ) {
                paragraph(
                    #"""
                    Result and artifact are related but distinct concepts.
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    Result
                        semantic outcome
                    
                    Artifact
                        produced material
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
                    An artifact may be referenced by the result.
                    """#
                )

                paragraph(
                    #"""
                    This avoids bloating every result with large material while preserving the relationship between the operation and what it produced.
                    """#
                )
            }

        case .domain_addressable:
            .init(
                title: "Artifacts remain domain-addressable",
                summary: #"""
                Refer to produced material through stable domain information such as
                paths, URLs, identifiers, metadata, fingerprints, or artifact records.
                """#
            ) {
                paragraph(
                    #"""
                    Where practical, results should refer to produced material through stable domain information such as:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    path
                    URL
                    identifier
                    metadata
                    content fingerprint
                    artifact record
                    """#
                )

                paragraph(
                    #"""
                    rather than embedding interface-specific wrappers.
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
                    A generated executable, file, report, or compiled representation may itself be the meaningful product of domain execution.
                    """#
                )

                paragraph(
                    #"""
                    A presentation layer may then describe or expose that artifact.
                    """#
                )

                paragraph(
                    #"""
                    The fact that something is externally visible does not automatically make it presentation.
                    """#
                )
            }
        }
    }
}
