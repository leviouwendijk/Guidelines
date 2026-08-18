public enum DSLDesignGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
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
                A good DSL should make the common case feel like the language wanted to say it that way.
                """#
            )

            paragraph(
                #"""
                The aim is not just fewer characters. The aim is a better call-site shape: less ceremony, less repeated context, clearer defaults, and a stronger sense that the user is describing intent rather than assembling plumbing.
                """#
            )

            paragraph(
                #"""
                Design the surface from the code we want to write most often.
                """#
            )

            paragraph(
                #"""
                Not:
                """#
            )

            code(
                language: "swift",
                content: #"""
                return [
                    Route(
                        method: .post,
                        path: "/encrypt",
                        handler: { request, router in
                            try await encrypt(request)
                        }
                    )
                ]
                """#
            )

            paragraph(
                #"""
                Prefer:
                """#
            )

            code(
                language: "swift",
                content: #"""
                return routes {
                    post("encrypt") { request in
                        try await encrypt(request)
                    }
                }
                """#
            )

            paragraph(
                #"""
                The full initializer can still exist, but it should not be the primary writing experience. In the normal path, the DSL should carry the boring structural parts for us: method, path construction, handler adaptation, and collection building. The Server route DSL does this with a routes result-builder container and per-method route functions such as get, post, put, patch, delete, and options.
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
                For route APIs, the HTTP method is not a parameter detail. It is the sentence opener.
                """#
            )

            paragraph(
                #"""
                Not:
                """#
            )

            code(
                language: "swift",
                content: #"""
                Route(
                    method: .post,
                    path: "/decrypt",
                    handler: decrypt
                )
                """#
            )

            paragraph(
                #"""
                Prefer:
                """#
            )

            code(
                language: "swift",
                content: #"""
                post("decrypt") { request in
                    try await decrypt(request)
                }
                """#
            )

            paragraph(
                #"""
                This is the same rule as wrapper-accessor APIs: move repeated context leftward so the final symbol can stay small. In a route DSL, the method itself is the wrapper. Once the call begins with post, the symbol no longer needs route, http, method, handler, or endpoint in its name.
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
                A DSL should expose the amount of context the route actually needs.
                """#
            )

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

            paragraph(
                #"""
                The overloads should form a small ladder:
                """#
            )

            list(
                style: .ordered,
                items: [
                    "no request, no router",
                    "request only",
                    "request plus router",
                ]
            )

            paragraph(
                #"""
                That gives each route only the parameters it actually uses. The implementation can still normalize everything to one underlying handler shape. The public shape should not force unused underscores into every call site. The Server route initializers follow this pattern by providing parameterless, request-only, and request-plus-router forms.
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
                A default root route should be a separate shape, not a string the caller has to remember.
                """#
            )

            code(
                language: "swift",
                content: #"""
                get {
                    .text("home")
                }
                """#
            )

            paragraph(
                #"""
                is better than:
                """#
            )

            code(
                language: "swift",
                content: #"""
                get("/") {
                    .text("home")
                }
                """#
            )

            paragraph(
                #"""
                The root path is common enough that it earns a default. But the default should stay visible in the DSL design: a no-path overload means root. That is cleaner than making callers pass empty strings, optional paths, or magic values. The Server DSL has an explicit root default behind the route functions.
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
                A route path is conceptually a list of parts.
                """#
            )

            code(
                language: "swift",
                content: #"""
                post("users", userIdentifier, "reset-password") { request in
                    try await resetPassword(request)
                }
                """#
            )

            paragraph(
                #"""
                is usually nicer than:
                """#
            )

            code(
                language: "swift",
                content: #"""
                post("/users/\(userIdentifier)/reset-password") { request in
                    try await resetPassword(request)
                }
                """#
            )

            paragraph(
                #"""
                The caller should not have to think about leading slashes, double slashes, or separators while writing the domain action. Variadic path components give the DSL a more natural shape, while the library owns path normalization. The Server code has helpers for path components and route overloads that join variadic components.
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
                A result builder should not punish the user for extracting pieces.
                """#
            )

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

            paragraph(
                #"""
                The builder should accept:
                """#
            )

            code(
                language: "swift",
                content: #"""
                Route
                [Route]
                optional routes
                conditional routes
                groups with middleware
                """#
            )

            paragraph(
                #"""
                That lets the user organize by meaning without flattening everything manually. The route builder supports single routes, arrays, optional branches, either branches, arrays from loops, and grouped middleware expressions.
                """#
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
                When a route is created first and then decorated, the modifier should chain after the route.
                """#
            )

            code(
                language: "swift",
                content: #"""
                post("encrypt") { request in
                    try await encrypt(request)
                }
                .use(bearer)
                """#
            )

            paragraph(
                #"""
                This reads better than pushing middleware into the route initializer:
                """#
            )

            code(
                language: "swift",
                content: #"""
                post(
                    "encrypt",
                    middleware: [bearer]
                ) { request in
                    try await encrypt(request)
                }
                """#
            )

            paragraph(
                #"""
                The route itself remains the noun. The modifier becomes a clear second phrase. This keeps the primary DSL focused on the endpoint shape and lets cross-cutting behavior attach without bloating the initializer. The generated package template uses this shape in its commented route examples.
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
                A good DSL should keep the domain declaration in one place and the runtime boot process somewhere else.
                """#
            )

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

            paragraph(
                #"""
                The app entrypoint can then consume the result.
                """#
            )

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

            paragraph(
                #"""
                The route file should feel like a table of capabilities. The runtime file should feel like process wiring. Mixing those two makes both APIs worse. The package template separates generated routes.swift from the app process setup.
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
                Command APIs should have the same philosophy as route APIs: the smallest useful invocation should be tiny, and power should appear only when asked for.
                """#
            )

            paragraph(
                #"""
                For a command-line DSL, this means:
                """#
            )

            code(
                language: "swift",
                content: #"""
                server-package mailer
                """#
            )

            paragraph(
                #"""
                before:
                """#
            )

            code(
                language: "swift",
                content: #"""
                server-package mailer --version 2 --yes
                """#
            )

            paragraph(
                #"""
                And in code:
                """#
            )

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

            paragraph(
                #"""
                The positional argument carries the primary noun. Options refine it. Flags alter behavior. This matches the route DSL ladder: simple first, named power later. The package command uses an optional positional name, a version option, and a confirmation-skipping flag, falling back to a wizard when no arguments are provided.
                """#
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
                For commands, options should name the thing the user thinks they are choosing.
                """#
            )

            paragraph(
                #"""
                Good:
                """#
            )

            code(
                language: "swift",
                content: #"""
                --root
                --file
                --dry-run
                --yes
                """#
            )

            paragraph(
                #"""
                Worse:
                """#
            )

            code(
                language: "swift",
                content: #"""
                --package-root-url-string
                --template-file-kind-list
                --should-not-write-files
                --skip-confirmation-prompts
                """#
            )

            paragraph(
                #"""
                The long internal phrase belongs in help text, not necessarily in the flag name. The DSL surface should be compact; explanation can live beside it. The update command follows this with root, file, yes, and dryRun while using help strings for the fuller meaning.
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
                If one method has this family:
                """#
            )

            code(
                language: "swift",
                content: #"""
                post("path") { request in }
                post("path", request: { request in })
                post("path", handler: { request, router in })
                """#
            )

            paragraph(
                #"""
                then the sibling methods should have the same family.
                """#
            )

            code(
                language: "swift",
                content: #"""
                get(...)
                post(...)
                put(...)
                patch(...)
                delete(...)
                options(...)
                """#
            )

            paragraph(
                #"""
                A DSL becomes learnable when the user can infer the next symbol. Once someone understands post, they should not have to relearn put. Regularity is more valuable than clever one-off convenience.
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
                The user of a DSL should rarely need to name the underlying structural types.
                """#
            )

            paragraph(
                #"""
                Good DSLs let users write:
                """#
            )

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
                The types are still there:
                """#
            )

            code(
                language: "swift",
                content: #"""
                Route
                Router
                HTTPRequest
                HTTPResponse
                RouteBuilder
                Middleware
                """#
            )

            paragraph(
                #"""
                But they are supporting actors. The call site should foreground the domain phrase:
                """#
            )

            code(
                language: "swift",
                content: #"""
                get ping
                post echo
                use bearer
                return response
                """#
            )

            paragraph(
                #"""
                When a route needs lower-level control, the fuller types can become visible. But they should not dominate the common path.
                """#
            )
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
                In DSL surfaces, small words can be clearer than long names because the context is already carried by the shape.
                """#
            )

            paragraph(
                #"""
                Prefer:
                """#
            )

            code(
                language: "swift",
                content: #"""
                routes {
                    get("ping") {
                        .text("pong")
                    }
                }
                """#
            )

            paragraph(
                #"""
                Over:
                """#
            )

            code(
                language: "swift",
                content: #"""
                createServerRoutes {
                    createHTTPGetRoute(path: "ping") {
                        HTTPResponse.text("pong")
                    }
                }
                """#
            )

            paragraph(
                #"""
                This follows the same naming principle as nested APIs: do not repeat the parent context in every child symbol. Once we are inside routes, get is enough. Once we are inside post, request is enough. Once we are modifying a route, .use is enough.
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
                A DSL design is probably right when the simple call site can be read aloud as a small sentence.
                """#
            )

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

            paragraph(
                #"""
                Reads as:
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

            paragraph(
                #"""
                That is the target.
                """#
            )

            paragraph(
                #"""
                The DSL should compress the structural machinery until the domain sentence is what remains.
                """#
            )
            }
        }
    }
}
