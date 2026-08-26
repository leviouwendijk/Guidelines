public enum DSLDesignGuideline: String, Sendable, Hashable, CaseIterable {
    case start_from_call_site
    case domain_word_first
    case overloads_by_need
    case visible_defaults
    case composable_components
    case builder_composition
    case modifiers_after_subject
    case separate_declaration_and_runtime
    case progressive_disclosure
    case intent_named_options
    case regular_siblings
    case hide_heavy_types
    case small_words
    case domain_sentence_test

    public var content: GuidelineContent {
        switch self {
        case .start_from_call_site:
            .init(
                title: "Start from the call site",
                summary: #"""
                Design a DSL from the code users should write most often,
                keeping full structural initializers available without
                making them the primary writing experience.
                """#
            ) {
                paragraph(
                    #"""
                    A good DSL should make the common case feel like the language wanted to say it that way. The aim is not merely fewer characters: it is less ceremony, less repeated context, clearer defaults, and a stronger sense that the caller is describing intent rather than assembling plumbing.
                    """#
                )

                example("Design outward from the desired call site") {
                    code(
                        language: "swift",
                        content: #"""
                        // Avoid making the structural initializer the normal surface.
                        return [
                            Route(
                                method: .post,
                                path: "/encrypt",
                                handler: { request, router in
                                    try await encrypt(request)
                                }
                            )
                        ]

                        // Prefer the domain-facing form for the common path.
                        return routes {
                            post("encrypt") { request in
                                try await encrypt(request)
                            }
                        }
                        """#
                    )
                }

                paragraph(
                    #"""
                    The full initializer can still exist for lower-level control. It should simply not dominate the ordinary writing experience when a DSL can carry structural concerns such as method selection, path construction, handler adaptation, and collection building on the caller's behalf.
                    """#
                )
            }

        case .domain_word_first:
            .init(
                title: "Put the domain word where the user already thinks it",
                summary: #"""
                Place the domain word where the user naturally begins the
                sentence so repeated structural context does not have to
                be restated in child symbols.
                """#
            ) {
                paragraph(
                    #"""
                    Put the strongest domain word at the point where the caller naturally begins the phrase. In a route DSL, the HTTP method is not incidental parameter data; it is usually the sentence opener.
                    """#
                )

                example("Move the domain word into the call shape") {
                    code(
                        language: "swift",
                        content: #"""
                        // Avoid.
                        Route(
                            method: .post,
                            path: "/decrypt",
                            handler: decrypt
                        )

                        // Prefer.
                        post("decrypt") { request in
                            try await decrypt(request)
                        }
                        """#
                    )
                }

                paragraph(
                    #"""
                    Moving shared context leftward lets the remaining symbols stay small. Once a call begins with `post`, the child surface does not need to repeat words such as route, HTTP, method, handler, or endpoint merely to restate what the call already says.
                    """#
                )
            }

        case .overloads_by_need:
            .init(
                title: "Provide overload families by need, not by implementation",
                summary: #"""
                Expose only the context each call site needs, while
                normalizing those overloads to a common implementation
                behind the public surface.
                """#
            ) {
                paragraph(
                    #"""
                    A DSL should expose only the context the caller actually needs. Do not make every call site acknowledge the richest internal handler shape merely because the implementation eventually normalizes to one.
                    """#
                )

                example("Offer a small ladder of useful shapes") {
                    code(
                        language: "swift",
                        content: #"""
                        get {
                            .text("ok")
                        }

                        get("ping") {
                            .text("pong")
                        }

                        post("echo") { request in
                            .text(request.body)
                        }

                        get("routes") { request, router in
                            try await router.list()
                        }
                        """#
                    )
                }

                list(
                    style: .ordered,
                    items: [
                        "no request and no router when neither is needed",
                        "request only when request context is needed",
                        "request plus router when the operation genuinely needs both",
                    ]
                )

                paragraph(
                    #"""
                    The public overload family should prevent unused placeholders from leaking into ordinary call sites. Normalize the variants behind the surface when that keeps the implementation coherent.
                    """#
                )
            }

        case .visible_defaults:
            .init(
                title: "Defaults should remove syntax, not hide decisions",
                summary: #"""
                Use defaults to remove repetitive syntax while keeping
                the meaning of the default visible in the API shape.
                """#
            ) {
                paragraph(
                    #"""
                    A default is useful when it removes a choice callers should not have to restate. Prefer a distinct call shape whose meaning is obvious over magic strings, empty values, or optional parameters that encode the same convention indirectly.
                    """#
                )

                example("Make the root route a visible default") {
                    code(
                        language: "swift",
                        content: #"""
                        // Prefer: the no-path overload means root.
                        get {
                            .text("home")
                        }

                        // Avoid making callers remember the root sentinel.
                        get("/") {
                            .text("home")
                        }
                        """#
                    )
                }

                paragraph(
                    #"""
                    The syntax disappears, but the decision remains legible because the overload itself communicates what was defaulted.
                    """#
                )
            }

        case .composable_components:
            .init(
                title: "Prefer path components over path strings when it improves composition",
                summary: #"""
                Represent composable domain parts as components when doing
                so removes separator and normalization concerns from call
                sites.
                """#
            ) {
                paragraph(
                    #"""
                    When a value is conceptually composed from domain parts, let the API accept those parts directly when doing so removes incidental separator, escaping, or normalization work from the caller.
                    """#
                )

                example("Compose route paths from components") {
                    code(
                        language: "swift",
                        content: #"""
                        // Prefer when the path is naturally a list of parts.
                        post("users", userIdentifier, "reset-password") { request in
                            try await resetPassword(request)
                        }

                        // Avoid pushing path assembly back into the call site.
                        post("/users/\(userIdentifier)/reset-password") { request in
                            try await resetPassword(request)
                        }
                        """#
                    )
                }

                paragraph(
                    #"""
                    The library should own concerns such as leading separators, duplicate separators, and normalization when those concerns are structural rather than domain meaning.
                    """#
                )
            }

        case .builder_composition:
            .init(
                title: "Builder containers should accept both single items and groups",
                summary: #"""
                Result builders should accept single values, groups,
                optionals, branches, loops, and extracted collections so
                users can organize by meaning.
                """#
            ) {
                paragraph(
                    #"""
                    A result builder should preserve the caller's ability to extract and group meaningful pieces. The DSL should not require everything to be flattened into one monolithic builder body simply to satisfy its construction machinery.
                    """#
                )

                example("Compose extracted and conditional route groups") {
                    code(
                        language: "swift",
                        content: #"""
                        return routes {
                            StandardRoutes.listRoutes()

                            authRoutes
                            adminRoutes

                            if config.enableDebugRoutes {
                                debugRoutes
                            }

                            post("encrypt") { request in
                                try await encrypt(request)
                            }
                        }
                        """#
                    )
                }

                list(
                    style: .unordered,
                    items: [
                        "accept individual domain values",
                        "accept extracted collections of those values",
                        "support optional and conditional branches when the DSL naturally needs them",
                        "support loops and groups when they preserve meaningful organization",
                    ]
                )
            }

        case .modifiers_after_subject:
            .init(
                title: "Modifiers should read after the thing they modify",
                summary: #"""
                When behavior decorates an already-declared subject,
                prefer modifiers that read after that subject instead of
                bloating its initializer.
                """#
            ) {
                paragraph(
                    #"""
                    Keep the primary subject readable first, then attach cross-cutting behavior as a second phrase when the language supports that relationship naturally.
                    """#
                )

                example("Attach middleware after the route") {
                    code(
                        language: "swift",
                        content: #"""
                        // Prefer.
                        post("encrypt") { request in
                            try await encrypt(request)
                        }
                        .use(bearer)

                        // Avoid bloating the primary initializer when the
                        // middleware is conceptually a modifier.
                        post(
                            "encrypt",
                            middleware: [bearer]
                        ) { request in
                            try await encrypt(request)
                        }
                        """#
                    )
                }

                paragraph(
                    #"""
                    The route remains the noun and the modifier becomes a clear follow-on phrase. This keeps the core declaration focused while still making attached behavior visible at the call site.
                    """#
                )
            }

        case .separate_declaration_and_runtime:
            .init(
                title: "Separate declaration DSL from runtime wiring",
                summary: #"""
                Keep domain declaration separate from runtime
                bootstrapping and process wiring so each surface remains
                focused.
                """#
            ) {
                paragraph(
                    #"""
                    Keep declarative domain structure separate from process startup, dependency wiring, and runtime lifecycle when those are different concerns. The declaration surface should read like the capabilities being described; the runtime surface should read like composition and bootstrapping.
                    """#
                )

                example("Keep route declaration focused") {
                    code(
                        language: "swift",
                        content: #"""
                        public func routes() throws -> [Route] {
                            routes {
                                get("ping") {
                                    .text("pong")
                                }

                                post("encrypt") { request in
                                    try await encrypt(request)
                                }
                            }
                        }
                        """#
                    )
                }

                example("Wire the declared routes at runtime") {
                    code(
                        language: "swift",
                        content: #"""
                        let process = ServerProcess(
                            config: config,
                            routes: try routes(),
                            logger: logger,
                            activity: activity
                        )
                        """#
                    )
                }

                paragraph(
                    #"""
                    Mixing declaration and runtime wiring tends to make both APIs noisier because structural setup starts leaking into the domain sentence.
                    """#
                )
            }

        case .progressive_disclosure:
            .init(
                title: "Use progressive disclosure for command and argument DSLs too",
                summary: #"""
                Make the smallest useful command invocation tiny and
                reveal options, flags, and advanced control only when the
                user asks for them.
                """#
            ) {
                paragraph(
                    #"""
                    Command APIs should follow the same progressive-disclosure principle as other DSLs: keep the smallest useful invocation small, then reveal named control only as the caller needs it.
                    """#
                )

                example("Keep the primary command phrase small") {
                    code(
                        language: "text",
                        content: #"""
                        server-package mailer

                        server-package mailer --version 2 --yes
                        """#
                    )

                    paragraph(
                        #"""
                        The first form expresses the primary noun. The second adds explicit refinements without making those refinements mandatory for the ordinary path.
                        """#
                    )
                }

                example("Let argument roles reveal progressively more control") {
                    code(
                        language: "swift",
                        content: #"""
                        @Argument(help: "Package name")
                        var name: String?

                        @Option(name: .shortAndLong, help: "Package version number")
                        var version: Int?

                        @Flag(name: .shortAndLong, help: "Skip confirmation prompts")
                        var yes: Bool = false
                        """#
                    )
                }

                list(
                    style: .unordered,
                    items: [
                        "let the positional argument carry the primary noun when that matches the command grammar",
                        "use options to refine the primary choice",
                        "use flags for behavioral switches",
                        "keep interactive or advanced paths available without forcing their ceremony into the simplest invocation",
                    ]
                )
            }

        case .intent_named_options:
            .init(
                title: "Make option names describe user intent, not internal structure",
                summary: #"""
                Name command options after the choice the user thinks they
                are making; put longer implementation detail in help text
                instead of the flag name.
                """#
            ) {
                paragraph(
                    #"""
                    Name options after the decision the user thinks they are making. Internal storage types, implementation booleans, and transport details should not leak into the command vocabulary merely because they happen to back the option.
                    """#
                )

                example("Keep option vocabulary small and intentional") {
                    code(
                        language: "text",
                        content: #"""
                        # Prefer.
                        --root
                        --file
                        --dry-run
                        --yes

                        # Avoid implementation-shaped names.
                        --package-root-url-string
                        --template-file-kind-list
                        --should-not-write-files
                        --skip-confirmation-prompts
                        """#
                    )
                }

                paragraph(
                    #"""
                    Put the longer explanation in help text when the short domain word is already sufficient at the call site.
                    """#
                )
            }

        case .regular_siblings:
            .init(
                title: "Keep the DSL regular across siblings",
                summary: #"""
                Keep sibling DSL operations structurally regular so
                learning one shape teaches users how to infer the others.
                """#
            ) {
                paragraph(
                    #"""
                    A DSL becomes learnable when understanding one sibling lets the caller predict the others. Prefer a regular family over isolated conveniences that force users to memorize exceptions.
                    """#
                )

                example("Let one route method teach the family") {
                    code(
                        language: "swift",
                        content: #"""
                        post("path") { request in }
                        post("path", request: { request in })
                        post("path", handler: { request, router in })

                        get(...)
                        post(...)
                        put(...)
                        patch(...)
                        delete(...)
                        options(...)
                        """#
                    )
                }

                paragraph(
                    #"""
                    Once the caller understands `post`, similarly capable siblings should expose the same recognizable grammar unless a domain difference genuinely requires another shape.
                    """#
                )
            }

        case .hide_heavy_types:
            .init(
                title: "Let the heavy types stay behind the curtain",
                summary: #"""
                Keep structural types available for lower-level control
                without forcing users to name them throughout the common
                DSL path.
                """#
            ) {
                paragraph(
                    #"""
                    The structural types behind a DSL remain important, but they should not dominate the common call site. Let the surface foreground the domain phrase and reveal heavier representation types only when the caller needs lower-level control.
                    """#
                )

                example("Foreground the domain phrase") {
                    code(
                        language: "swift",
                        content: #"""
                        routes {
                            get("ping") {
                                .text("pong")
                            }

                            post("echo") { request in
                                .text(request.body)
                            }
                        }
                        """#
                    )

                    paragraph(
                        #"""
                        The call site primarily says `get ping` and `post echo`, rather than repeatedly naming the routing machinery that makes those operations possible.
                        """#
                    )
                }

                example("Keep structural types available behind the surface") {
                    code(
                        language: "text",
                        content: #"""
                        Route
                        Router
                        HTTPRequest
                        HTTPResponse
                        RouteBuilder
                        Middleware
                        """#
                    )
                }
            }

        case .small_words:
            .init(
                title: "Prefer small DSL words over long descriptive symbols",
                summary: #"""
                Use short DSL words when the surrounding structure already
                carries the missing context; do not repeat that context in
                every symbol.
                """#
            ) {
                paragraph(
                    #"""
                    Small words are often clearer inside a strong DSL because surrounding structure already supplies the context that a standalone API would otherwise need to encode in the symbol itself.
                    """#
                )

                example("Let the surrounding DSL carry repeated context") {
                    code(
                        language: "swift",
                        content: #"""
                        // Prefer.
                        routes {
                            get("ping") {
                                .text("pong")
                            }
                        }

                        // Avoid repeating the context in every symbol.
                        createServerRoutes {
                            createHTTPGetRoute(path: "ping") {
                                HTTPResponse.text("pong")
                            }
                        }
                        """#
                    )
                }

                paragraph(
                    #"""
                    This is the same contextual naming principle used by nested APIs: once the surrounding phrase already establishes routes, `get` is enough; once a route is being modified, `.use` can be enough. Keep the small word only while that surrounding context makes it immediately clear.
                    """#
                )
            }

        case .domain_sentence_test:
            .init(
                title: "The test for a DSL",
                summary: #"""
                A DSL is succeeding when its common call sites read aloud
                like concise domain sentences rather than descriptions of
                plumbing.
                """#
            ) {
                paragraph(
                    #"""
                    A DSL is probably approaching the right shape when its common call site can be read aloud as a small domain sentence without first translating structural machinery back into intent.
                    """#
                )

                example("Read the call site as a domain sentence") {
                    code(
                        language: "swift",
                        content: #"""
                        routes {
                            get("ping") {
                                .text("pong")
                            }

                            post("encrypt") { request in
                                try await Operation.encrypt(request)
                            }
                            .use(bearer)
                        }
                        """#
                    )

                    code(
                        language: "text",
                        content: #"""
                        routes:
                            get ping, return pong
                            post encrypt, use bearer
                        """#
                    )
                }

                paragraph(
                    #"""
                    The target is not prose imitation for its own sake. The test is whether the DSL has compressed structural machinery until the domain sentence is what remains.
                    """#
                )
            }
        }
    }
}
