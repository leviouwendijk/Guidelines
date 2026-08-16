# Boundary Adaptation

Adaptation should generally happen at meaningful boundaries.

A strong default is:

> **Do not drag substantial outer-domain behavior or representation inward merely because one current consumer requires it.**

Avoid:

```text
Concatenation.Result contains AgentToolResult
```

Prefer:

```text
Concatenation.Result
    -> AgenticDomains adapter
    -> AgentToolResult
```

Avoid:

```text
Executable.BuildResult contains ANSI strings
```

Prefer:

```text
BuildResult
    -> Terminal presenter
    -> ANSI output
```

Avoid:

```text
Accounting parser produces PDF DSL nodes
```

Prefer:

```text
Accounting.Report
    -> Report/PDF adapter
    -> PDF DSL
```

This preserves composition because the inner domain can exist without substantial knowledge of the outer consumer.

## Dependency direction is a default, not an absolute ban

Where practical:

```text
domain
    <- adapter depends on domain
    <- interface depends on adapter/domain
```

is preferable to:

```text
domain depends heavily on interface
```

But not every outward-facing protocol conformance requires a mirror type or adapter.

The architecture should avoid boilerplate as well as coupling.

## Lightweight integration conformances may remain native

A domain type may reasonably conform directly to a lightweight integration protocol when all of the following are substantially true:

```text
the dependency is intentionally lightweight
the dependency is stable and controlled
the conformance faithfully exposes the existing domain value
the conformance does not add substantial consumer-specific state
the conformance does not distort the domain model
an adapter would mostly mirror the same type
the direct conformance avoids repeated boilerplate or undesirable retroactive conformances
```

A command-line argument protocol is a good example of a possible exception.

Suppose:

```swift
public enum BusinessEntity: String, Sendable, Codable {
    case vof
}
```

already represents the exact values the CLI should accept.

If a lightweight `Arguments` protocol can express that directly, this may be preferable:

```swift
public enum BusinessEntity:
    String,
    Sendable,
    Codable,
    ArgumentValue
{
    case vof
}
```

to manufacturing:

```swift
enum BusinessEntityArgument {
    case vof

    var businessEntity: BusinessEntity {
        .vof
    }
}
```

purely to keep the domain target theoretically free from all interface protocol conformances.

The adapter would add another representation without adding another meaning.

## Evaluate the cost of the dependency itself

The acceptability of direct conformance depends partly on what is imported.

A heavy interface framework that brings substantial runtime behavior, policy, or transitive dependencies inward is materially different from a microscopic protocol-only library intended to support such conformances.

The question is not merely:

> Does the domain import something outward-facing?

The better questions are:

```text
What semantic coupling does this introduce?
What dependency weight does it introduce?
Does the conformance distort the domain?
Does an adapter actually provide isolation?
Would the adapter merely duplicate the same value?
```

## Retroactive conformance can itself be a cost

Moving every conformance outward can produce:

```text
repeated retroactive conformances
warnings
duplicated mappings
mirror enums
boilerplate adapters
fragmented knowledge about the same canonical value
```

Those costs are real.

Boundary purity should not be pursued mechanically when it makes the system less cohesive without creating meaningful isolation.

## Substantial adaptation still belongs outward

The lightweight-conformance exception does not justify embedding:

```text
terminal rendering
HTTP response construction
Agentic result envelopes
database transport models
GUI state
framework lifecycle
```

into core domain types merely because a protocol could technically expose them.

When adopting the protocol meaningfully changes what the type represents or how the domain must behave, prefer an adapter.

## Adapters may be domain-specific

Do not force all adaptation into one generic translation framework.

A small explicit adapter between two real domains is often clearer than a universal abstraction intended to anticipate every future consumer.
