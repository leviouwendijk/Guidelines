# Structural Principles

1. Preserve meaningful information and meaningful boundaries; avoid representations that add no independent meaning.

2. Domain operations should not require a particular outer interface to exist unless a deliberate lightweight integration conformance provides more cohesion than isolation.

3. Inputs describe requested domain intent rather than interface syntax.

4. Do not manufacture input, result, operation, plan, or other carrier types merely because the architectural role can be named.

5. A representation earns a type when it gains useful identity, invariants, reuse, transportability, inspectability, lifecycle, readability, or cohesion.

6. Abstraction and layering are separate decisions.

7. Centralize repeated meaning without automatically adding representational ceremony.

8. External or loose values should be parsed into stronger types when successful interpretation establishes meaningful invariants.

9. Prefer a throwing initializer or equivalent strong construction boundary when successful parsing should guarantee the resulting type is valid.

10. A loose parsing helper may exist as implementation machinery, but should not normally replace the stronger public semantic boundary when one is available.

11. Validation remains legitimate when inspection itself is the requested operation.

12. Normalization is domain-relative. Silently discard information only when the discarded information is not meaningfully needed by the intended system.

13. Preserve raw input, reject it, or normalize it according to correctness, diagnostics, auditability, recovery, and domain needs rather than one global normalization rule.

14. Resolution interprets environment-dependent intent once where practical.

15. Resolution does not automatically require a named `Resolved` type; create one when the resolved value becomes significant, reusable, readable, cohesive, or independently meaningful.

16. Small local tuples and primitive results are acceptable when introducing a carrier type would add little meaning.

17. Plans describe concrete intended work when planning adds determinism, inspectability, reviewability, reuse, approval, or reproducibility.

18. The thing inspected should, wherever reasonable, be the thing executed.

19. Preflight inspects work; it does not become presentation itself.

20. Execution owns domain effects, not UI policy.

21. Events describe temporal progress and are optional to consume.

22. Events are not authoritative final state.

23. Results describe authoritative semantic outcomes.

24. A result does not need a dedicated result struct when a primitive or existing type already expresses the complete outcome cleanly.

25. Preserve the richest reasonably reusable semantic result until a consumer actually requires a narrower representation.

26. Intermediate projections earn their existence through shared enrichment, reuse, readability, or boundary value rather than hypothetical future consumers.

27. Artifacts are produced material and need not be embedded directly into results.

28. Presenters and adapters project domain information outward.

29. Domain-owned stable representations are different from consumer-specific formatting and interface state.

30. Lightweight protocol conformances may live directly on domain types when they faithfully expose the same value, introduce little dependency weight, avoid redundant mirror types, and do not distort the domain.

31. Substantial outer-domain behavior, representation, and lifecycle should remain outside the semantic core.

32. Composition roots may intentionally coordinate domain execution, events, logging, presentation, and process lifecycle; separation means those concerns remain independently defined, not that they can never meet.

33. Domain outcomes and execution failures should remain distinct concepts.

34. Caching belongs beneath execution/resolution rather than presentation.

35. The operational pattern is recursive: adapters and DSLs may themselves contain operations that follow the same discipline.

36. Generic operation protocols are optional abstractions, not the source of the architecture.

37. Once implementation has stabilized, perform a compaction pass and remove scaffolding that has no durable domain, reuse, compatibility, readability, or boundary value.

The aim is not maximal layering.

The aim is code whose domain meaning remains clear, whose representation is proportional to that meaning, and whose operations can be reused, inspected, observed, adapted, and presented from different contexts without unnecessary coupling or unnecessary ceremony.
