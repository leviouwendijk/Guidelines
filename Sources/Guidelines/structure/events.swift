public enum EventGuideline: String, Sendable, Hashable, CaseIterable {
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
                    Events answer what happened during execution. They expose temporal domain observations without replacing the result that answers what the operation ultimately produced.
                    """#
                )

                example("Keep event vocabulary temporal and domain-native") {
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

                quote(
                    #"""
                    Events describe the execution timeline; results carry authoritative final meaning.
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
                    An event should preserve the structured information that occurred, not the particular words, colors, rows, or interface state one consumer uses to present it.
                    """#
                )

                example("Separate an observation from its projections") {
                    code(
                        language: "swift",
                        content: #"""
                        .copying(
                            source: source,
                            destination: destination,
                            bytes: bytes
                        )
                        """#
                    )

                    code(
                        language: "text",
                        content: #"""
                        CLI
                            "copying Package.swift"

                        GUI
                            update progress row

                        Agentic
                            retain runtime event

                        library caller
                            ignore event
                        """#
                    )
                }

                paragraph(
                    #"""
                    The projections may differ freely because the event itself remains domain information.
                    """#
                )
            }

        case .optional_consumption:
            .init(
                title: "Events are optional to consume",
                summary: #"""
                A caller should be able to ignore events without losing the authoritative
                result; do not require event reconstruction to discover final semantic
                state.
                """#
            ) {
                paragraph(
                    #"""
                    Events provide temporal observation, not required semantic reconstruction. A caller that does not care about progress should still receive the complete authoritative result of the operation.
                    """#
                )

                example("Do not force callers to rebuild the result from events") {
                    code(
                        language: "swift",
                        content: #"""
                        // Avoid when copiedFiles is part of the final outcome.
                        var copied: [Path] = []

                        for event in events {
                            if case let .copied(path) = event {
                                copied.append(path)
                            }
                        }
                        """#
                    )

                    paragraph(
                        #"""
                        If `copiedFiles` is meaningful final state, return it in the result instead of requiring every caller to reconstruct it from the event stream.
                        """#
                    )
                }

                example("Allow temporal and final representations to overlap") {
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
                        Events and results may contain some of the same information. That duplication is legitimate when the two representations serve different temporal roles.
                        """#
                    )
                }
            }
        }
    }
}
