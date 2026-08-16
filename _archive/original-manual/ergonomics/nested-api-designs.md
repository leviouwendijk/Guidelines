## Nested API Designs

In alignment with the before, we may sometimes prefer wrapper struct APIs that we add in order to make the call site more ergonomic.

That means that we can for example turn something like:

```swift
public protocol AgentModelAdapter: Sendable {
    func complete(
        request: AgentRequest
    ) async throws -> AgentResponse

    func completeStream(
        request: AgentRequest
    ) -> AsyncThrowingStream<AgentStreamEvent, Error>
}

extension AgentModelAdapter {
    public func complete(
        request: AgentRequest,
        delivery: AgentModelResponseDelivery
    ) -> AsyncThrowingStream<AgentStreamEvent, Error> {
        switch delivery {
        case .buffered:
            completeBufferedStream(request: request)

        case .stream:
            completeStream(request: request)
        }
    }

    private func completeBufferedStream(
        request: AgentRequest
    ) -> AsyncThrowingStream<AgentStreamEvent, Error> {
        AsyncThrowingStream { continuation in
            let task = Task {
                do {
                    let response = try await complete(request: request)
                    continuation.yield(.completed(response))
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }

            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
```

Can be better refactored as:

```swift
public protocol AgentModelAdapter: Sendable {
    var response: AgentModelResponseProviding { get }
}

public protocol AgentModelResponseProviding: Sendable {
    func buffered(
        request: AgentRequest
    ) async throws -> AgentResponse

    func stream(
        request: AgentRequest
    ) -> AsyncThrowingStream<AgentStreamEvent, Error>
}

extension AgentModelAdapter {
    public func respond(
        request: AgentRequest
    ) async throws -> AgentResponse {
        try await response.buffered(request: request)
    }

    public func respond(
        request: AgentRequest,
        delivery: AgentModelResponseDelivery
    ) -> AsyncThrowingStream<AgentStreamEvent, Error> {
        response.respond(
            request: request,
            delivery: delivery
        )
    }
}

extension AgentModelResponseProviding {
    public func respond(
        request: AgentRequest,
        delivery: AgentModelResponseDelivery
    ) -> AsyncThrowingStream<AgentStreamEvent, Error> {
        switch delivery {
        case .buffered:
            bufferedStream(request: request)

        case .stream:
            stream(request: request)
        }
    }

    private func bufferedStream(
        request: AgentRequest
    ) -> AsyncThrowingStream<AgentStreamEvent, Error> {
        AsyncThrowingStream { continuation in
            let task = Task {
                do {
                    let response = try await buffered(request: request)
                    continuation.yield(.completed(response))
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }

            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
```

Note that the only camelCase invocation here is an internal private func, which therefore matters less.


### Wrapper Accessor Examples

A wrapper accessor is useful when several operations share the same domain.

The noun before the dot carries the category, so the final symbol can stay small.

```swift
try controller.defaultRoot.root()
try controller.defaultRoot.resolvedIdentifier()
try controller.defaultRoot.setting(.project)

let result = try controller.scans.matches(specification)
let paths = try controller.scans.scoped(specification)
let authorized = try controller.scans.authorized(specification)

let failures = controller.diagnostics.all
let overlaps = controller.diagnostics.overlappingRoots
try controller.diagnostics.require.clean()
try controller.diagnostics.require.noOverlaps()

let roots = controller.summary.roots
let defaultRoot = controller.summary.defaultRoot

let policy = PathAccessPolicy.defaults.workspace
let closed = PathAccessPolicy.defaults.deny_all
```

The flat version has to push the category back into every symbol.

```swift
try controller.defaultRoot()
try controller.resolvedDefaultRootIdentifier()
try controller.settingDefaultRoot(.project)

let result = try controller.scanMatches(specification)
let paths = try controller.scanScopedPaths(specification)
let authorized = try controller.scanAuthorizedPaths(specification)

let failures = controller.allDiagnostics
let overlaps = controller.overlappingRootDiagnostics
try controller.requireCleanDiagnostics()
try controller.requireNoOverlappingRootDiagnostics()

let roots = controller.rootSummaries
let defaultRoot = controller.defaultRootSummary

let policy = PathAccessPolicy.defaultWorkspacePolicy
let closed = PathAccessPolicy.defaultDenyAllPolicy
```

