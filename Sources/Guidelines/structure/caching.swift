public enum CachingGuideline: String, Sendable, Hashable, CaseIterable {
    case beneath_execution
    case observable
    case semantic_equivalence
    case state_not_presentation

    public var content: GuidelineContent {
        switch self {
        case .beneath_execution:
            .init(
                title: "Keep caching beneath domain execution and resolution",
                summary: #"""
                Use caching as an implementation mechanism beneath resolution or execution
                rather than making presentation responsible for avoiding work.
                """#
            ) {
                paragraph(
                    #"""
                    Caching is primarily a mechanism for avoiding unnecessary work. Keep it beneath the domain operation or its resolution path rather than making a presenter decide whether the work should occur.
                    """#
                )

                example("Place cache decisions inside the semantic operation") {
                    code(
                        language: "text",
                        content: #"""
                        Input
                            ↓
                        Resolution
                            ↓
                        fingerprints / cache lookup
                            ↓
                        Plan
                            ↓
                        Execution
                        """#
                    )
                }

                paragraph(
                    #"""
                    The exact placement may vary with the domain, but cache mechanics should not normally redefine the operation's semantic contract.
                    """#
                )
            }

        case .observable:
            .init(
                title: "Cache observation",
                summary: #"""
                Expose useful cache activity through domain events or aggregate result facts
                without leaking the internal cache representation.
                """#
            ) {
                paragraph(
                    #"""
                    Cache behavior may be worth observing when it helps callers understand performance or work performed. Expose that information semantically without requiring consumers to know the cache's storage representation.
                    """#
                )

                example("Expose temporal cache activity as events") {
                    code(
                        language: "text",
                        content: #"""
                        .cacheHit(path)
                        .cacheMiss(path)
                        .recomputed(path)
                        """#
                    )
                }

                example("Expose useful aggregate facts in the result") {
                    code(
                        language: "text",
                        content: #"""
                        cacheHits: 137
                        recomputed: 3
                        """#
                    )
                }
            }

        case .semantic_equivalence:
            .init(
                title: "Cache behavior should preserve semantics",
                summary: #"""
                Warm and cold execution should produce equivalent domain semantics unless
                cache state is intentionally part of the domain contract.
                """#
            ) {
                paragraph(
                    #"""
                    A warm execution and a cold execution should generally produce equivalent domain meaning. Caching should improve computational footprint without incidentally changing the operation the caller asked for.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "behavior",
                        "configuration surface",
                        "output semantics",
                        "presentation contracts",
                    ]
                )

                paragraph(
                    #"""
                    If cache state is intentionally part of the domain contract, model that distinction explicitly rather than allowing it to leak accidentally from an implementation optimization.
                    """#
                )
            }

        case .state_not_presentation:
            .init(
                title: "Cache state is not presentation state",
                summary: #"""
                Let consumers choose whether to present cache information without making
                the cache mechanism depend on any presentation surface.
                """#
            ) {
                paragraph(
                    #"""
                    A terminal renderer, GUI, Agentic adapter, logger, or other consumer may choose to expose cache information. The cache mechanism itself should remain independent of those presentation decisions.
                    """#
                )
            }
        }
    }
}
