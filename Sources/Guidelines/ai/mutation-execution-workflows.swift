public enum MutationExecutionWorkflowGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
    case workflow_shorthand
    case shell_pass_subshell_boundary
    case preflight_before_writes
    case replay_safe_mutations
    case conditionally_chain_stages
    case surface_failure_stage
    case workflow_presentation
    case interactive_shell_paste_syntax
    case shell_parameter_safety
    case embedded_language_boundaries
    case transport_integrity
    case split_large_operations
    case publication_scope
    case proof_and_convenience
    case pass_history_persistence
    case final_state_handoff
    case context_refresh
    case agentic_capability_manifest
    case agentic_tool_plans
    case guidelines_publish_refresh

    public var content: GuidelineContent {
        switch self {
        case .workflow_shorthand:
            .init(
                title: "Use stable shorthand for recurring interaction workflows",
                summary: #"""
                Give recurring AI-assisted coding workflows short names so
                their complete protocol can be requested without restating it.
                """#
            ) {
                list(
                    style: .unordered,
                    items: [
                        "LRP - Line-Range Pass: exact filepath, operation, and current line range with every manual edit; bottom-up within each file.",
                        "ZMP - Zsh Mutation Pass: a pasteable, session-safe zsh mutation and proof pass for one coherent domain, enclosed as an outer subshell by default.",
                        "BMP - Bash Mutation Pass: the bash twin of ZMP, with the same mutation, proof, replay-safety, and default outer-subshell requirements.",
                        "SDP - Staged Domain Pass: split a larger dependency graph into separately provable stages so downstream work cannot advance prematurely.",
                        "GPR - Guidelines Publish-Refresh: prove Guidelines, publish it with `gm commit \"<description>\" --push`, then refresh and rebuild GuidelinesCLI with `sbm pack -b`.",
                        "CR - Context Refresh: after the authoritative workflow state is complete, refresh user-designated Concatenation context directories with `con any -a -f xml`.",
                        "Requests such as `use an LRP`, `give me a ZMP`, `give me a BMP`, `split this as an SDP`, `finish with GPR`, or `finish with CR in <directory>` refer to these complete workflows.",
                    ]
                )
            }

        case .shell_pass_subshell_boundary:
            .init(
                title: "Wrap interactive mutation passes in a subshell by default",
                summary: #"""
                ZMP and BMP execution should be isolated from the user's
                long-lived interactive shell unless the pass specifically
                requires parent-shell mutation.
                """#
            ) {
                list(
                    style: .unordered,
                    items: [
                        "For every returned ZMP or BMP intended to be pasted or executed from an interactive shell, make the entire executable pass an outer subshell `( ... )` by default.",
                        "Treat the subshell as the pass boundary, not merely as a wrapper around individual `cd` calls or risky commands. Setup, mutation, proof, cleanup, and dependent execution for that pass belong inside the closure unless a stage is intentionally split into a separate pass.",
                        "This isolation prevents temporary cwd changes, shell options such as `errexit`, `nounset`, and `pipefail`, traps, variables, functions, aliases, and ordinary `exit` failure paths from changing or terminating the caller's long-lived interactive shell.",
                        "Inside the subshell, `exit 1`, `set -e`, `set -u`, and `set -o pipefail` may be used when they improve failure semantics because they terminate or modify only the isolated pass process.",
                        "Do not omit the outer subshell merely because a pass appears simple. Session isolation is the default transport shape for ZMP and BMP output.",
                        "Omit the outer subshell only when the pass specifically must mutate the parent shell, or when execution is already inside an explicitly isolated non-interactive shell boundary that makes another subshell semantically unnecessary. State that reason explicitly.",
                    ]
                )

                code(
                    language: "zsh",
                    content: #"""
                    (
                        set -e
                        set -u
                        set -o pipefail

                        command_a
                        command_b
                    )
                    """#
                )

                code(
                    language: "bash",
                    content: #"""
                    (
                        set -e
                        set -u
                        set -o pipefail

                        command_a
                        command_b
                    )
                    """#
                )
            }

        case .preflight_before_writes:
            .init(
                title: "Preflight important mutation assumptions before writing",
                summary: #"""
                Validate stable facts that determine whether a coordinated
                mutation is still applicable before committing writes.
                """#
            ) {
                list(
                    style: .unordered,
                    items: [
                        "Check required paths and files before mutation.",
                        "Require expected match counts for exact replacements.",
                        "For coordinated edits, calculate and validate all important transformations before beginning writes when practical.",
                        "Assert stable semantic boundaries such as required symbols, identifiers, generated anchors, or expected call sites when their absence means the mutation should be reconsidered.",
                        "Do not make preflight gratuitously brittle by asserting unrelated formatting or whole-file equality when narrower semantic checks are sufficient.",
                        "If current state violates an important precondition, fail closed and request or inspect fresh state rather than guessing.",
                    ]
                )
            }

        case .replay_safe_mutations:
            .init(
                title: "Make mutating passes replay-safe from the strongest available state",
                summary: #"""
                Protect automated mutations from damaging reruns by proving
                enough current state to know whether the pass is applicable.
                Use revision identity when it is available and meaningful, but
                approximate replay safety from other observable state rather
                than omitting it when no commit or HEAD boundary exists.
                """#
            ) {
                list(
                    style: .unordered,
                    items: [
                        "Treat replay safety as best-effort state classification, not as a requirement that every pass have a Git commit hash, clean repository generation, or other single universal marker.",
                        "Before a ZMP or BMP writes, classify enough current state to distinguish the intended pre-state, a recognizable intended post-state, and ambiguous or partial state when practical.",
                        "Use the strongest relevant guards that are actually available. Depending on the operation these may include branch identity, HEAD, commit hashes, local or remote refs, source digests, exact semantic anchors, expected presence or absence, replacement counts, file state, dirty or staged scope, persisted workflow markers, domain-state queries, or other observable facts tied to pass applicability.",
                        "When strong revision identity is unavailable, insufficient, or irrelevant, approximate replay safety from narrower observable state rather than dropping replay protection entirely.",
                        "Prefer multiple independent guards when one signal does not describe the complete mutation state. A matching HEAD, for example, does not prove the absence or meaning of uncommitted working-tree changes.",
                        "Where the intended post-state can be recognized unambiguously, prefer the state machine `expected pre-state -> mutate`, `intended post-state -> no-op and prove`, `anything else -> fail closed`.",
                        "Do not force universal idempotence onto ambiguous partial mutations. If a partially applied state cannot be interpreted safely, stop before further mutation and construct a continuation or repair pass against the exact observed state.",
                        "Re-check a critical applicability signal immediately before a consequential write or external effect when meaningful drift could occur between preflight and execution.",
                        "Guard commits, pushes, deployments, deletions, messages, payments, and other externally observable or non-repeatable effects separately; replay-safe source mutation does not automatically make later effects replay-safe.",
                        "LRPs and manual snippet passes may include equivalent applicability or replay guards when useful. For automated ZMPs and BMPs, make such protection the default whenever accidental replay could duplicate, corrupt, or wrongly advance mutation state.",
                    ]
                )
            }

        case .conditionally_chain_stages:
            .init(
                title: "Condition later stages on earlier success",
                summary: #"""
                Dependent stages must not execute merely because they occur
                later in the same pasted command sequence.
                """#
            ) {
                list(
                    style: .unordered,
                    items: [
                        "Use `&&` or an equivalent explicit success gate where a later stage requires an earlier one to succeed.",
                        "Do not use unconditional `;` sequencing for mutation -> proof -> publication -> refresh -> deployment dependencies.",
                        "A failed parser, diff check, build, TestFlow, render, or output assertion must suppress dependent external effects.",
                        "Keep independent diagnostic or observational commands independent when suppressing them would hide useful evidence.",
                        "Use the smallest meaningful all-or-nothing boundary rather than turning unrelated work into one giant chain.",
                    ]
                )

                code(
                    language: "zsh",
                    content: #"""
                    { command_a || {
                        print -u2 -- "FAIL: stage A"
                        false
                    }; } &&

                    { command_b || {
                        print -u2 -- "FAIL: stage B"
                        false
                    }; }
                    """#
                )
            }

        case .surface_failure_stage:
            .init(
                title: "Surface the exact failed execution stage",
                summary: #"""
                Keep original diagnostics while naming the boundary that
                failed so recovery does not require trace hunting.
                """#
            ) {
                list(
                    style: .unordered,
                    items: [
                        "Useful labels include preflight, mutation, parse, diff check, build, TestFlow, render, generated-output assertion, commit, push, package refresh, and deployment.",
                        "When already inside a deliberately scoped function, `command || return 1` is sufficient when the stage is obvious.",
                        "Otherwise prefer a precise boundary such as `command || { print -u2 -- \"FAIL: WebComponents TestFlows\"; false; }`.",
                        "Do not replace the command's own output; add the stage label around it.",
                        "Do not use bare `|| 1`; it is not a shell status literal.",
                        "Do not wrap every trivial command. Add stage labels where distinguishing the failing boundary materially helps recovery.",
                    ]
                )
            }

        case .workflow_presentation:
            .init(
                title: "Present workflow state without making presentation a dependency",
                summary: #"""
                Use optional shell presentation hooks to distinguish sections,
                current execution steps, and result diagnostics while keeping
                the underlying workflow portable and semantically independent.
                """#
            ) {
                list(
                    style: .unordered,
                    items: [
                        "Use `workflow_section <title>` before a major command group or semantic section. It announces what is about to run; it does not report the result.",
                        "Use `workflow_step <kind> <title> [detail ...]` for individual execution progress. Use semantic kinds such as `run`, `ok`, `warn`, `fail`, and `info` rather than ANSI colors or presentation-specific values.",
                        "Use `workflow_diag <kind> <title> [detail ...]` for actual result diagnostics. Use semantic kinds such as `running`, `success`, `warning`, `failure`, and `info`.",
                        "Let the workflow functions own ANSI coloring, spacing, markers, and other terminal presentation. Do not duplicate ANSI escape sequences throughout generated mutation passes.",
                        "Do not pipe or replace the underlying command output through these functions. Compiler, build, TestFlow, renderer, git, and other command diagnostics should continue to stream normally.",
                        "Presentation is not execution semantics. Command exit status, assertions, and explicit conditional gates remain authoritative for whether later stages may execute.",
                        "Capability-detect each optional function in the active shell. In zsh, `$+functions[workflow_section]`, `$+functions[workflow_step]`, and `$+functions[workflow_diag]` provide compact checks without requiring environment mutation.",
                        "If a presentation function is unavailable or itself fails, fall back to a compact plain-text `print` rather than failing the workflow.",
                        "Do not copy or redefine the workflow presentation functions inside every generated pass. Use the environment implementation when present and degrade cleanly when absent.",
                        "Keep fallbacks semantically equivalent but visually simple. The portable pass should remain readable without ANSI support or custom shell configuration.",
                        "Use presentation at meaningful boundaries rather than wrapping every trivial command. The goal is distinguishable execution state, not terminal noise.",
                    ]
                )

                code(
                    language: "zsh",
                    content: #"""
                    (( $+functions[workflow_section] )) &&
                        workflow_section "Git diff validation" ||
                        print -- "=== Git diff validation ==="

                    (( $+functions[workflow_step] )) &&
                        workflow_step run "GPR · Guidelines publication" "publication scope check" ||
                        print -- "RUN: GPR · Guidelines publication — publication scope check"

                    if git diff --check; then
                        (( $+functions[workflow_diag] )) &&
                            workflow_diag success "Git diff validation" "No diff validation errors" ||
                            print -- "SUCCESS: Git diff validation — No diff validation errors"
                    else
                        (( $+functions[workflow_diag] )) &&
                            workflow_diag failure "Git diff validation" "git diff --check failed" ||
                            print -u2 -- "FAILURE: Git diff validation — git diff --check failed"

                        false
                    fi
                    """#
                )

                paragraph(
                    #"""
                    The compact `function && formatted || plain` presentation expression is intentional here: presentation failure itself is non-semantic, so falling back to plain output is preferable to blocking the actual workflow.
                    """#
                )
            }

        case .interactive_shell_paste_syntax:
            .init(
                title: "Do not depend on interactive comment parsing",
                summary: #"""
                Pasteable shell instructions must remain valid even when the
                interactive shell does not recognize hash-prefixed comments.
                """#
            ) {
                list(
                    style: .unordered,
                    items: [
                        "Do not rely on hash-prefixed comment lines in executable blocks pasted directly into an interactive shell. In zsh, whether they are comments depends on the INTERACTIVE_COMMENTS option.",
                        "Do not change the user's persistent shell options merely to make annotations parse.",
                        "Use the colon builtin for silent stage annotations and `print --` when a stage label should be visible.",
                        "A top-level annotation in a pasteable block must itself be valid executable syntax under the assumed interactive shell configuration.",
                        "Comments inside a bounded heredoc payload belong to the payload language and are unaffected by the interactive shell comment setting.",
                        "If the shell reports `command not found: #`, treat that as a transport-design failure and correct the pass rather than altering the user's shell configuration.",
                    ]
                )

                code(
                    language: "zsh",
                    content: #"""
                    : "Mutation stage"

                    command_a &&
                        command_b

                    print -- "=== Generated-output proof ==="

                    command_c
                    """#
                )
            }

        case .shell_parameter_safety:
            .init(
                title: "Do not use zsh special parameters as scratch variables",
                summary: #"""
                Variable naming in an interactive shell can have execution
                semantics. Generated zsh passes must not accidentally mutate
                shell state by assigning to special or tied parameters.
                """#
            ) {
                list(
                    style: .unordered,
                    items: [
                        "Before choosing temporary or loop variable names in zsh, account for special, reserved, and tied shell parameters rather than treating every identifier as an ordinary local variable.",
                        "In zsh, `path` is a special array tied directly to `$PATH`. Assigning filenames to `path` therefore rewrites the executable search path and can immediately make commands such as `rg`, `mkdir`, and `cat` unavailable.",
                        "Never use `path` as a scratch variable, loop variable, or generic pathname variable in a pasteable zsh pass. Prefer neutral names such as `file`, `entry`, `target`, `source_file`, or a domain-specific name.",
                        "Treat accidental assignment to a shell special parameter as session-state corruption even when the intended source mutation has not yet executed.",
                        "If a generated pass corrupts the interactive shell state this way, prefer restoring a clean shell with `exec zsh` before retrying rather than layering speculative repairs onto the damaged session.",
                        "Session-safety review therefore includes shell parameter names in addition to cwd, shell options, environment variables, traps, aliases, temporary functions, and other persistent execution state.",
                    ]
                )

                code(
                    language: "zsh",
                    content: #"""
                    files=(
                        "Sources/One.swift"
                        "Sources/Two.swift"
                    )

                    for file in "${files[@]}"; do
                        rg -n "pattern" "$file"
                    done
                    """#
                )
            }

        case .embedded_language_boundaries:
            .init(
                title: "Treat generated code as a sequence of language boundaries",
                summary: #"""
                When one language writes source for another language, reason
                explicitly about every representation and escaping boundary.
                """#
            ) {
                list(
                    style: .unordered,
                    items: [
                        "A mutation script that writes source containing another language crosses multiple parsers. Correct syntax in the mutation language does not guarantee correct destination source.",
                        "Reason about the exact destination text first, then encode that text correctly in the mutation language.",
                        "Prefer raw or otherwise low-escape string representations when they reduce ambiguity, but still inspect or assert the resulting destination source.",
                        "Do not add extra escaping merely because the destination text itself contains escape syntax. Over-escaping can produce valid mutation code that writes invalid source.",
                        "Be cautious with terminal backslash-newline continuations inside generated shell examples. A host string parser may consume the newline before the destination source is written.",
                        "Prefer continuation forms that survive representation boundaries cleanly, such as operators at line boundaries, structured argument arrays, or separate commands.",
                        "After a high-risk generated-source mutation, parse or build the destination language and inspect important rendered tokens or lines when practical.",
                    ]
                )

                code(
                    language: "text",
                    content: #"""
                    mutation language
                        |
                        v
                    destination source
                        |
                        v
                    embedded command or DSL
                        |
                        v
                    runtime interpretation

                    Validate the representation at each boundary.
                    """#
                )
            }

        case .transport_integrity:
            .init(
                title: "Do not let command transport become a failure mode",
                summary: #"""
                A pasteable workflow should remain easy to recognize as
                complete and should not depend on one enormous transport envelope.
                """#
            ) {
                list(
                    style: .unordered,
                    items: [
                        "Avoid very large outer heredocs, especially an outer shell heredoc containing additional heredocs.",
                        "Use heredocs for bounded payloads such as Python or source text, not merely to wrap an entire long workflow.",
                        "A prompt such as `heredoc>`, `dquote>`, `quote>`, or another continuation prompt means the shell is still waiting for syntactic completion. Do not proceed into consequential stages from that ambiguous state.",
                        "If a paste is truncated or a delimiter is missing, return to a fresh shell prompt and establish what actually executed before continuing.",
                        "If a workflow becomes long enough that truncation or delimiter mistakes become plausible, split it at a semantic dependency boundary.",
                        "Prefer path-scoped commands or a small subshell for session isolation over a giant outer heredoc.",
                        "Before commit, push, package refresh, deployment, or another externally consequential stage, begin that stage from a fresh shell prompt after the required earlier proof has visibly succeeded.",
                    ]
                )

                quote(
                    "Transport must not become part of the debugging problem."
                )
            }

        case .split_large_operations:
            .init(
                title: "Split large operations at meaningful dependency boundaries",
                summary: #"""
                Larger changes should become staged passes when separate domains
                have real proof or publication dependencies.
                """#
            ) {
                list(
                    style: .ordered,
                    items: [
                        "Identify which domain must exist and pass proof before another domain can safely consume it.",
                        "Keep tightly coupled edits together when their intermediate state is intentionally invalid.",
                        "Split downstream repositories, generated outputs, publication boundaries, or deployment work when an upstream failure should stop them.",
                        "Give each stage its own relevant preflight, mutation, parse or lint proof, build, TestFlows, and generated-output assertions.",
                        "Publish an upstream library only after its required proof succeeds.",
                        "Refresh or rebuild a downstream consumer only after the upstream publication succeeds.",
                        "When a later handoff or generated context should represent the completed operation, materialize it from the final resolved state rather than from an intermediate stage.",
                    ]
                )

                code(
                    language: "text",
                    content: #"""
                    Stage 1 - mutate upstream
                        preflight
                        mutate
                        parse
                        diff check
                        build

                    Stage 2 - publish upstream
                        fresh prompt
                        final proof gate
                        commit / push

                    Stage 3 - refresh downstream
                        fresh prompt
                        package refresh
                        rebuild
                        runtime/output proof
                    """#
                )
            }

        case .publication_scope:
            .init(
                title: "Verify publication scope before broad commit helpers",
                summary: #"""
                Before a helper stages or commits a broad working tree, verify
                that the repository contains only the changes intended for
                that publication boundary.
                """#
            ) {
                list(
                    style: .unordered,
                    items: [
                        "Treat a broad commit helper as an external-effect boundary even when the helper itself is familiar.",
                        "Inspect the current changed-file scope before invoking helpers that may stage the whole working tree.",
                        "When the intended mutation has a known file set, unexpected dirty or untracked paths should block publication until they are understood.",
                        "Do not make publication-scope checking unnecessarily brittle: the important invariant is that every change being committed is understood and belongs to the intended publication.",
                        "Run the final diff and whitespace checks before publication, not only before an earlier build.",
                        "If publication is blocked by unrelated work, preserve that work and surface the unexpected paths instead of staging around them implicitly.",
                    ]
                )

                quote(
                    "A successful build proves the source can build; it does not prove every dirty file belongs in the next commit."
                )
            }

        case .proof_and_convenience:
            .init(
                title: "Distinguish correctness proof from post-success convenience",
                summary: #"""
                A workflow should make clear which stages establish correctness
                and which stages merely prepare useful state for later work.
                """#
            ) {
                list(
                    style: .unordered,
                    items: [
                        "Parsing, linting, builds, TestFlows, renders, runtime checks, and requested output assertions are correctness proof when they establish the behavior being changed.",
                        "Context refreshes, pretty diffs, status summaries, cache warming, and similar handoff preparation are normally post-success conveniences.",
                        "A failed convenience stage must not retroactively describe a successfully proved and published source mutation as failed.",
                        "Report partial final outcomes precisely, for example: `source workflow succeeded; context refresh failed`.",
                        "A normally convenient stage becomes required when the user explicitly makes its output part of the requested deliverable or proof.",
                        "Do not weaken correctness gates merely because a later convenience stage is expected to run.",
                    ]
                )
            }

        case .pass_history_persistence:
            .init(
                title: "Persist pass execution state only in a user-designated history file",
                summary: #"""
                When the user provides or explicitly designates a pass-history
                file, maintain it as durable execution state so later
                interactions can recover what actually happened.
                """#
            ) {
                list(
                    style: .unordered,
                    items: [
                        "A pass-history target exists only when the user has supplied or explicitly designated one for the relevant project or workflow. If none was supplied, do not invent, infer, search for, create, or write a fallback history file.",
                        "Do not derive a history location from repository conventions, the current working directory, unrelated prior workflows, remembered paths, `.tasks`, filenames, or other ambient context. The target itself is user-provided execution context.",
                        "When a history file is designated, generated mutation passes should update that file as part of the pass itself rather than relying only on a conversational summary that disappears with chat context.",
                        "Record the actual resolved parameters that materially determined execution, not merely the intended operation. Depending on the pass, these can include repository and working scope, target files or ranges, expected heads or refs, mutation anchors, command flags and options, selected inputs, generated identifiers, versions, routes, or other domain-specific parameters.",
                        "Record results according to what actually occurred: successful mutations, meaningful no-op or unchanged outcomes, decisive proof commands and outcomes, publication commits or refs, pushes, package refreshes, deployments, generated artifacts, and other externally meaningful effects.",
                        "Append meaningful intermediate failures when they occur. Preserve the failure stage, relevant operation or command, decisive error or outcome, and the state left behind strongly enough that another interaction can safely determine what ran and what did not.",
                        "When a later repair or retry succeeds, append that repair and its result rather than rewriting or erasing the earlier failure. The history should preserve the execution sequence that produced the current state.",
                        "After a significant pass or publication boundary, record the current next step, remaining blocked work, or authoritative continuation point when one exists.",
                        "Make history entries concise but exact. Preserve values and outcomes needed for recovery; do not dump indiscriminate command output when a smaller structured record captures the same execution state.",
                        "Treat the history as cross-interaction recovery state: a fresh interaction given the designated file should be able to distinguish planned work from executed work, successful stages from failed or skipped stages, and the current authoritative continuation point.",
                        "If a designated history update is part of the workflow, do not claim durable handoff completeness when the required append did not occur.",
                    ]
                )
            }

        case .final_state_handoff:
            .init(
                title: "Generate handoff context from the final resolved state",
                summary: #"""
                Context intended for the next interaction should represent the
                completed dependency graph rather than an intermediate source state.
                """#
            ) {
                list(
                    style: .unordered,
                    items: [
                        "For library -> consumer workflows, finish the required upstream publication and downstream package refresh before generating final handoff context.",
                        "For generator -> generated-output workflows, generate and prove the output before refreshing context that is meant to describe the completed result.",
                        "For multi-repository SDPs, prefer one final context refresh after the last authoritative downstream stage instead of repeatedly materializing intermediate snapshots.",
                        "Generate intermediate context only when it has an independent debugging or review purpose.",
                        "The final handoff should make the next interaction start from the state the user can actually build, run, or inspect.",
                    ]
                )
            }

        case .context_refresh:
            .init(
                title: "Refresh designated Concatenation context after success",
                summary: #"""
                CR refreshes user-designated context directories after the
                authoritative mutation, proof, publication, and consumer
                refresh stages have completed.
                """#
            ) {
                paragraph(
                    #"""
                    Shorthand: CR - Context Refresh.
                    """#
                )

                list(
                    style: .ordered,
                    items: [
                        "Use only context directories explicitly supplied by the user or already established for the current workflow; do not guess additional directories.",
                        "Run the refresh after the final authoritative state has been reached.",
                        "Use the established standard command `con any -a -f xml` unless the context has explicitly different requirements.",
                        "Run each context directory in an isolated subshell or equivalent path-scoped execution so the user's parent working directory remains unchanged.",
                        "When several context directories are supplied, identify failures by directory rather than hiding them behind one generic refresh failure.",
                        "Treat CR as a post-success convenience unless fresh concatenation output is explicitly part of the requested proof or deliverable.",
                        "Because `-a` permits otherwise protected secret-bearing files to participate in local concatenation, refreshing a designated local context does not authorize printing, uploading, attaching, or otherwise exposing its generated contents.",
                    ]
                )

                code(
                    language: "zsh",
                    content: #"""
                    CONTEXT_DIR="$HOME/path/to/context"

                    (
                        cd "$CONTEXT_DIR" &&
                            con any -a -f xml
                    ) || {
                        print -u2 -- \
                            "FAIL: CR context refresh: $CONTEXT_DIR"
                        false
                    }
                    """#
                )
            }

        case .agentic_capability_manifest:
            .init(
                title: "Treat supplied Agentic capability manifests as authoritative",
                summary: #"""
                When an Agentic capability manifest is supplied, use it as the
                authoritative declaration of the local Agentic tool surface for
                that workspace and session.
                """#
            ) {
                list(
                    style: .unordered,
                    items: [
                        "Treat the tools, input schemas, and risk metadata declared by the supplied Agentic capability manifest as the authoritative local Agentic tool surface for that workspace and session.",
                        "Do not assume undeclared Agentic tools exist, and do not invent tool names, fields, enum cases, or capabilities that are absent from the manifest.",
                        "When a declared typed Agentic tool covers the required operation, prefer that tool over constructing an equivalent shell, subprocess, or ad-hoc command path.",
                        "Follow each declared input schema exactly. Use the Agentic preflight path before consequential mutation or other review-gated execution rather than treating tool availability as approval.",
                        "Treat Agentic preflight and invocation results as authoritative execution state. Update later reasoning from returned results rather than continuing from stale assumptions about repository, workspace, or mutation state.",
                        "Tool presence does not bypass risk, policy, approval, workspace, or execution boundaries. Respect the manifest's risk metadata and the runtime decision returned for the actual invocation.",
                        "Treat a capability manifest as a workspace- and session-scoped snapshot rather than a permanent hard-coded inventory. If a newer manifest is supplied, the newer declared surface supersedes older assumptions.",
                        "Before constructing calls for `agentic host bridge`, refresh or read the live capability manifest for the exact target workspace. Do not carry a manifest from another workspace forward merely because the same Agentic binary may expose a similar tool set.",
                        "Treat `agentic host bridge` as an I/O transport around the normal governed host invocation path, not as a second tool registry or execution authority. It must preserve the same workspace authorization, preflight, risk, approval, and runtime policy boundaries, and the returned host envelope is authoritative execution state.",
                        "When no Agentic capability manifest is supplied, do not assume a particular Agentic host or tool inventory is available merely because it existed in another session.",
                    ]
                )
            }

        case .agentic_tool_plans:
            .init(
                title: "Use Agentic tool plans for dependent typed workflows",
                summary: #"""
                When several typed Agentic operations form one dependency graph,
                express that dependency explicitly with an AgentToolPlan instead
                of manually advancing independent calls from stale assumptions.
                """#
            ) {
                list(
                    style: .unordered,
                    items: [
                        "Prefer an AgentToolPlan when multiple available typed Agentic calls have real execution dependencies. Keep AgentToolCall as the atomic leaf; orchestration belongs above calls rather than inside the call contract.",
                        "Use sequence nodes for ordered dependencies where a later call is eligible only after the previous stage succeeds. Use batch nodes only for genuinely independent siblings; do not encode a dependency-sensitive publication workflow as a batch merely because several calls are known in advance.",
                        "Put verification before publication. A normal mutation-and-publication chain should read as mutation -> build or targeted proof -> git_prepare_commit -> git_commit_prepared -> git_push, with each downstream publication step unreachable after a failed, denied, or otherwise non-successful prerequisite.",
                        "Do not preflight future mutating or state-sensitive leaves eagerly when earlier leaves may change repository or workspace state. Preflight each leaf when it becomes eligible so its review is based on current authoritative state.",
                        "A plan is orchestration, not blanket approval. Every reachable leaf must continue through its declared schema, workspace authorization, preflight, risk classification, policy decision, approval boundary, invocation, and receipt independently.",
                        "Use outcome-driven branches such as success, failure, and denial for deterministic continuation. Prefer semantic outcomes over arbitrary inspection of undocumented output JSON; add richer output-dependent conditions only through an explicit typed contract.",
                        "Treat AgentToolPlanResult records and tool-owned receipts as authoritative execution history for the plan. Record failed and skipped leaves explicitly rather than reasoning as though unexecuted dependent stages occurred.",
                        "When the host bridge accepts a bare AgentToolCall, a non-empty AgentToolCall array, or an AgentToolPlan, use the bare call for one atomic invocation, the array for independent sibling work, and an explicit plan for dependency-sensitive sequence or recursive branching.",
                        "Do not model Agentic orchestration with hidden process-global cwd mutation. Work inside a subdirectory of one authorized workspace should eventually be represented as explicit working-directory execution scope; moving to another repository changes the workspace authority boundary and must be represented as an explicit authorized workspace transition rather than a shell-style cd escape.",
                        "Cross-repository workflows should therefore preserve explicit scope at each stage: finish and publish work in one authorized repository, transition only to another authorized repository root, synchronize it through typed operations such as git_pull, verify its resulting state, and only then continue dependent work there.",
                    ]
                )
            }

        case .guidelines_publish_refresh:
            .init(
                title: "Use the Guidelines publish-refresh workflow",
                summary: #"""
                GPR publishes a proven Guidelines revision before refreshing
                and rebuilding its GuidelinesCLI consumer.
                """#
            ) {
                paragraph(
                    #"""
                    Shorthand: GPR - Guidelines Publish-Refresh.
                    """#
                )

                list(
                    style: .ordered,
                    items: [
                        "Mutate Guidelines and run targeted parse checks, `git diff --check`, and `swift build`.",
                        "Before publication, verify that the working-tree scope contains only understood changes intended for this Guidelines publication.",
                        "After that stage succeeds, begin the publication stage from a fresh shell prompt.",
                        "From the Guidelines repository run `gm commit \"<description>\" --push`.",
                        "After the push succeeds, begin the downstream refresh stage from a fresh shell prompt.",
                        "From GuidelinesCLI run `sbm pack -b` to refresh package sources and rebuild immediately.",
                        "For ordinary GuidelinesCLI work without an upstream package/source refresh, normal `sbm` remains sufficient.",
                        "When CR is requested for this workflow, run it only after `sbm pack -b` succeeds so the concatenated handoff represents both the published library and the refreshed consumer.",
                    ]
                )
            }
        }
    }
}
