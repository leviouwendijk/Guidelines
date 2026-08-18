public enum PreflightGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
    case separate_plan_and_preflight
    case domain_information
    case no_secret_execution

    public var content: GuidelineContent {
        switch self {
        case .separate_plan_and_preflight:
            .init(
                title: "Distinguish planned work from preflight analysis",
                summary: #"""
                Treat a plan as the executable description of intended work and
                preflight as analysis of whether and how that work may proceed,
                combining them only when one type genuinely serves both roles.
                """#
            ) {
                paragraph(
                    #"""
                    Plan and preflight are related but not identical concepts.
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    Plan
                        executable description of what will happen
                    
                    Preflight
                        analysis of whether and how that work may proceed
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
                    Plan
                        copy A
                        replace B
                        remove C
                    """#
                )

                paragraph(
                    #"""
                    may produce:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    Preflight
                        3 paths affected
                        28 MB copied
                        destination writable
                        warning: B changed since the cache snapshot
                    """#
                )

                paragraph(
                    #"""
                    Sometimes one type can serve both purposes.
                    """#
                )

                paragraph(
                    #"""
                    Sometimes the cleaner shape is:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    Plan -> PreflightReport
                    """#
                )
            }

        case .domain_information:
            .init(
                title: "Preflight is domain information",
                summary: #"""
                Keep preflight reports domain-native so outer adapters can present the
                same findings through terminal, Agentic, GUI, HTTP, or other surfaces.
                """#
            ) {
                paragraph(
                    #"""
                    Preflight should not itself become presentation.
                    """#
                )

                paragraph(
                    #"""
                    A domain library may expose:
                    """#
                )

                code(
                    language: "swift",
                    content: #"""
                    Sync.Plan
                    Sync.PreflightReport
                    """#
                )

                paragraph(
                    #"""
                    and an outer adapter may turn the report into:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    terminal confirmation
                    Agentic approval
                    GUI warning
                    HTTP response
                    """#
                )

                paragraph(
                    #"""
                    The domain stays domain-native.
                    """#
                )
            }

        case .no_secret_execution:
            .init(
                title: "Preflight should not secretly execute",
                summary: #"""
                Allow preflight to inspect state required for safety or feasibility, but
                do not hide the domain mutation it claims only to analyze.
                """#
            ) {
                paragraph(
                    #"""
                    A preflight may inspect state when inspection is required to determine safety or feasibility.
                    """#
                )

                paragraph(
                    #"""
                    It should not silently perform the domain mutation it claims only to describe.
                    """#
                )

                paragraph(
                    #"""
                    If inspection itself has meaningful effects, those effects should be modeled deliberately rather than hidden under the word preflight.
                    """#
                )
            }
        }
    }
}
