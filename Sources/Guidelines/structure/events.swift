public enum EventGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
    case temporal_observation
    case not_presentation
    case optional_consumption

    public var content: GuidelineContent {
        switch self {
        case .temporal_observation:
            .init(
                title: "Use events for temporal execution observation",
                summary: #"""
                Events describe what happens during execution; they are temporal domain
                observations rather than authoritative final state.
                """#
            ) {
                paragraph(
                    #"""
                    Events describe what happens during execution.
                    """#
                )

                paragraph(
                    #"""
                    They answer:
                    """#
                )

                quote(
                    #"""
                    What happened during execution?
                    """#
                )

                paragraph(
                    #"""
                    They do not answer:
                    """#
                )

                quote(
                    #"""
                    What is the final authoritative semantic outcome?
                    """#
                )

                paragraph(
                    #"""
                    Examples:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    Build.Event
                        resolvingDependencies
                        compiling(target:)
                        linking(target:)
                        installing(destination:)
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    Sync.Event
                        inspecting
                        comparing
                        copying(path:)
                        deleting(path:)
                        runningPostSyncCommand
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    Concatenation.Event
                        scanning
                        fingerprinting
                        cacheHit(path:)
                        rendering(path:)
                    """#
                )
            }

        case .not_presentation:
            .init(
                title: "Event is not presentation",
                summary: #"""
                Keep events structured and domain-native so CLI, GUI, Agentic, logging,
                or other consumers can render or ignore the same observation
                independently.
                """#
            ) {
                paragraph(
                    #"""
                    An event may contain structured information:
                    """#
                )

                code(
                    language: "swift",
                    content: #"""
                    .copying(
                        source: ...,
                        destination: ...,
                        bytes: ...
                    )
                    """#
                )

                paragraph(
                    #"""
                    The CLI may render:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    copying  Package.swift
                    """#
                )

                paragraph(
                    #"""
                    A GUI may update a progress row.
                    """#
                )

                paragraph(
                    #"""
                    Agentic may retain it as a runtime event.
                    """#
                )

                paragraph(
                    #"""
                    Another library may ignore it.
                    """#
                )

                paragraph(
                    #"""
                    The event itself should remain domain information.
                    """#
                )
            }

        case .optional_consumption:
            .init(
                title: "Events are optional to consume",
                summary: #"""
                A caller should be able to ignore events without losing the
                authoritative result; do not require event reconstruction to discover
                final semantic state.
                """#
            ) {
                paragraph(
                    #"""
                    A caller should be able to ignore events without losing the actual result of the operation.
                    """#
                )

                paragraph(
                    #"""
                    Events provide temporal observation, not required semantic reconstruction.
                    """#
                )

                paragraph(
                    #"""
                    Avoid designs where callers must do this:
                    """#
                )

                code(
                    language: "swift",
                    content: #"""
                    var copied = []
                    
                    for event in events {
                        if case let .copied(path) = event {
                            copied.append(path)
                        }
                    }
                    """#
                )

                paragraph(
                    #"""
                    merely to determine the authoritative list of copied files.
                    """#
                )

                paragraph(
                    #"""
                    If copiedFiles is part of the meaningful outcome, it belongs in the result.
                    """#
                )

                paragraph(
                    #"""
                    Conceptually:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    Events
                        temporal observation
                    
                    Result
                        authoritative semantic outcome
                    """#
                )

                paragraph(
                    #"""
                    Events may overlap informationally with the final result. That duplication is legitimate because the two representations serve different temporal roles.
                    """#
                )
            }
        }
    }
}
