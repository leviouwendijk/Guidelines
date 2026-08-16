# Artifacts

Result and artifact are related but distinct concepts.

```text
Result
    semantic outcome

Artifact
    produced material
```

For example:

```text
Result
    compilation succeeded with 4 warnings

Artifacts
    compiled .ec output
    generated report
    PDF
    executable
    concatenated document
    diff
```

An artifact may be referenced by the result.

This avoids bloating every result with large material while preserving the relationship between the operation and what it produced.

## Artifacts remain domain-addressable

Where practical, results should refer to produced material through stable domain information such as:

```text
path
URL
identifier
metadata
content fingerprint
artifact record
```

rather than embedding interface-specific wrappers.

## Artifact production is not presentation by definition

A generated executable, file, report, or compiled representation may itself be the meaningful product of domain execution.

A presentation layer may then describe or expose that artifact.

The fact that something is externally visible does not automatically make it presentation.
