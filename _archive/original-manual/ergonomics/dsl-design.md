## DSL Design

A good DSL should make the common case feel like the language wanted to say it that way.

The aim is not just fewer characters. The aim is a better call-site shape: less ceremony, less repeated context, clearer defaults, and a stronger sense that the user is describing intent rather than assembling plumbing.

### Start from the call site

Design the surface from the code we want to write most often.

Not:

```swift
return [
    Route(
        method: .post,
        path: "/encrypt",
        handler: { request, router in
            try await encrypt(request)
        }
    )
]
```

Prefer:

```swift
return routes {
    post("encrypt") { request in
        try await encrypt(request)
    }
}
```

The full initializer can still exist, but it should not be the primary writing experience. In the normal path, the DSL should carry the boring structural parts for us: method, path construction, handler adaptation, and collection building. The Server route DSL does this with a `routes` result-builder container and per-method route functions such as `get`, `post`, `put`, `patch`, `delete`, and `options`.  

### Put the domain word where the user already thinks it

For route APIs, the HTTP method is not a parameter detail. It is the sentence opener.

Not:

```swift
Route(
    method: .post,
    path: "/decrypt",
    handler: decrypt
)
```

Prefer:

```swift
post("decrypt") { request in
    try await decrypt(request)
}
```

This is the same rule as wrapper-accessor APIs: move repeated context leftward so the final symbol can stay small. In a route DSL, the method itself is the wrapper. Once the call begins with `post`, the symbol no longer needs `route`, `http`, `method`, `handler`, or `endpoint` in its name.

### Provide overload families by need, not by implementation

A DSL should expose the amount of context the route actually needs.

```swift
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
```

The overloads should form a small ladder:

1. no request, no router
2. request only
3. request plus router

That gives each route only the parameters it actually uses. The implementation can still normalize everything to one underlying handler shape. The public shape should not force unused underscores into every call site. The Server route initializers follow this pattern by providing parameterless, request-only, and request-plus-router forms. 

### Defaults should remove syntax, not hide decisions

A default root route should be a separate shape, not a string the caller has to remember.

```swift
get {
    .text("home")
}
```

is better than:

```swift
get("/") {
    .text("home")
}
```

The root path is common enough that it earns a default. But the default should stay visible in the DSL design: a no-path overload means root. That is cleaner than making callers pass empty strings, optional paths, or magic values. The Server DSL has an explicit root default behind the route functions. 

### Prefer path components over path strings when it improves composition

A route path is conceptually a list of parts.

```swift
post("users", userIdentifier, "reset-password") { request in
    try await resetPassword(request)
}
```

is usually nicer than:

```swift
post("/users/\(userIdentifier)/reset-password") { request in
    try await resetPassword(request)
}
```

The caller should not have to think about leading slashes, double slashes, or separators while writing the domain action. Variadic path components give the DSL a more natural shape, while the library owns path normalization. The Server code has helpers for path components and route overloads that join variadic components.  

### Builder containers should accept both single items and groups

A result builder should not punish the user for extracting pieces.

```swift
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
```

The builder should accept:

```swift
Route
[Route]
optional routes
conditional routes
groups with middleware
```

That lets the user organize by meaning without flattening everything manually. The route builder supports single routes, arrays, optional branches, either branches, arrays from loops, and grouped middleware expressions. 

### Modifiers should read after the thing they modify

When a route is created first and then decorated, the modifier should chain after the route.

```swift
post("encrypt") { request in
    try await encrypt(request)
}
.use(bearer)
```

This reads better than pushing middleware into the route initializer:

```swift
post(
    "encrypt",
    middleware: [bearer]
) { request in
    try await encrypt(request)
}
```

The route itself remains the noun. The modifier becomes a clear second phrase. This keeps the primary DSL focused on the endpoint shape and lets cross-cutting behavior attach without bloating the initializer. The generated package template uses this shape in its commented route examples. 

