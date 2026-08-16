# Results

A result describes the authoritative semantic outcome of an operation.

It should answer:

> **What durable or meaningful state came out of this operation?**

It should not primarily answer:

> What did I print?

And it does not need to collapse every meaningful outcome into a boolean success flag.

Examples:

```text
BuildResult
    product
    artifact
    configuration
    duration
    compilation status
    generated metadata
```

```text
SyncResult
    created
    updated
    deleted
    skipped
    bytes transferred
    post-actions
```

```text
CompilationResult
    model
    diagnostics
    generated entries
    output
```

A useful test is:

> If a completely different front-end consumed this tomorrow, would the result still be useful?

If yes, the result is probably carrying domain information rather than presentation state.

## Results are authoritative

Callers should not have to reconstruct meaningful final state by inspecting progress events, terminal output, logs, or presenter state.

Those are observations or projections.

The result is where semantically meaningful final information belongs.

## Do not lower a reusable result too early

Prefer preserving the richest reasonably reusable semantic representation until a boundary actually requires a narrower one.

Avoid prematurely turning:

```text
DomainResult
```

into:

```text
terminal String
JSON
HTML
GUI row
Agentic message
```

when later consumers may reasonably need the underlying semantic information.

Early irreversible projection often causes a later refactor when another consumer appears.

For example:

```text
TextDifference
    ↓
DifferenceLayout
    ├── basic renderer
    ├── terminal renderer
    └── other consumers
```

may be preferable to:

```text
TextDifference
    ↓
terminal String
```

when `DifferenceLayout` preserves information shared by several output paths.

## Intermediate results must still earn their existence

Do not introduce an intermediate model merely because another stage can be drawn on an architecture diagram.

An intermediate representation is especially useful when it:

```text
preserves information needed by several consumers
adds reusable semantic enrichment
can be inspected independently
provides a stable boundary between domain computation and output
substantially improves readability or cohesion
```

If an intermediate value has only one trivial consumer and no independent meaning, keeping it private or collapsing it may be cleaner.

## Results do not always need result structs

A tiny operation may legitimately return:

```text
Bool
Int
String
Decimal
URL
```

when that value already is the complete semantic result.

For example:

```swift
Compare.Number.Decimal.exceeds(...)
    -> Bool
```

does not become more meaningful merely by returning:

```swift
DecimalComparisonResult(
    exceedsTolerance: true
)
```

A result type should represent useful result structure, not merely rename a primitive.

## No-op states can be real results

Outcomes such as:

```text
no changes
already up to date
0 matches
cache miss
conflict detected
```

may be legitimate typed domain outcomes rather than exceptional failures.

See `failures-and-outcomes.md`.
