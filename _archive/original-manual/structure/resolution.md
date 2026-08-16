# Resolution

Resolution turns requested intent into concrete meaning in the current environment.

Input may contain values such as:

```text
"master"
"~/foo"
target name
configuration alias
environment
glob
date range
account alias
sync route
```

These are meaningful requests, but they may still require interpretation.

Conceptually:

```text
Input
    requested intent

        ↓ resolution

Resolved meaning
    intent interpreted against the current environment
```

For example:

```text
BuildRequest
    target: "server-package"
    configuration: release
```

may resolve to:

```text
ResolvedBuildRequest
    packageRoot: /actual/path
    target: server-package
    configuration: release
    executableDestination: /actual/sbm-bin/...
```

## Resolve once where practical

Execution should not continuously reinterpret caller intent.

If a path, alias, target, account, environment, or configuration has already been resolved, later stages should generally operate on that concrete meaning rather than independently resolving it again.

This improves:

```text
determinism
inspectability
testability
planning
approval
reuse
```

It also makes environmental interpretation a visible boundary rather than an incidental side effect scattered through execution.

## Resolution does not automatically imply a Resolved type

The resolution role can exist without introducing a dedicated carrier type.

For example, a small resolver may return:

```swift
(code: String, id: Int)
```

or:

```swift
URL
```

when the result is tiny, local, and has one obvious consumer.

A named resolved type becomes more useful when the result:

```text
is significant to the domain
is passed through several later stages
has several consumers
needs dedicated behavior
carries invariants
is stored or transported
would otherwise produce difficult tuple signatures
substantially improves readability or cohesion
```

For example:

```swift
struct ResolvedAutoCloseTargets {
    let netIncome: Target
    let equity: Target
}
```

may be preferable when the pair is a meaningful unit in later accounting logic.

The purpose of the type is not to prove that resolution occurred.

The purpose is to give a meaningful resolved value an appropriate representation.

## Tuples are acceptable for limited local results

A tuple is not architecturally inferior merely because a named type could exist.

For a small local operation with a limited consumer:

```swift
(
    ni: (code: String, id: Int),
    equity: (code: String, id: Int)
)
```

may be sufficient.

Prefer a type when the tuple begins to travel, repeat, grow, or acquire independent meaning.

This is partly a readability and cohesion decision rather than a mechanical architecture rule.

## Resolution and parsing are related but distinct

Parsing asks whether an external or loose representation can become a stronger domain value.

Resolution interprets an already meaningful request against environment-dependent state.

They may happen together in simple cases, but they should not be conceptually confused merely because both occur before execution.
