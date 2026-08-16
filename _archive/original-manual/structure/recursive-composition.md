# Recursive Composition

The operational model is recursive.

A library that serves as an adapter or presentation dependency at one architectural level may itself contain operations following the same discipline internally.

For example:

```text
SBM
    uses Terminal as presentation
```

while Terminal may internally have:

```text
RenderInput
    ↓
RenderPlan
    ↓
Renderer
    ↓
RenderResult
```

Likewise:

```text
Accounting
    uses a PDF DSL as an output adapter
```

while the PDF system may internally have:

```text
input
    ↓
resolved layout
    ↓
render plan
    ↓
render events
    ↓
render result
```

This is not conceptually circular.

It is recursive composition.

At every meaningful boundary we can ask:

```text
what is intent?
what requires resolution?
what is preparation?
what performs effects?
what is observation?
what is authoritative output?
what is adaptation?
```

The answers are relative to the operation being considered.

This is why the model is more useful as a structural discipline than as one universal inheritance hierarchy.
