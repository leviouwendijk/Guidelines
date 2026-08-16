# Events

Events describe what happens during execution.

They answer:

> **What happened during execution?**

They do not answer:

> **What is the final authoritative semantic outcome?**

Examples:

```text
Build.Event
    resolvingDependencies
    compiling(target:)
    linking(target:)
    installing(destination:)
```

```text
Sync.Event
    inspecting
    comparing
    copying(path:)
    deleting(path:)
    runningPostSyncCommand
```

```text
Concatenation.Event
    scanning
    fingerprinting
    cacheHit(path:)
    rendering(path:)
```

## Event is not presentation

An event may contain structured information:

```swift
.copying(
    source: ...,
    destination: ...,
    bytes: ...
)
```

The CLI may render:

```text
copying  Package.swift
```

A GUI may update a progress row.

Agentic may retain it as a runtime event.

Another library may ignore it.

The event itself should remain domain information.

## Events are optional to consume

A caller should be able to ignore events without losing the actual result of the operation.

Events provide temporal observation, not required semantic reconstruction.

Avoid designs where callers must do this:

```swift
var copied = []

for event in events {
    if case let .copied(path) = event {
        copied.append(path)
    }
}
```

merely to determine the authoritative list of copied files.

If `copiedFiles` is part of the meaningful outcome, it belongs in the result.

Conceptually:

```text
Events
    temporal observation

Result
    authoritative semantic outcome
```

Events may overlap informationally with the final result. That duplication is legitimate because the two representations serve different temporal roles.
