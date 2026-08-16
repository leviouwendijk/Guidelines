## Compaction Passes

Once a feature works, do not assume the current shape is the final shape.

Code often becomes layered while we are discovering the implementation. We add helpers, wrappers, extensions, compatibility shims, temporary aliases, alternate entrypoints, and small adapters in order to get the thing working. That is fine during construction, but those layers should not automatically survive into the finished design.

Prefer a compaction pass after the feature is in place: reduce the implementation back down to the actual substance it needs.

Not:

```swift
extension Lead {
    func emailAddressValue() throws -> EmailAddress {
        try EmailAddress(email)
    }
}

extension Lead {
    func validatedEmail() throws -> EmailAddress {
        try emailAddressValue()
    }
}

extension LeadMailer {
    func sendValidatedLeadEmail(
        lead: Lead
    ) async throws {
        let email = try lead.validatedEmail()

        try await sendLeadEmail(
            reply_to: email
        )
    }
}
```

Prefer:

```swift
extension LeadMailer {
    func send(
        lead: Lead
    ) async throws {
        try await sendLeadEmail(
            reply_to: EmailAddress(lead.email)
        )
    }
}
```

The first version is not more designed just because it has more named steps. If the intermediate symbols do not carry stable domain meaning, reuse, or boundary value, they are only sediment from the implementation process.

A good compaction pass asks:

1. did this extension survive because it is useful, or because it was convenient while building?
2. does this helper name a real concept, or only restate the line inside it?
3. does this wrapper make the call site better, or merely move code sideways?
4. is this indirection needed for portability, or is it speculative?
5. can the same behavior be expressed with fewer public symbols?

Avoid keeping portability layers unless there is an actual second target.

Not:

```swift
protocol LeadEmailProviding {
    var leadEmailValue: String? { get }
}

extension Lead: LeadEmailProviding {
    var leadEmailValue: String? {
        email
    }
}

func email(
    from provider: LeadEmailProviding
) throws -> EmailAddress {
    try EmailAddress(provider.leadEmailValue)
}
```

Prefer:

```swift
func email(
    from lead: Lead
) throws -> EmailAddress {
    try EmailAddress(lead.email)
}
```

The protocol version only earns its place once more than one real conforming type exists, or when the boundary itself is part of the design. Until then, it widens the surface without reducing complexity.

Backwards compatibility is the main exception. If an old symbol must remain for existing users, keep it deliberately and mark the migration path clearly.

```swift
extension LeadMailer {
    @available(*, deprecated, renamed: "send(lead:)")
    func sendValidatedLeadEmail(
        lead: Lead
    ) async throws {
        try await send(
            lead: lead
        )
    }
}
```

A compaction pass is not a rewrite for its own sake. It is the reduction step after growth. The goal is to remove scaffolding, collapse duplicate paths, delete speculative portability, and leave behind the smallest implementation that still expresses the domain clearly.
