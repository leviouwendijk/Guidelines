# Operation Abstractions

The structural model may justify small generic abstractions where several real domains naturally converge.

The abstraction should follow the architecture.

The architecture should not be distorted to satisfy the abstraction.

A minimal experiment might be:

```swift
public protocol Operation: Sendable {
    associatedtype Input: Sendable
    associatedtype Output: Sendable

    func run(
        _ input: Input
    ) async throws -> Output
}
```

For planned operations:

```swift
public protocol PlannedOperation: Sendable {
    associatedtype Input: Sendable
    associatedtype Plan: Sendable
    associatedtype Output: Sendable

    func plan(
        _ input: Input
    ) async throws -> Plan

    func run(
        _ plan: Plan
    ) async throws -> Output
}
```

Observation may remain orthogonal rather than becoming another inheritance requirement:

```text
Operation
PlannedOperation

OperationObserver<Event>
OperationExecution<Result, Event>
```

Do not settle such abstractions merely because they look symmetrical.

A useful test is:

> Do multiple real domains fit the abstraction without contorting their native APIs?

Candidate domains may include:

```text
Accounting
Concatenation
Syncer
Executable
Media
server operations
```

If they converge naturally, a microscopic generic layer may be justified.

If they do not, keep the mental model and discard the protocol.

The structural discipline is more valuable than a universal generic.
