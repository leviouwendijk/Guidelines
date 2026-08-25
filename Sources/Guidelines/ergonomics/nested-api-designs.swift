public enum NestedAPIDesignGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
    case wrapper_domain_operations
    case wrapper_accessors

    public var content: GuidelineContent {
        switch self {
        case .wrapper_domain_operations:
            .init(
                title: "Use wrapper APIs for related operations",
                summary: #"""
                Use wrapper-providing APIs when moving shared domain
                context into an accessor makes the common call site clearer
                and lets related operations use smaller names.
                """#
            ) {
            paragraph(
                #"""
                In alignment with the before, we may sometimes prefer wrapper struct APIs that we add in order to make the call site more ergonomic.
                """#
            )

            paragraph(
                #"""
                That means that we can for example turn something like:
                """#
            )

            code(
                language: "swift",
                content: #"""
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
                """#
            )

            paragraph(
                #"""
                Can be better refactored as:
                """#
            )

            code(
                language: "swift",
                content: #"""
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
                """#
            )

            paragraph(
                #"""
                Note that the only camelCase invocation here is an internal private func, which therefore matters less.
                """#
            )
            }

        case .wrapper_accessors:
            .init(
                title: "Wrapper Accessor Examples",
                summary: #"""
                When several operations share a domain category, move that
                category into a wrapper accessor so child symbols describe
                only their own part of the phrase.
                """#
            ) {
            paragraph(
                #"""
                A wrapper accessor is useful when several operations share the same domain.
                """#
            )

            paragraph(
                #"""
                The noun before the dot carries the category, so the final symbol can stay small.
                """#
            )

            code(
                language: "swift",
                content: #"""
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
                """#
            )

            paragraph(
                #"""
                The flat version has to push the category back into every symbol.
                """#
            )

            code(
                language: "swift",
                content: #"""
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
                """#
            )

            paragraph(
                #"""
                That difference becomes more obvious as the API grows.
                """#
            )

            code(
                language: "swift",
                content: #"""
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
                """#
            )

            paragraph(
                #"""
                Flat names often look explicit, but the explicitness is wasteful when every symbol repeats the same prefix.
                """#
            )

            code(
                language: "swift",
                content: #"""
                scanMatchingPaths
                scanScopedPaths
                scanAuthorizedPaths
                """#
            )

            paragraph(
                #"""
                The wrapper version moves the category once.
                """#
            )

            code(
                language: "swift",
                content: #"""
                scans.matches
                scans.scoped
                scans.authorized
                """#
            )

            paragraph(
                #"""
                This keeps the operation names small without making them vague. The context is not removed; it is shifted left into the access path.
                """#
            )

            paragraph(
                #"""
                The same applies when a second level of nesting makes the phrase clearer.
                """#
            )

            code(
                language: "swift",
                content: #"""
                requireCleanDiagnostics
                requireDefaultRootDiagnosticsClean
                requireNoOverlappingRootDiagnostics
                """#
            )

            paragraph(
                #"""
                The nested form reads as a small sentence.
                """#
            )

            code(
                language: "swift",
                content: #"""
                diagnostics.require.clean()
                diagnostics.require.defaultRoot()
                diagnostics.require.noOverlaps()
                """#
            )

            paragraph(
                #"""
                Here, nesting does semantic work. It lets each symbol describe only its own part of the phrase.
                """#
            )

            paragraph(
                #"""
                Another way, besides wrapper structs, is to use namespace enum types when they genuinely improve the access path without introducing runtime state.
                """#
            )

            paragraph(
                #"""
                Namespace type names still follow normal Swift type naming and use PascalCase. Lowercase enum type names are not used merely to imitate a dotted namespace.
                """#
            )

            code(
                language: "swift",
                content: #"""
                public enum MainType {
                    public enum Subprefix {
                        public static func somefunc() {
                        }
                
                        public static func differentfunc() {
                        }
                    }
                
                    public enum Category {
                        public static func somefunc() {
                        }
                
                        public static func differentfunc() {
                        }
                    }
                }
                """#
            )

            paragraph(
                #"""
                These forms solve slightly different ownership problems. Prefer PascalCase nested enum types when the access path is a genuinely static namespace. When the desired call-site segment should instead be a lowercase value such as io, toolcall, or json, prefer a struct-backed accessor: expose the value through a property or static let, keep the backing type PascalCase, and nest further local capability structs where that improves the phrase. Do not create lowercase enum type names merely to manufacture lowercase dotted API segments.
                """#
            )

            code(
                language: "swift",
                content: #"""
                enum AgenticCLI {
                    static let io = IO()
                
                    struct IO: Sendable {
                        let toolcall = ToolCall()
                        let json = JSON()
                        let error = ErrorOutput()
                        let stdin = Stdin()
                
                        struct ToolCall: Sendable {}
                        struct JSON: Sendable {}
                        struct ErrorOutput: Sendable {}
                        struct Stdin: Sendable {}
                    }
                }
                
                AgenticCLI.io.toolcall.read()
                AgenticCLI.io.json.write(envelope)
                AgenticCLI.io.error.write(error)
                AgenticCLI.io.stdin.reconnectToTerminal()
                """#
            )

            paragraph(
                #"""
                The struct-backed form does not require meaningful mutable state. It can exist primarily to express semantic ownership and keep each operation name small while still giving lowercase call-site categories a normal Swift value representation.
                """#
            )
            }
        }
    }
}
