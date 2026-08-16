# Preflight

Plan and preflight are related but not identical concepts.

```text
Plan
    executable description of what will happen

Preflight
    analysis of whether and how that work may proceed
```

For example:

```text
Plan
    copy A
    replace B
    remove C
```

may produce:

```text
Preflight
    3 paths affected
    28 MB copied
    destination writable
    warning: B changed since the cache snapshot
```

Sometimes one type can serve both purposes.

Sometimes the cleaner shape is:

```text
Plan -> PreflightReport
```

## Preflight is domain information

Preflight should not itself become presentation.

A domain library may expose:

```swift
Sync.Plan
Sync.PreflightReport
```

and an outer adapter may turn the report into:

```text
terminal confirmation
Agentic approval
GUI warning
HTTP response
```

The domain stays domain-native.

## Preflight should not secretly execute

A preflight may inspect state when inspection is required to determine safety or feasibility.

It should not silently perform the domain mutation it claims only to describe.

If inspection itself has meaningful effects, those effects should be modeled deliberately rather than hidden under the word `preflight`.
