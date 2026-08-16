# Execution

Execution should be boring.

By the time an operation reaches execution, as much ambiguity as reasonably possible should already have been removed.

Execution receives either:

```text
Resolved Input
```

or, for operations where planning is valuable:

```text
Plan
```

and performs the domain work.

This is where the intended side effects happen.

## Execution owns domain effects

Execution may:

```text
write files
run subprocesses
update records
move artifacts
send requests
compile output
perform synchronization
```

It should not need to decide:

```text
how output is colored
whether JSON or pretty text is desired
what terminal width is
how an Agentic result should be phrased
how a GUI displays progress
```

Execution should know how to do the work, not how every possible consumer wants that work represented.

## Observation is not presentation

Execution may emit typed events.

That does not mean it prints progress itself.

The same event stream can be:

```text
rendered by a CLI
recorded by Agentic
shown by a GUI
written to structured logs
ignored by another library
```

without changing the execution surface.

## Cancellation and failure remain domain-neutral

Long-running execution may support cancellation or interruption.

Those mechanics should remain independent of presentation wherever practical.

Likewise, execution failures should be expressed as meaningful typed errors rather than presentation strings.
