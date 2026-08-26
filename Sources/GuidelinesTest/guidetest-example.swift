import Foundation
import Guidelines

// guidelines-reference.swift
//
// Scope: entire file
//
// Standalone Guidelines reference fixture.
//
// This is intentionally one file so it can be compiled and exercised as a
// self-contained specimen. In production, the same subsystem should be split
// into focused, purpose-named source files.
//
// The operation is intentionally multi-step and mutating, so resolution,
// planning, preflight, events, result, artifact, projection, and presentation
// each preserve independent meaning. Simpler operations should collapse roles.

enum Build {
    struct TargetName: Hashable, Sendable {
        let value: String

        init(
            _ value: String
        ) throws {
            guard !value.isEmpty else {
                throw Failure.emptyTargetName
            }

            self.value = value
        }
    }

    struct SourceIdentifier:
        Hashable,
        Sendable
    {
        let value: String
    }

    struct SourceRevision:
        Equatable,
        Sendable
    {
        let value: Int
    }

    enum Configuration:
        String,
        Sendable
    {
        case debug
        case release
    }

    struct ArtifactIdentifier:
        Hashable,
        Sendable
    {
        let value: String

        init(
            sourceIdentifier: SourceIdentifier,
            configuration: Configuration
        ) {
            self.value =
                sourceIdentifier.value
                + "."
                + configuration.rawValue
        }
    }

    struct Input:
        Sendable
    {
        let target: TargetName
        let configuration: Configuration
    }

    struct ResolvedSource:
        Sendable
    {
        let sourceIdentifier: SourceIdentifier
        let revision: SourceRevision
        let source: String
    }

    struct ResolvedInput:
        Sendable
    {
        let sourceIdentifier: SourceIdentifier
        let revision: SourceRevision
        let source: String
        let configuration: Configuration
    }

    struct Plan:
        Sendable
    {
        let resolvedInput: ResolvedInput
        let artifactIdentifier: ArtifactIdentifier
    }

    struct Preflight:
        Sendable
    {
        let plan: Plan
        let sourceRevisionAtInspection: SourceRevision
    }

    struct Artifact:
        Sendable
    {
        let artifactIdentifier: ArtifactIdentifier
        let body: String
    }

    enum Event:
        Equatable,
        Sendable
    {
        case started(SourceIdentifier)
        case wroteArtifact(ArtifactIdentifier)
        case finished(ArtifactIdentifier)
    }

    struct Result:
        Equatable,
        Sendable
    {
        let artifactIdentifier: ArtifactIdentifier
        let sourceIdentifier: SourceIdentifier
        let sourceRevision: SourceRevision
        let byteCount: Int
    }

    enum Failure:
        Error,
        Equatable,
        Sendable
    {
        case emptyTargetName
        case unknownTarget(TargetName)
        case unknownSource(SourceIdentifier)
        case sourceDrift(
            expected: SourceRevision,
            actual: SourceRevision
        )
    }

    protocol SourceResolving: Sendable {
        func resolve(
            _ target: TargetName
        ) async throws -> ResolvedSource

        func revision(
            of sourceIdentifier: SourceIdentifier
        ) async throws -> SourceRevision
    }

    protocol ArtifactWriting: Sendable {
        func write(
            _ artifact: Artifact
        ) async throws
    }

    protocol EventObserving: Sendable {
        func observe(
            _ event: Event
        ) async
    }

