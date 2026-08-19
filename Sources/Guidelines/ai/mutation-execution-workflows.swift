public enum MutationExecutionWorkflowGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
    case workflow_shorthand
    case preflight_before_writes
    case conditionally_chain_stages
    case surface_failure_stage
    case transport_integrity
    case split_large_operations
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
                        "ZMP - Zsh Mutation Pass: a pasteable, session-safe zsh mutation and proof pass for one coherent domain.",
                        "SDP - Staged Domain Pass: split a larger dependency graph into separately provable stages so downstream work cannot advance prematurely.",
                        "GPR - Guidelines Publish-Refresh: prove Guidelines, publish it with `gm commit \"<description>\" --push`, then refresh and rebuild GuidelinesCLI with `sbm pack -b`.",
                        "Requests such as `use an LRP`, `give me a ZMP`, `split this as an SDP`, and `finish with GPR` refer to these complete workflows.",
                    ]
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
                        "After that stage succeeds, begin the publication stage from a fresh shell prompt.",
                        "From the Guidelines repository run `gm commit \"<description>\" --push`.",
                        "After the push succeeds, begin the downstream refresh stage from a fresh shell prompt.",
                        "From GuidelinesCLI run `sbm pack -b` to refresh package sources and rebuild immediately.",
                        "For ordinary GuidelinesCLI work without an upstream package/source refresh, normal `sbm` remains sufficient.",
                    ]
                )
            }
        }
    }
}
