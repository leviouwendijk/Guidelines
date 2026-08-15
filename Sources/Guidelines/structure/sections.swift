public enum StructureGuidelineSection:
    String,
    Sendable,
    Hashable,
    CaseIterable,
    GuidelineSection
{
    case operational_architecture
    case operational_model
    case input
    case resolution
    case planning
    case preflight
    case execution
    case events
    case results
    case artifacts
    case presentation_and_adaptation
    case recursive_composition
    case operation_abstractions
    case boundary_adaptation
    case failures_and_outcomes
    case caching
    case parse_dont_validate
    case compaction_passes
    case principles

    public var area: GuidelineArea {
        .structure
    }
}
