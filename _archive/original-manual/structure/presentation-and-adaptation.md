# Presentation and Adaptation

Presentation happens after domain meaning exists.

Conceptually:

```text
Result + Events + maybe Plan/Preflight
                 ↓
              Adapter
                 ↓
             Presenter
```

A presenter or adapter should project domain information outward.

It should not generally redo domain decisions.

Examples:

```text
BuildResult
    -> terminal summary

BuildEvent
    -> progress line

BuildResult
    -> JSON response

BuildResult
    -> web response DTO

BuildResult
    -> Agentic tool output

BuildResult
    -> GUI view model
```

## Delay irreversible projection

Prefer retaining reusable structured information until the point where a particular consumer requires a narrower representation.

For example:

```text
Difference
    ↓
DifferenceLayout
    ├── terminal renderer
    ├── plain renderer
    └── other consumers
```

can preserve more architectural flexibility than:

```text
Difference
    ↓
terminal String
```

The important distinction is not whether an intermediate type is called a result, layout, projection, report, or model.

The important distinction is whether it preserves or adds reusable meaning before the final representation-specific lowering step.

## Shared projections may be legitimate intermediate models

Sometimes the domain result is not itself the ideal direct input for every renderer.

A shared projection may enrich or reorganize domain information for several later consumers:

```text
DomainResult
    ↓
SharedProjection
    ├── Terminal
    ├── HTML
    ├── GUI
    └── Agentic
```

That is a legitimate intermediate boundary when the projection has shared semantic utility.

Do not introduce such a layer merely in anticipation of hypothetical consumers.

It earns its place through real reuse, enrichment, readability, or boundary value.

## Domain representation is not automatically consumer presentation

A domain type may expose useful stable representations such as:

```text
relative path
display label
canonical description
structured summary
```

without necessarily becoming coupled to a particular UI.

The stronger warning applies to representation policy tied to a specific consumer:

```text
ANSI color
terminal width
GUI row state
HTTP status formatting
localized interface prose
Agentic result envelopes
```

The question is whether the representation belongs to the domain or to a particular outward vehicle.

## Presentation is replaceable

A healthy domain operation can gain a new presentation surface without changing its actual execution model.

Adding:

```text
CLI
GUI
web API
Agentic
JSON
TUI
```

should usually mean adding an adapter or presenter, not teaching the inner operation about the new consumer.

## Adaptation occurs at boundaries

Prefer:

```text
Domain.Result
    -> ConsumerAdapter
    -> Consumer.Type
```

over embedding substantial consumer-specific state directly into the domain result.

The adapter is where semantic translation between domains normally belongs.

See `boundary-adaptation.md` for lightweight protocol-conformance exceptions.

## Composition roots may coordinate presentation and execution

Separation does not require execution and presentation to exist in different processes, binaries, or even different orchestration functions.

For example, a CLI command may legitimately do this:

```text
run domain operation
    ↓
observe Event
    ↓
update spinner
    ↓
receive Result
    ↓
render summary
```

The important property is that the domain operation itself does not require that spinner or terminal renderer.

The outer composition layer is allowed to bring independently defined concerns together.

## Presenters consume decisions; they do not make them

A presenter may select what information to show and how to format it.

It should not silently reinterpret which files should be changed, which target should be built, whether a domain operation succeeded, or what the authoritative result was.

Those decisions belong inward of presentation.
