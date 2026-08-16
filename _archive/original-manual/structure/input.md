# Input

Input expresses what the caller wants in domain terms.

It should not encode the accidental syntax of the interface that supplied the request.

Avoid making the real operation consume:

```text
["--recursive", "--force", "./foo"]
```

when the actual domain request can be represented as:

```swift
ConcatenationRequest
SyncRequest
BuildRequest
CompilationRequest
```

The interface performs the adaptation:

```text
CLI arguments ─────┐
Agentic JSON ──────┤
GUI state ─────────┼──> domain input
HTTP payload ──────┤
Swift caller ──────┘
```

This is one of the primary portability boundaries.

## Input does not imply an Input struct

Do not manufacture an input wrapper merely to conform to the architecture.

This is already a good input surface:

```swift
fingerprint(of: data)
```

Likewise:

```swift
Compare.Number.Decimal.exceeds(
    difference,
    tolerance: tolerance
)
```

already expresses a small operation clearly.

Wrapping those values in:

```swift
FingerprintInput
DecimalComparisonInput
```

would only be useful if the grouped value itself acquired meaning beyond the immediate function call.

## When an input type earns its existence

A dedicated input type becomes more useful when the requested intent:

```text
contains several related values
is passed through multiple stages
is stored or transported
needs invariants
is reused by several callers
is inspected before execution
has meaningful defaults or policy
benefits substantially from a named cohesive representation
```

The number of parameters alone is not the rule.

The question is whether the request has become a meaningful value of its own.

## Abstraction does not require an input type

A small helper may deserve centralization because the same semantic operation occurs throughout several libraries.

That does not mean its arguments must become a carrier type.

Prefer centralizing repeated meaning while keeping the public representation proportional to the operation.

## Parse external representations at the boundary

External representations may begin loose.

For example:

```text
JSON
CLI strings
environment variables
database rows
HTTP fields
```

When those values have structural or semantic requirements, parse them into stronger domain types before carrying them deeper into the operation.

See `parse-dont-validate.md`.

The inner operation should receive domain meaning wherever practical, rather than repeatedly reinterpreting raw interface values.
