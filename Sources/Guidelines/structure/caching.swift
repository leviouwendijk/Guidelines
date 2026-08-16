public enum CachingGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
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
                Use caching as an implementation mechanism beneath resolution or
                execution rather than making presentation responsible for avoiding work.
                """#
            ) {
                paragraph(
                    #"""
                    Caching belongs beneath domain execution and resolution, not inside presentation.
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

                paragraph(
                    #"""
                    A cache is primarily an implementation mechanism for avoiding unnecessary work.
                    """#
                )

                paragraph(
                    #"""
                    It should not normally change the semantic contract of the operation.
                    """#
                )
            }

        case .observable:
            .init(
                title: "Cache observation",
                summary: #"""
                Expose useful cache activity through domain events or aggregate result
                facts without leaking the internal cache representation.
                """#
            ) {
                paragraph(
                    #"""
                    Cache activity may produce events:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    .cacheHit(path)
                    .cacheMiss(path)
                    .recomputed(path)
                    """#
                )

                paragraph(
                    #"""
                    The final result may expose useful aggregate facts:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    cacheHits: 137
                    recomputed: 3
                    """#
                )

                paragraph(
                    #"""
                    when those facts are useful to consumers.
                    """#
                )

                paragraph(
                    #"""
                    The caller should not need to understand the internal cache representation.
                    """#
                )
            }

        case .semantic_equivalence:
            .init(
                title: "Cache behavior should preserve semantics",
                summary: #"""
                Warm and cold execution should produce equivalent domain semantics
                unless cache state is intentionally part of the domain contract.
                """#
            ) {
                paragraph(
                    #"""
                    A warm execution and a cold execution should produce equivalent domain results unless the cache is itself intentionally part of the domain.
                    """#
                )

                paragraph(
                    #"""
                    Caching should improve computational footprint without unnecessarily changing:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    behavior
                    configuration surface
                    output semantics
                    presentation contracts
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
                    A terminal renderer, GUI, or Agentic adapter may choose to expose cache information.
                    """#
                )

                paragraph(
                    #"""
                    The cache mechanism itself should not depend on any of those presentation layers.
                    """#
                )
            }
        }
    }
}
