# Domain Outcomes and Execution Errors

Not every non-happy-path state is an error.

If something is a meaningful domain outcome, it often belongs in a typed result or report.

Examples:

```text
no changes
already up to date
validation findings
0 matches
cache miss
conflict detected
nothing eligible to process
```

These may be completely valid outcomes of successfully executed domain logic.

By contrast, if the operation could not fulfill its contract:

```text
cannot read required file
malformed internal state
permission denied
subprocess unexpectedly vanished
corrupt cache record
required dependency unavailable
```

throwing may be appropriate.

## Do not manufacture success wrappers everywhere

Avoid routinely turning operations into shapes equivalent to:

```text
Result<ActualResult, Error>
```

inside another bespoke object that also contains a success flag.

Use the language's throwing model for failures when throwing is semantically appropriate.

Use typed domain results for meaningful outcomes.

## Boundary failures should remain typed

Parsing, resolution, planning, and execution may fail for different reasons.

They do not always need separate error hierarchies, but errors should preserve enough domain meaning that outer adapters can decide how to present or recover from them without parsing strings.