    struct Operation<
        Resolver: SourceResolving,
        Writer: ArtifactWriting,
        Observer: EventObserving
    >:
        Sendable
    {
        let resolver: Resolver
        let writer: Writer
        let observer: Observer

        func resolve(
            _ input: Input
        ) async throws -> ResolvedInput {
            let source = try await resolver.resolve(
                input.target
            )

            return ResolvedInput(
                sourceIdentifier: source.sourceIdentifier,
                revision: source.revision,
                source: source.source,
                configuration: input.configuration
            )
        }

        func plan(
            _ input: ResolvedInput
        ) -> Plan {
            Plan(
                resolvedInput: input,
                artifactIdentifier: ArtifactIdentifier(
                    sourceIdentifier: input.sourceIdentifier,
                    configuration: input.configuration
                )
            )
        }

        func preflight(
            _ plan: Plan
        ) async throws -> Preflight {
            let actualRevision = try await resolver.revision(
                of: plan.resolvedInput.sourceIdentifier
            )

            guard actualRevision == plan.resolvedInput.revision else {
                throw Failure.sourceDrift(
                    expected: plan.resolvedInput.revision,
                    actual: actualRevision
                )
            }

            return Preflight(
                plan: plan,
                sourceRevisionAtInspection: actualRevision
            )
        }

        func execute(
            _ preflight: Preflight
        ) async throws -> Result {
            let plan = preflight.plan
            let sourceIdentifier = plan.resolvedInput.sourceIdentifier
            let expectedRevision =
                preflight.sourceRevisionAtInspection

            let actualRevision = try await resolver.revision(
                of: sourceIdentifier
            )

            guard actualRevision == expectedRevision else {
                throw Failure.sourceDrift(
                    expected: expectedRevision,
                    actual: actualRevision
                )
            }

            await observer.observe(
                .started(
                    sourceIdentifier
                )
            )

            let artifact = Compiler.compile(
                plan
            )

            try await writer.write(
                artifact
            )

            await observer.observe(
                .wroteArtifact(
                    artifact.artifactIdentifier
                )
            )

            let result = Result(
                artifactIdentifier:
                    artifact.artifactIdentifier,
                sourceIdentifier:
                    sourceIdentifier,
                sourceRevision:
                    actualRevision,
                byteCount:
                    artifact.body.utf8.count
            )

            await observer.observe(
                .finished(
                    result.artifactIdentifier
                )
            )

            return result
        }

        func run(
            _ input: Input
        ) async throws -> Result {
            let resolvedInput = try await resolve(
                input
            )

            let plan = plan(
                resolvedInput
            )

            let preflight = try await preflight(
                plan
            )

            return try await execute(
                preflight
            )
        }
    }

    private enum Compiler {
        static func compile(
            _ plan: Plan
        ) -> Artifact {
            let input = plan.resolvedInput

            let body = [
                "target=\(input.sourceIdentifier.value)",
                "revision=\(input.revision.value)",
                "configuration=\(input.configuration.rawValue)",
                "source=\(input.source)",
            ]
            .joined(
                separator: "\n"
            )

            return Artifact(
                artifactIdentifier:
                    plan.artifactIdentifier,
                body:
                    body
            )
        }
    }
}

enum BuildBoundary {
    struct CLIInput:
        Sendable
    {
        let target: String
        let configuration: String
    }

    enum Failure:
        Error,
        Equatable,
        Sendable
    {
        case unknownConfiguration(String)
    }

    static func adapt(
        _ input: CLIInput
    ) throws -> Build.Input {
        guard
            let configuration = Build.Configuration(
                rawValue: input.configuration
            )
        else {
            throw Failure.unknownConfiguration(
                input.configuration
            )
        }

        return Build.Input(
            target: try Build.TargetName(
                input.target
            ),
            configuration: configuration
        )
    }
}

enum BuildProjection {
    struct Summary:
        Equatable,
        Sendable
    {
        let artifact: String
        let source: String
        let revision: Int
        let byteCount: Int
    }

    static func summary(
        from result: Build.Result
    ) -> Summary {
        Summary(
            artifact:
                result.artifactIdentifier.value,
            source:
                result.sourceIdentifier.value,
            revision:
                result.sourceRevision.value,
            byteCount:
                result.byteCount
        )
    }
}

enum TerminalBuildPresenter {
    static func render(
        _ summary: BuildProjection.Summary
    ) -> String {
        [
            "Artifact: \(summary.artifact)",
            "Source: \(summary.source)",
            "Revision: \(summary.revision)",
            "Bytes: \(summary.byteCount)",
        ]
        .joined(
            separator: "\n"
        )
    }
}

