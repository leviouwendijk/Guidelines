## Parse, don't validate

### Primary reasoning for this principle

Generally we prefer using the initializer of a type instead of a loose validation pass that throws its data away.

Two primary reasons:
1. Separate validation guards (the opposite of parsing here) are control flow parts that may be misimplemented, can be forgotten and skipped, especially when complex control flows make data mutation steps less clear and more ambiguous. Parsing a strong type that can nil, or often better: throw, will never accidentally populate a type that isn't valid, if validation mechanics are requirements for intialization.
2. Validation mechanics can become things that by themselves may be called, but their results are often bools, or even just re-instantiated versions of the same type (ambiguous).

As a consequence, we may want to (if needed) create either a literal parsing mechanism, or devise (if justified) a payload that is looser (for example nillable or looser types), that we then pass into the intializer of our strong throwing init type. It cleanly offloads validation, though sometimes introducing double types. Those we may want to namespace together.

It has the side-benefit of allowing us to become "loose in what we accept, and stringent in what we return."

### The successful parse should normally become structural

When successful interpretation establishes an invariant, prefer making that invariant structural in the value returned to the rest of the program.

Prefer:

```swift
let identifier = try ProjectIdentifier(raw)
```

over:

```swift
let identifier = try parseProjectIdentifier(raw) // String
```

when the important semantic fact is that the value is now a valid `ProjectIdentifier`.

The throwing initializer is especially useful because successful construction itself establishes the guarantee.

Code receiving:

```swift
ProjectIdentifier
```

does not need to remember whether some earlier control-flow branch happened to validate a `String`.

The invariant travels with the type.

### Parsing helpers may exist beneath the strong boundary

Internal parsing machinery does not itself need to return the final public type at every intermediate step.

For example:

```swift
private func parsedIdentifierValue(
    _ rawValue: String
) throws -> String {
    ...
}

public struct ProjectIdentifier {
    public let rawValue: String

    public init(
        _ rawValue: String
    ) throws {
        self.rawValue = try parsedIdentifierValue(
            rawValue
        )
    }
}
```

can be reasonable implementation machinery.

The important distinction is that the loose helper is subordinate to the strong construction boundary.

Avoid making a same-type parsing helper the preferred public semantic API when a stronger domain type can represent the successful result.

This shape:

```swift
public func parseStringIdentifierValue(
    _ value: String
) throws -> String
```

is therefore weaker as a public boundary than:

```swift
public init(
    _ value: String
) throws
```

on the identifier type itself.

### Exceptions

Some validation mechancics may be intentionally not split in two models with a throwing initializer, as is here recommended. That can be fine, but this depends on the implementation. If a validator fits better, it could be ok.

Validation is especially legitimate when validation itself is the requested operation.

Examples include:

```text
configuration inspection
preflight
schema diagnostics
policy checking
consistency reports
linting
audit reports
```

In those cases the meaningful output may genuinely be:

```text
ValidationReport
Diagnostic*
Bool
```

because the caller asked to inspect an existing value rather than convert loose input into a stronger value.

The principle is not:

> Never validate.

It is:

> Do not use a disposable validation result where successful interpretation should instead be represented structurally.

### Parse into types instead of validating raw values

When a value has rules, prefer parsing it into a concrete type over validating the raw value and passing that raw value onward.

Not:

```swift
let rawEmail = payload.email

guard EmailValidator.isValid(rawEmail) else {
    throw LeadError.invalidEmail
}

try sendLeadEmail(
    reply_to: rawEmail
)
```

Prefer:

```swift
let email = try EmailAddress(payload.email)

try sendLeadEmail(
    reply_to: email.rawValue
)
```

The preferred version makes the boundary explicit. Either the value becomes an `EmailAddress`, or construction fails hard. There is no ambiguous middle state where a `String` has supposedly been validated but still looks exactly like every other string.

This also improves call sites downstream. A function that receives `EmailAddress` does not need to wonder whether validation already happened.

Not:

```swift
func sendLeadEmail(
    reply_to: String
) async throws {
    guard EmailValidator.isValid(reply_to) else {
        throw LeadError.invalidEmail
    }

    try await mailer.send(reply_to: reply_to)
}
```

Prefer:

```swift
func sendLeadEmail(
    reply_to: EmailAddress
) async throws {
    try await mailer.send(reply_to: reply_to.rawValue)
}
```

Validation asks whether a value is acceptable. Parsing changes the shape of the value so the rest of the program cannot ignore that answer.

### Normalization may be part of parsing

Parsing does not mean every non-canonical representation must be rejected.

A parser may normalize inputs where the domain intentionally treats several representations as the same value.

For example:

```text
"   levi   "
    -> "levi"
```

may be completely appropriate for an identifier if surrounding whitespace has no meaning in the intended domain.

Normalization is an information-losing transformation, however.

Before silently normalizing, ask:

> Does the information being discarded have any meaning we may reasonably need?

Relevant reasons to retain, reject, or separately record the original value may include:

```text
correctness
diagnostics
auditability
caller feedback
recovery
future processing
domain meaning
```

This means these two transformations are not automatically equivalent:

```text
"   levi   " -> "levi"
```

and:

```text
-15 -> 0
```

A negative context count may represent invalid caller intent rather than merely another spelling of zero.

Whether it should be rejected, normalized, or retained depends on the semantics and consumers of that particular system.

### Preserve raw input when the domain needs it

Sometimes the normalized value is what downstream code needs while the original representation remains useful.

In those cases it may be appropriate to model both:

```swift
struct ParsedValue {
    let raw: String
    let normalized: String
}
```

or retain the original through diagnostics, source information, audit records, or another domain-appropriate representation.

Do not preserve raw input mechanically.

Do not discard it mechanically either.

The decision follows the information needs of the domain.
