# Operational Architecture

The general structural discipline is:

> **Design operations so intent, preparation, execution, observation, outcome, and presentation are separable at meaningful boundaries. Collapse the layers when the operation is simple; preserve them when separating them increases determinism, inspectability, reuse, readability, or adaptability.**

This is a general operational architecture rather than an Agentic-specific architecture.

The same domain operation should be usable from:

```text
CLI
GUI
server
scheduled process
Agentic tool
test flow
another Swift library
```

without its actual domain implementation unnecessarily depending on those consumers.

## Meaningful boundaries, not mandatory layers

The architecture applies to meaningful operational boundaries.

It does not require every function, method, or helper to become an operation object.

A small operation may already be expressed completely by:

```swift
Compare.Number.Decimal.exceeds(
    difference,
    tolerance: tolerance
)
```

Turning the same operation into:

```text
DecimalComparisonInput
    -> DecimalComparisonOperation
    -> DecimalComparisonResult
```

is not automatically more architectural.

The additional types should exist only when they carry useful meaning of their own.

Examples of reasons a value may earn a type include:

```text
it has invariants
it is reused or passed around
it crosses a boundary
it needs to be inspected independently
it is stored or transported
it has a lifecycle beyond one call
it improves readability or cohesion
it is significant enough that callers benefit from naming it
```

The smallest representation that preserves the meaningful architecture is generally preferred.

## Abstraction and layering are separate decisions

Repeated semantics can justify abstraction without justifying additional operational layers.

For example, a repeated decimal tolerance comparison may deserve one canonical reusable function because the same meaning otherwise gets implemented repeatedly.

That does not mean the comparison also needs dedicated input and result carrier types.

A useful distinction is:

```text
abstraction
    centralizes a reusable meaning

layering
    separates independently meaningful stages or representations
```

Both can be useful.

Neither automatically implies the other.

Prefer centralizing repeated meaning without adding representational ceremony that has no independent value.

## Roles

The richest form of the model is:

```text
Input
    ↓
Resolution
    ↓
Plan? / Preparation?
    ↓
Preflight?
    ↓
Execution ──────► Event*
    ↓
Result ─────────► Artifact*
    ↓
Projection / Adaptation
    ↓
Presentation / Integration
```

These are roles, not mandatory concrete types.

The architecture is a vocabulary for finding meaningful boundaries. It is not a requirement that every operation manufacture an `Input`, `ResolvedInput`, `Plan`, `Preflight`, `Event`, `Result`, and `Presenter`.

A role may be represented by:

```text
a dedicated type
an existing domain type
a tuple
a primitive
a helper function
a stage internal to another operation
```

depending on the needs of the operation.

## Preserve meaningful information

A useful cross-cutting rule is:

> **Preserve meaningful information and meaningful boundaries; avoid representations that add no independent meaning.**

This means we should be cautious in both directions.

Do not introduce types merely to satisfy an architectural diagram.

But also do not collapse a useful semantic result into a narrower representation too early.

For example:

```text
Difference
    -> reusable DifferenceLayout
    -> renderer-specific output
```

may preserve useful optionality that would be lost by immediately producing a terminal string.

Likewise, normalization that discards information should be intentional and justified by the domain rather than applied mechanically.

## Dependency direction

Domain code should generally remain usable without the interface that happens to expose it.

Prefer:

```text
domain
    ↓
adapter
    ↓
interface
```

over embedding substantial interface-specific behavior in the domain.

Examples:

```text
Concatenation.Result
    -> Agentic adapter
    -> AgentToolResult
```

```text
BuildResult
    -> Terminal presenter
    -> ANSI output
```

```text
Accounting.Report
    -> PDF adapter
    -> PDF DSL
```

This is a dependency-direction preference, not an absolute prohibition against every lightweight outward-facing protocol conformance.

Some intentionally lightweight integration protocols may reasonably be adopted directly by a domain type when the conformance faithfully exposes the same existing domain value and avoids otherwise redundant mirror types or retroactive-conformance boilerplate.

See `boundary-adaptation.md`.

## Composition roots may join concerns

Separation does not mean separated concerns can never appear together.

An outer orchestration or composition boundary may intentionally coordinate:

```text
execution
events
logging
presentation
process lifecycle
interface behavior
```

For example:

```text
domain operation emits Event
    ↓
CLI command observes Event
    ↓
spinner / terminal presentation
```

The important boundary is that the domain operation does not need the spinner in order to exist.

Composition is where independently defined concerns are allowed to meet.

## Collapse the model when appropriate

A tiny pure operation may remain:

```text
values -> value
```

or:

```text
Input -> Result
```

A read or query may be:

```text
Input -> Resolution -> Result
```

A long-running pure operation may be:

```text
Input -> Execution -> Events + Result
```

A mutating operation may warrant:

```text
Input
    -> Resolution
    -> Plan
    -> Preflight
    -> Execution
    -> Events
    -> Result + Artifacts
```

The test is not whether every box exists.

The test is whether domain intent, effects, observation, semantic outcome, and outward presentation remain separable where that separation has real value.