struct MockSourceResolver:
    Build.SourceResolving
{
    let source: Build.ResolvedSource

    func resolve(
        _ target: Build.TargetName
    ) async throws -> Build.ResolvedSource {
        guard target.value == "demo" else {
            throw Build.Failure.unknownTarget(
                target
            )
        }

        return source
    }

    func revision(
        of sourceIdentifier: Build.SourceIdentifier
    ) async throws -> Build.SourceRevision {
        guard
            sourceIdentifier
                == source.sourceIdentifier
        else {
            throw Build.Failure.unknownSource(
                sourceIdentifier
            )
        }

        return source.revision
    }
}

actor MutableSourceResolver:
    Build.SourceResolving
{
    let sourceIdentifier: Build.SourceIdentifier
    let source: String

    var sourceRevision: Build.SourceRevision

    init(
        sourceIdentifier: Build.SourceIdentifier,
        source: String,
        sourceRevision: Build.SourceRevision
    ) {
        self.sourceIdentifier = sourceIdentifier
        self.source = source
        self.sourceRevision = sourceRevision
    }

    func resolve(
        _ target: Build.TargetName
    ) throws -> Build.ResolvedSource {
        guard target.value == "demo" else {
            throw Build.Failure.unknownTarget(
                target
            )
        }

        return Build.ResolvedSource(
            sourceIdentifier:
                sourceIdentifier,
            revision:
                sourceRevision,
            source:
                source
        )
    }

    func revision(
        of sourceIdentifier: Build.SourceIdentifier
    ) throws -> Build.SourceRevision {
        guard
            sourceIdentifier
                == self.sourceIdentifier
        else {
            throw Build.Failure.unknownSource(
                sourceIdentifier
            )
        }

        return sourceRevision
    }

    func setRevision(
        _ revision: Build.SourceRevision
    ) {
        sourceRevision = revision
    }
}

actor RecordingArtifactWriter:
    Build.ArtifactWriting
{
    private var writtenArtifacts:
        [Build.Artifact] = []

    func write(
        _ artifact: Build.Artifact
    ) {
        writtenArtifacts.append(
            artifact
        )
    }

    func artifacts() -> [Build.Artifact] {
        writtenArtifacts
    }
}

actor RecordingEventObserver:
    Build.EventObserving
{
    private var recordedEvents:
        [Build.Event] = []

    func observe(
        _ event: Build.Event
    ) {
        recordedEvents.append(
            event
        )
    }

    func events() -> [Build.Event] {
        recordedEvents
    }
}

enum TestFailure:
    Error
{
    case expectationFailed(String)
}

func expect<T: Equatable>(
    _ actual: T,
    equals expected: T,
    _ message: String
) throws {
    guard actual == expected else {
        throw TestFailure.expectationFailed(
            message
        )
    }
}

func happyPathTest() async throws {
    let sourceIdentifier =
        Build.SourceIdentifier(
            value: "demo-source"
        )

    let resolver = MockSourceResolver(
        source: Build.ResolvedSource(
            sourceIdentifier:
                sourceIdentifier,
            revision:
                Build.SourceRevision(
                    value: 7
                ),
            source:
                "hello"
        )
    )

    let writer =
        RecordingArtifactWriter()

    let observer =
        RecordingEventObserver()

    let operation = Build.Operation(
        resolver:
            resolver,
        writer:
            writer,
        observer:
            observer
    )

    let input = try BuildBoundary.adapt(
        .init(
            target: "demo",
            configuration: "release"
        )
    )

    let result = try await operation.run(
        input
    )

    let artifactIdentifier =
        Build.ArtifactIdentifier(
            sourceIdentifier:
                sourceIdentifier,
            configuration:
                .release
        )

    try expect(
        result.artifactIdentifier,
        equals: artifactIdentifier,
        "artifact identity should be deterministic"
    )

    try expect(
        await writer.artifacts().count,
        equals: 1,
        "execution should write exactly one artifact"
    )

    try expect(
        await observer.events(),
        equals: [
            .started(
                sourceIdentifier
            ),
            .wroteArtifact(
                artifactIdentifier
            ),
            .finished(
                artifactIdentifier
            ),
        ],
        "events should remain separate from the semantic result"
    )

    let projection =
        BuildProjection.summary(
            from: result
        )

    let rendered =
        TerminalBuildPresenter.render(
            projection
        )

    try expect(
        rendered,
        equals: """
        Artifact: demo-source.release
        Source: demo-source
        Revision: 7
        Bytes: 64
        """,
        "presentation should be deterministic boundary lowering"
    )
}

