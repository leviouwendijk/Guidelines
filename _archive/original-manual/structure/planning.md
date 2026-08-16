# Planning

A plan is an executable description of intended work.

Not every operation needs one.

For operations such as:

```text
read a file
calculate a hash
parse a value
render a string
```

a direct input-to-result path may already be correct.

Planning becomes valuable when work is:

```text
multi-step
expensive
mutating
reviewable
resumable
cacheable
approvable
worth previewing
```

For example:

```text
Input
    "sync these projects"

        ↓

Plan
    resolved source
    resolved destination
    files to create
    files to update
    files to remove
    commands to run
    expected bytes
```

Then prefer a shape such as:

```swift
let plan = try synchronizer.plan(input)
let result = try await synchronizer.run(plan)
```

over inspecting one interpretation and later having `run(input)` independently rediscover what should happen.

## Inspected work should be executed work

A central invariant is:

> **The thing inspected should, wherever reasonable, be the thing executed.**

This is useful for human confirmation, Agentic approval, dry runs, testing, resumability, and deterministic execution.

If environmental state can invalidate a plan between planning and execution, that should be handled explicitly through preflight, freshness checks, plan invalidation, or another domain-appropriate mechanism.

It should not silently turn execution into a second independent planning pass.

## Plans remain domain-native

A plan describes domain work.

It should not need to know:

```text
terminal color
JSON formatting
GUI layout
Agentic approval wording
HTTP response shape
```

Those concerns belong outside the plan.
