public enum NestedAPIGuideline: String, Sendable, Hashable, CaseIterable {
    case wrapper_domain_operations
    case wrapper_accessors
    case local_child_symbols

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
                    Introduce a wrapper when several operations genuinely belong to the same domain category and moving that category into the access path makes the resulting operations smaller and easier to distinguish. The wrapper should carry reusable semantic context, not exist merely to add another dot.
                    """#
                )

                example("Move response delivery into a response domain") {
                    code(
                        language: "swift",
                        content: #"""
                        // A flat protocol repeats the operation category in
                        // each sibling symbol.
                        public protocol AgentModelAdapter: Sendable {
                            func complete(
                                request: AgentRequest
                            ) async throws -> AgentResponse

                            func completeStream(
                                request: AgentRequest
                            ) -> AsyncThrowingStream<AgentStreamEvent, Error>
                        }

                        // A wrapper can make the category explicit once and
                        // let the child operations describe only their mode.
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
                        """#
                    )

                    paragraph(
                        #"""
                        The important change is not the existence of another type. It is that `response` now owns the shared response-delivery context, allowing `buffered` and `stream` to remain small without becoming vague.
                        """#
                    )
                }

                list(
                    style: .unordered,
                    items: [
                        "Use a wrapper when several siblings share a stable domain noun or capability.",
                        "Let the wrapper remove repeated context from the child operations rather than merely relocating the same long names.",
                        "Keep direct convenience operations on the parent when they remain genuinely useful; a wrapper does not require eliminating every shorter forwarding surface.",
                        "Do not introduce a wrapper when there is only one isolated child or when the extra access step makes the common phrase harder to read.",
                    ]
                )
            }

        case .wrapper_accessors:
            .init(
                title: "Use wrapper accessors to carry shared context",
                summary: #"""
                When several operations share a domain category, move that
                category into a wrapper accessor so child symbols describe
                only their own part of the phrase.
                """#
            ) {
                paragraph(
                    #"""
                    A wrapper accessor is useful when the noun before the dot can carry context that would otherwise be repeated in every sibling symbol. The context is not removed; it is shifted left into the access path where the reader can establish it once.
                    """#
                )

                example("Move repeated prefixes into accessors") {
                    code(
                        language: "swift",
                        content: #"""
                        // Prefer when these are real sibling categories.
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
                }

                example("Avoid flattening the category back into every symbol") {
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
                        Flat names can look explicit while still being wasteful. `scanMatchingPaths`, `scanScopedPaths`, and `scanAuthorizedPaths` repeat a category the access path can state once as `scans.matches`, `scans.scoped`, and `scans.authorized`.
                        """#
                    )
                }

                example("Use another level when it contributes another real phrase") {
                    code(
                        language: "swift",
                        content: #"""
                        // Flat repetition.
                        requireCleanDiagnostics()
                        requireDefaultRootDiagnosticsClean()
                        requireNoOverlappingRootDiagnostics()

                        // Nested semantic phrase.
                        diagnostics.require.clean()
                        diagnostics.require.defaultRoot()
                        diagnostics.require.noOverlaps()
                        """#
                    )

                    paragraph(
                        #"""
                        Here both `diagnostics` and `require` do semantic work. Each level contributes context that allows the final child to describe only its own condition.
                        """#
                    )
                }

                example("Choose namespace types or value accessors by the desired ownership shape") {
                    code(
                        language: "swift",
                        content: #"""
                        // A static namespace keeps normal PascalCase type names.
                        public enum MainType {
                            public enum Subprefix {
                                public static func somefunc() {
                                }

                                public static func differentfunc() {
                                }
                            }
                        }

                        // A lowercase call-site category can instead be a
                        // value backed by a normally named Swift type.
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
                        Prefer a PascalCase nested type when the segment is genuinely a static namespace. When the desired segment is a lowercase value such as `io`, `toolcall`, or `json`, a struct-backed accessor can express semantic ownership without inventing lowercase type names. The backing value does not need meaningful mutable state merely to justify its existence.
                        """#
                    )
                }

                list(
                    style: .unordered,
                    items: [
                        "Move a repeated category into an accessor when several sibling operations genuinely share it.",
                        "Let each level of a dotted path contribute new context instead of restating context already established to its left.",
                        "Prefer normal Swift type naming for namespace types; do not create lowercase enum type names merely to imitate a dotted namespace.",
                        "Use a value-backed accessor when lowercase call-site grammar is desirable and the value represents a meaningful capability or ownership segment.",
                    ]
                )
            }

        case .local_child_symbols:
            .init(
                title: "Keep child symbols local to established context",
                summary: #"""
                Let parent types and access paths carry shared meaning so child
                symbols describe only the part of the phrase that remains,
                without introducing nesting that has no semantic work to do.
                """#
            ) {
                paragraph(
                    #"""
                    A dotted API is a sentence. Each level should contribute new context rather than repeat context already established to its left. When a parent type or accessor already names the domain, keep the child operation local to that context.
                    """#
                )

                example("Remove context already supplied by the parent") {
                    code(
                        language: "swift",
                        content: #"""
                        // Avoid.
                        CostEstimator.estimateCost()

                        // Prefer.
                        CostEstimator.estimate()
                        """#
                    )

                    paragraph(
                        #"""
                        `CostEstimator` already establishes that the operation concerns cost. Repeating `Cost` in the child symbol adds length without adding meaning.
                        """#
                    )
                }

                example("Nest when the intermediate category is real") {
                    code(
                        language: "swift",
                        content: #"""
                        // Flat.
                        CostEstimator.estimateTokens()

                        // Prefer when `tokens` is a meaningful category
                        // with neighboring operations or variants.
                        CostEstimator.tokens.estimate()

                        CostEstimator.tokens.input()
                        CostEstimator.tokens.output()
                        CostEstimator.tokens.reasoning()
                        """#
                    )

                    paragraph(
                        #"""
                        The `tokens` segment earns its place when it carries reusable context for several related children. The child names can then remain small because the category is expressed once in the access path.
                        """#
                    )
                }

                example("Do not manufacture hierarchy for a lone concept") {
                    code(
                        language: "swift",
                        content: #"""
                        // If `tokens` has no meaningful sibling category,
                        // a more specific parent may be clearer.
                        TokenCostEstimator.input()
                        TokenCostEstimator.output()
                        TokenCostEstimator.reasoning()
                        """#
                    )
                }

                list(
                    style: .unordered,
                    items: [
                        "Ask whether the parent already provides enough context to shorten the child without ambiguity.",
                        "Introduce another nested level when that level names a real category, ownership boundary, or reusable group of sibling operations.",
                        "Choose the nesting order that matches how the domain is naturally read and grouped at the call site.",
                        "Do not add a wrapper or namespace solely to avoid camelCase or shorten one isolated symbol.",
                        "When nesting would be overkill, keep a clear compound symbol and let the applicable casing convention expose its word boundaries.",
                    ]
                )
            }
        }
    }
}
