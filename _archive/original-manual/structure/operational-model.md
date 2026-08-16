# Operational Model

The richest operational shape is:

```text
                   ┌──────────────┐
                   │    Input     │
                   └──────┬───────┘
                          │
                          ▼
                   ┌──────────────┐
                   │  Resolution  │
                   └──────┬───────┘
                          │
                          ▼
              ┌───────────────────────┐
              │ Plan? / Preparation?  │
              └───────────┬───────────┘
                          │
                    ┌─────▼─────┐
                    │ Preflight?│
                    └─────┬─────┘
                          │
                          ▼
                   ┌──────────────┐
                   │  Execution   │──────► Event*
                   └──────┬───────┘
                          │
                          ▼
                   ┌──────────────┐
                   │    Result    │──────► Artifact*
                   └──────┬───────┘
                          │
                          ▼
               ┌────────────────────┐
               │ Projection/Adapter │
               └─────────┬──────────┘
                         │
          ┌──────────────┼───────────────┐
          ▼              ▼               ▼
         CLI          Agentic           GUI/API
```

No operation has to instantiate every box.

The boxes describe possible semantic roles, not required concrete types.

## Common collapsed forms

### Tiny pure operation

Often the cleanest architecture is simply:

```text
values -> value
```

For example:

```swift
Compare.Number.Decimal.exceeds(
    difference,
    tolerance: tolerance
)
```

There is no requirement to manufacture an input or result type around a small operation when the arguments and return value already express its meaning clearly.

### Small structured operation

```text
Input -> Result
```

A named input or result becomes useful when the value itself has enough meaning to deserve identity, reuse, invariants, storage, inspection, or clearer reading.

### Read/query operation

```text
Input -> Resolution -> Result
```

Resolution does not require a `ResolvedInput` type when the resolved value is tiny and local.

It may instead be an internal stage.

### Long-running pure operation

```text
Input -> Execution -> Events + Result
```

Events become useful when temporal observation matters independently of the final result.

### Mutating operation

```text
Input
    -> Plan
    -> Preflight
    -> Execution
    -> Events + Result
```

Planning and preflight become useful when inspection, approval, reproducibility, safety, or determinism justify them.

### Complex externally presented operation

```text
Input
    -> Resolution
    -> Plan
    -> Preflight
    -> Execution
    -> Events
    -> Result + Artifacts
    -> Projection
    -> Presenter
```

Intermediate projections may be useful when several consumers need a shared enriched representation before final output.

## A role does not automatically earn a type

The conceptual existence of a stage is weaker than the need for a dedicated carrier type.

A type is more justified when its value:

```text
has independent semantic identity
is consumed in several places
is passed across layers
is persisted or transported
carries invariants
needs dedicated behavior
substantially improves readability
```

A tuple, primitive, or local value may remain preferable for a tiny short-lived stage with one obvious consumer.

The architecture is a vocabulary for separation, not a checklist requiring seven structs.
