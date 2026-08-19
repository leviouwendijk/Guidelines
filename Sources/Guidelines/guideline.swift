public enum Guideline:
    Sendable,
    Hashable,
    GuidelineReferencing
{
    case casing(
        CasingGuideline
    )

    case identifiers(
        IdentifierGuideline
    )

    case snake_or_camel(
        SnakeOrCamelGuideline
    )

    case dsl_design(
        DSLDesignGuideline
    )

    case nested_api_designs(
        NestedAPIDesignGuideline
    )

    case option_clustering(
        OptionClusteringGuideline
    )

    case source_organization(
        SourceOrganizationGuideline
    )

    case web_interface_interactions(
        WebInterfaceInteractionGuideline
    )

    case mutation_execution_workflows(
        MutationExecutionWorkflowGuideline
    )

    case artifacts(
        ArtifactGuideline
    )

    case boundary_adaptation(
        BoundaryAdaptationGuideline
    )

    case caching(
        CachingGuideline
    )

    case compaction_passes(
        CompactionPassGuideline
    )

    case events(
        EventGuideline
    )

    case execution(
        ExecutionGuideline
    )

    case failures_and_outcomes(
        FailureAndOutcomeGuideline
    )

    case input(
        InputGuideline
    )

    case operation_abstractions(
        OperationAbstractionGuideline
    )

    case operational_architecture(
        OperationalArchitectureGuideline
    )

    case operational_model(
        OperationalModelGuideline
    )

    case parse_dont_validate(
        ParseDontValidateGuideline
    )

    case planning(
        PlanningGuideline
    )

    case preflight(
        PreflightGuideline
    )

    case presentation_and_adaptation(
        PresentationAndAdaptationGuideline
    )

    case recursive_composition(
        RecursiveCompositionGuideline
    )

    case resolution(
        ResolutionGuideline
    )

    case results(
        ResultGuideline
    )

    public var content: GuidelineContent {
        switch self {
        case .casing(let guideline):
            guideline.content

        case .identifiers(let guideline):
            guideline.content

        case .snake_or_camel(let guideline):
            guideline.content

        case .dsl_design(let guideline):
            guideline.content

        case .nested_api_designs(let guideline):
            guideline.content

        case .option_clustering(let guideline):
            guideline.content

        case .source_organization(let guideline):
            guideline.content

        case .web_interface_interactions(let guideline):
            guideline.content

        case .mutation_execution_workflows(let guideline):
            guideline.content

        case .artifacts(let guideline):
            guideline.content

        case .boundary_adaptation(let guideline):
            guideline.content

        case .caching(let guideline):
            guideline.content

        case .compaction_passes(let guideline):
            guideline.content

        case .events(let guideline):
            guideline.content

        case .execution(let guideline):
            guideline.content

        case .failures_and_outcomes(let guideline):
            guideline.content

        case .input(let guideline):
            guideline.content

        case .operation_abstractions(let guideline):
            guideline.content

        case .operational_architecture(let guideline):
            guideline.content

        case .operational_model(let guideline):
            guideline.content

        case .parse_dont_validate(let guideline):
            guideline.content

        case .planning(let guideline):
            guideline.content

        case .preflight(let guideline):
            guideline.content

        case .presentation_and_adaptation(let guideline):
            guideline.content

        case .recursive_composition(let guideline):
            guideline.content

        case .resolution(let guideline):
            guideline.content

        case .results(let guideline):
            guideline.content
        }
    }

    public var title: String {
        content.title
    }

    public var summary: String {
        content.summary
    }

    public var explanation: [GuidelineContent.Block] {
        content.explanation
    }

    public var area: GuidelineArea {
        switch self {
        case .casing:
            .design

        case .identifiers:
            .design

        case .snake_or_camel:
            .design

        case .dsl_design:
            .ergonomics

        case .nested_api_designs:
            .ergonomics

        case .option_clustering:
            .ergonomics

        case .source_organization:
            .ergonomics

        case .web_interface_interactions:
            .ai

        case .mutation_execution_workflows:
            .ai

        case .artifacts:
            .structure

        case .boundary_adaptation:
            .structure

        case .caching:
            .structure

        case .compaction_passes:
            .structure

        case .events:
            .structure

        case .execution:
            .structure

        case .failures_and_outcomes:
            .structure

        case .input:
            .structure

        case .operation_abstractions:
            .structure

        case .operational_architecture:
            .structure

        case .operational_model:
            .structure

        case .parse_dont_validate:
            .structure

        case .planning:
            .structure

        case .preflight:
            .structure

        case .presentation_and_adaptation:
            .structure

        case .recursive_composition:
            .structure

        case .resolution:
            .structure

        case .results:
            .structure
        }
    }

    public var reference: String {
        switch self {
        case .casing(let guideline):
            "design.casing.\(guideline.rawValue)"

        case .identifiers(let guideline):
            "design.identifiers.\(guideline.rawValue)"

        case .snake_or_camel(let guideline):
            "design.snake_or_camel.\(guideline.rawValue)"

        case .dsl_design(let guideline):
            "ergonomics.dsl_design.\(guideline.rawValue)"

        case .nested_api_designs(let guideline):
            "ergonomics.nested_api_designs.\(guideline.rawValue)"

        case .option_clustering(let guideline):
            "ergonomics.option_clustering.\(guideline.rawValue)"

        case .source_organization(let guideline):
            "ergonomics.source_organization.\(guideline.rawValue)"

        case .web_interface_interactions(let guideline):
            "ai.web_interface_interactions.\(guideline.rawValue)"

        case .mutation_execution_workflows(let guideline):
            "ai.mutation_execution_workflows.\(guideline.rawValue)"

        case .artifacts(let guideline):
            "structure.artifacts.\(guideline.rawValue)"

        case .boundary_adaptation(let guideline):
            "structure.boundary_adaptation.\(guideline.rawValue)"

        case .caching(let guideline):
            "structure.caching.\(guideline.rawValue)"

        case .compaction_passes(let guideline):
            "structure.compaction_passes.\(guideline.rawValue)"

        case .events(let guideline):
            "structure.events.\(guideline.rawValue)"

        case .execution(let guideline):
            "structure.execution.\(guideline.rawValue)"

        case .failures_and_outcomes(let guideline):
            "structure.failures_and_outcomes.\(guideline.rawValue)"

        case .input(let guideline):
            "structure.input.\(guideline.rawValue)"

        case .operation_abstractions(let guideline):
            "structure.operation_abstractions.\(guideline.rawValue)"

        case .operational_architecture(let guideline):
            "structure.operational_architecture.\(guideline.rawValue)"

        case .operational_model(let guideline):
            "structure.operational_model.\(guideline.rawValue)"

        case .parse_dont_validate(let guideline):
            "structure.parse_dont_validate.\(guideline.rawValue)"

        case .planning(let guideline):
            "structure.planning.\(guideline.rawValue)"

        case .preflight(let guideline):
            "structure.preflight.\(guideline.rawValue)"

        case .presentation_and_adaptation(let guideline):
            "structure.presentation_and_adaptation.\(guideline.rawValue)"

        case .recursive_composition(let guideline):
            "structure.recursive_composition.\(guideline.rawValue)"

        case .resolution(let guideline):
            "structure.resolution.\(guideline.rawValue)"

        case .results(let guideline):
            "structure.results.\(guideline.rawValue)"
        }
    }

    public static var all: [Self] {
        GuidelineManual.chapters.flatMap(\.guidelines)
    }
}