That difference becomes more obvious as the API grows.

```swift
public extension PathAccessController {
    var defaultRootIdentifierValue: PathAccessRootIdentifier? {
        defaultRootIdentifier
    }

    func resolvedDefaultRootIdentifierValue() throws -> PathAccessRootIdentifier {
        try resolvedRootIdentifier()
    }

    func defaultRootObject() throws -> PathAccessRoot {
        try root()
    }

    func settingDefaultRootIdentifier(
        _ rootIdentifier: PathAccessRootIdentifier
    ) throws -> PathAccessController {
        try withDefaultRoot(
            rootIdentifier
        )
    }

    func scanMatchingPaths(
        _ specification: PathScanSpecification,
        rootIdentifier: PathAccessRootIdentifier? = nil,
        configuration: PathWalkConfiguration = .init()
    ) throws -> PathScanResult {
        try scans.matches(
            specification,
            rootIdentifier: rootIdentifier,
            configuration: configuration
        )
    }

    func scanScopedPaths(
        _ specification: PathScanSpecification,
        rootIdentifier: PathAccessRootIdentifier? = nil,
        configuration: PathWalkConfiguration = .init()
    ) throws -> [ScopedPath] {
        try scans.scoped(
            specification,
            rootIdentifier: rootIdentifier,
            configuration: configuration
        )
    }

    func scanAuthorizedPaths(
        _ specification: PathScanSpecification,
        rootIdentifier: PathAccessRootIdentifier? = nil,
        configuration: PathWalkConfiguration = .init()
    ) throws -> AuthorizedPathScanResult {
        try scans.authorized(
            specification,
            rootIdentifier: rootIdentifier,
            configuration: configuration
        )
    }

    var allRootDiagnostics: [PathAccessRootDiagnostic] {
        diagnostics.all
    }

    var overlappingRootDiagnostics: [PathAccessRootDiagnostic] {
        diagnostics.overlappingRoots
    }

    var hasOverlappingRootDiagnostics: Bool {
        diagnostics.hasOverlappingRoots
    }

    func requireCleanDiagnostics() throws {
        try diagnostics.require.clean()
    }

    func requireDefaultRootDiagnosticsClean() throws {
        try diagnostics.require.defaultRoot()
    }

    func requireNoOverlappingRootDiagnostics() throws {
        try diagnostics.require.noOverlaps()
    }

    var summarizedRoots: [PathAccessRootSummary] {
        summary.roots
    }

    var summarizedDefaultRoot: PathAccessRootSummary? {
        summary.defaultRoot
    }

    var summarizedDiagnostics: [PathAccessRootDiagnostic] {
        summary.diagnostics
    }
}
```

Flat names often look explicit, but the explicitness is wasteful when every symbol repeats the same prefix.

```swift
scanMatchingPaths
scanScopedPaths
scanAuthorizedPaths
```

The wrapper version moves the category once.

```swift
scans.matches
scans.scoped
scans.authorized
```

This keeps the operation names small without making them vague. The context is not removed; it is shifted left into the access path.

The same applies when a second level of nesting makes the phrase clearer.

```swift
requireCleanDiagnostics
requireDefaultRootDiagnosticsClean
requireNoOverlappingRootDiagnostics
```

The nested form reads as a small sentence.

```swift
diagnostics.require.clean()
diagnostics.require.defaultRoot()
diagnostics.require.noOverlaps()
```

Here, nesting does semantic work. It lets each symbol describe only its own part of the phrase.

Another way, besides wrapping structs, is to just use a lowercase enum:

```swift
public enum MainType {
    public enum subprefix {
        public func somefunc() {
        }

        public func differentfunc() {
        }
    }

    public enum category {
        public func somefunc() {
        }

        public func differentfunc() {
        }
    }
}
```
