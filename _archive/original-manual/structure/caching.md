# Caching

Caching belongs beneath domain execution and resolution, not inside presentation.

Conceptually:

```text
Input
    ↓
Resolution
    ↓
fingerprints / cache lookup
    ↓
Plan
    ↓
Execution
```

A cache is primarily an implementation mechanism for avoiding unnecessary work.

It should not normally change the semantic contract of the operation.

## Cache observation

Cache activity may produce events:

```text
.cacheHit(path)
.cacheMiss(path)
.recomputed(path)
```

The final result may expose useful aggregate facts:

```text
cacheHits: 137
recomputed: 3
```

when those facts are useful to consumers.

The caller should not need to understand the internal cache representation.

## Cache behavior should preserve semantics

A warm execution and a cold execution should produce equivalent domain results unless the cache is itself intentionally part of the domain.

Caching should improve computational footprint without unnecessarily changing:

```text
behavior
configuration surface
output semantics
presentation contracts
```

## Cache state is not presentation state

A terminal renderer, GUI, or Agentic adapter may choose to expose cache information.

The cache mechanism itself should not depend on any of those presentation layers.