### Separate declaration DSL from runtime wiring

A good DSL should keep the domain declaration in one place and the runtime boot process somewhere else.

```swift
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
```

The app entrypoint can then consume the result.

```swift
let process = ServerProcess(
    config: config,
    routes: try routes(),
    logger: logger,
    activity: activity
)
```

The route file should feel like a table of capabilities. The runtime file should feel like process wiring. Mixing those two makes both APIs worse. The package template separates generated `routes.swift` from the app process setup.  

### Use progressive disclosure for command and argument DSLs too

Command APIs should have the same philosophy as route APIs: the smallest useful invocation should be tiny, and power should appear only when asked for.

For a command-line DSL, this means:

```swift
server-package mailer
```

before:

```swift
server-package mailer --version 2 --yes
```

And in code:

```swift
@Argument(help: "Package name")
var name: String?

@Option(name: .shortAndLong, help: "Package version number")
var version: Int?

@Flag(name: .shortAndLong, help: "Skip confirmation prompts")
var yes: Bool = false
```

The positional argument carries the primary noun. Options refine it. Flags alter behavior. This matches the route DSL ladder: simple first, named power later. The package command uses an optional positional name, a version option, and a confirmation-skipping flag, falling back to a wizard when no arguments are provided. 

### Make option names describe user intent, not internal structure

For commands, options should name the thing the user thinks they are choosing.

Good:

```swift
--root
--file
--dry-run
--yes
```

Worse:

```swift
--package-root-url-string
--template-file-kind-list
--should-not-write-files
--skip-confirmation-prompts
```

The long internal phrase belongs in help text, not necessarily in the flag name. The DSL surface should be compact; explanation can live beside it. The update command follows this with `root`, `file`, `yes`, and `dryRun` while using help strings for the fuller meaning. 

### Keep the DSL regular across siblings

If one method has this family:

```swift
post("path") { request in }
post("path", request: { request in })
post("path", handler: { request, router in })
```

then the sibling methods should have the same family.

```swift
get(...)
post(...)
put(...)
patch(...)
delete(...)
options(...)
```

A DSL becomes learnable when the user can infer the next symbol. Once someone understands `post`, they should not have to relearn `put`. Regularity is more valuable than clever one-off convenience.

### Let the heavy types stay behind the curtain

The user of a DSL should rarely need to name the underlying structural types.

Good DSLs let users write:

```swift
routes {
    get("ping") {
        .text("pong")
    }

    post("echo") { request in
        .text(request.body)
    }
}
```

The types are still there:

```swift
Route
Router
HTTPRequest
HTTPResponse
RouteBuilder
Middleware
```

But they are supporting actors. The call site should foreground the domain phrase:

```swift
get ping
post echo
use bearer
return response
```

When a route needs lower-level control, the fuller types can become visible. But they should not dominate the common path.

### Prefer small DSL words over long descriptive symbols

In DSL surfaces, small words can be clearer than long names because the context is already carried by the shape.

Prefer:

```swift
routes {
    get("ping") {
        .text("pong")
    }
}
```

Over:

```swift
createServerRoutes {
    createHTTPGetRoute(path: "ping") {
        HTTPResponse.text("pong")
    }
}
```

This follows the same naming principle as nested APIs: do not repeat the parent context in every child symbol. Once we are inside `routes`, `get` is enough. Once we are inside `post`, `request` is enough. Once we are modifying a route, `.use` is enough.

### The test for a DSL

A DSL design is probably right when the simple call site can be read aloud as a small sentence.

```swift
routes {
    get("ping") {
        .text("pong")
    }

    post("encrypt") { request in
        try await Operation.encrypt(request)
    }
    .use(bearer)
}
```

Reads as:

```text
routes:
    get ping, return pong
    post encrypt, use bearer
```

That is the target.

The DSL should compress the structural machinery until the domain sentence is what remains.