func driftTest() async throws {
    let sourceIdentifier =
        Build.SourceIdentifier(
            value: "demo-source"
        )

    let resolver =
        MutableSourceResolver(
            sourceIdentifier:
                sourceIdentifier,
            source:
                "hello",
            sourceRevision:
                Build.SourceRevision(
                    value: 7
                )
        )

    let writer =
        RecordingArtifactWriter()

    let observer =
        RecordingEventObserver()

    let operation = Build.Operation(
        resolver:
            resolver,
        writer:
            writer,
        observer:
            observer
    )

    let input = Build.Input(
        target: try Build.TargetName(
            "demo"
        ),
        configuration:
            .release
    )

    let resolvedInput =
        try await operation.resolve(
            input
        )

    let plan =
        operation.plan(
            resolvedInput
        )

    let preflight =
        try await operation.preflight(
            plan
        )

    await resolver.setRevision(
        Build.SourceRevision(
            value: 8
        )
    )

    do {
        _ = try await operation.execute(
            preflight
        )

        throw TestFailure.expectationFailed(
            "drifted inspected work must not execute"
        )
    } catch let failure as Build.Failure {
        try expect(
            failure,
            equals: .sourceDrift(
                expected:
                    Build.SourceRevision(
                        value: 7
                    ),
                actual:
                    Build.SourceRevision(
                        value: 8
                    )
            ),
            "execution should report exact source drift"
        )
    }

    try expect(
        await writer.artifacts().count,
        equals: 0,
        "failed preconditions must prevent mutation"
    )
}

func guidelineReferenceIdentityTest() throws {
    guard let guideline = Guideline.all.first else {
        throw TestFailure.expectationFailed(
            "expected at least one authored guideline"
        )
    }

    let reference = GuidelineReference(
        guideline
    )

    try expect(
        reference.rawValue,
        equals: guideline.reference,
        "GuidelineReference should retain the canonical guideline reference"
    )

    let literal: GuidelineReference =
        "historical.guideline.reference"

    try expect(
        literal.rawValue,
        equals: "historical.guideline.reference",
        "GuidelineReference should remain an open string-backed identity"
    )

    let encoded = try JSONEncoder().encode(
        reference
    )

    try expect(
        String(
            decoding: encoded,
            as: UTF8.self
        ),
        equals: "\"\(guideline.reference)\"",
        "GuidelineReference should encode as one JSON string"
    )

    let decoded = try JSONDecoder().decode(
        GuidelineReference.self,
        from: encoded
    )

    try expect(
        decoded,
        equals: reference,
        "GuidelineReference should round-trip through Codable"
    )

    guard let resolved = Guideline(
        reference: reference
    ) else {
        throw TestFailure.expectationFailed(
            "authored GuidelineReference should resolve to a Guideline"
        )
    }

    try expect(
        resolved,
        equals: guideline,
        "authored GuidelineReference should resolve to the exact authored Guideline"
    )

    try expect(
        resolved.title,
        equals: guideline.title,
        "resolved Guideline should expose authored title"
    )

    try expect(
        resolved.summary,
        equals: guideline.summary,
        "resolved Guideline should expose authored summary"
    )

    if Guideline(
        reference: literal
    ) != nil {
        throw TestFailure.expectationFailed(
            "historical open GuidelineReference should remain decodable without falsely resolving to an authored Guideline"
        )
    }
}

@main
struct GuidelinesReferenceMain {
    static func main() async throws {
        try guidelineReferenceIdentityTest()
        try await happyPathTest()
        try await driftTest()

        print(
            "PASS: guidelines reference"
        )
    }
}
