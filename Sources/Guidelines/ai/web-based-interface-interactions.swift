public enum WebInterfaceInteractionGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
    case provided_state
    case line_ranged_context
    case pasteable_shell_passes
    case testflows_by_default
    case execution_proof

    public var content: GuidelineContent {
        switch self {
        case .provided_state:
            .init(
                title: "Work from the state already provided",
                summary: #"""
                Treat supplied source context, concatenations, logs, diffs,
                screenshots, and command output as current working evidence.
                """#
            ) {
                list(
                    style: .unordered,
                    items: [
                        "Prefer the most recent supplied state when snapshots differ.",
                        "Inspect enough surrounding context to resolve the real path, symbol, build path, and representation before changing anything.",
                        "Do not invent paths, line ranges, symbols, commands, or project conventions that the supplied state does not support.",
                        "Do not ask the user to re-run a diagnostic whose answer is already visible in the interaction.",
                        "If state is sufficient, move directly to the requested change; if not, identify only the missing evidence.",
                        "Preserve repository and user-established conventions instead of replacing them with generic habits.",
                        "Return code and mutation passes inline unless downloadable artifacts are explicitly requested.",
                        "Honor requested delivery shape exactly; one requested block or file should not become a detached plan plus later mappings.",
                    ]
                )
            }

        case .line_ranged_context:
            .init(
                title: "Return line-ranged edits bottom-up per file",
                summary: #"""
                When concatenated context carries embedded paths and current
                line numbers, return exact edits that preserve those coordinates.
                """#
            ) {
                list(
                    style: .ordered,
                    items: [
                        "Group edits by filepath.",
                        "Keep exact current filepath, operation, and current line range or insertion line together with each snippet.",
                        "Within each file, order independent edits from the highest current line to the lowest so earlier pastes do not shift later coordinates.",
                        "Treat all stated ranges as coordinates in the supplied pre-edit snapshot.",
                        "Do not provide detached path/range mappings after the snippets.",
                        "When one file needs too many coordinated manual edits, prefer a complete current-file replacement and state its full current range.",
                        "For a new file, mark the operation as an addition rather than inventing a pre-existing range.",
                        "Preserve current indentation and local style unless the requested change intentionally changes them.",
                    ]
                )

                code(
                    language: "text",
                    content: #"""
                    File A
                        lines 220-238   replace
                        lines 104-111   replace
                        line 48         insert after

                    File B
                        lines 71-86     replace
                        lines 12-19     replace
                    """#
                )

                paragraph(
                    #"""
                    Different files do not need reverse ordering relative to one another. The bottom-up rule applies within each file.
                    """#
                )
            }

        case .pasteable_shell_passes:
            .init(
                title: "Provide pasteable shell passes without changing the user's session",
                summary: #"""
                For coordinated edits, prefer auditable pasteable shell
                passes that preserve the user's long-lived terminal state.
                """#
            ) {
                list(
                    style: .unordered,
                    items: [
                        "Default to zsh on macOS; use bash or another shell when the actual target environment requires it.",
                        "Prefer one pasteable block for one coherent mutation domain, but split larger dependency graphs into separately provable stages.",
                        "Do not leave cwd, shell options, environment variables, traps, aliases, temporary functions, or other execution state changed in the user's long-lived terminal.",
                        "For returned ZMPs and BMPs intended for interactive execution, wrap the entire executable pass in an outer subshell `( ... )` by default. Prefer path-scoped commands such as `git -C` and package-path options inside that boundary as well.",
                        "Inside the default ZMP/BMP subshell, explicit failure exits such as `exit 1` are safe because they terminate only the isolated pass. Do not place an explicit `exit` outside that isolation boundary in a block intended for an interactive terminal.",
                        "Do not rely on top-level hash-prefixed comments in executable paste blocks. Interactive zsh may have INTERACTIVE_COMMENTS disabled.",
                        "Use the colon builtin for silent annotations and `print --` for visible stage labels instead of changing the user's shell options.",
                        "When the environment provides `workflow_section`, `workflow_step`, or `workflow_diag`, use those optional hooks for structured section, progress, and result presentation.",
                        "Capability-detect optional workflow presentation functions at the call site and provide a compact plain-text fallback. Do not inline their implementations into every pass or make formatting availability a correctness dependency.",
                        "When a mutation language writes source containing shell, Swift, JSON, or another language, treat the destination as a separate escaping boundary and validate the resulting source.",
                        "Do not use a large outer heredoc merely as a transport or isolation envelope. A truncated paste can leave the terminal waiting at `heredoc>` and make execution state unnecessarily ambiguous.",
                        "Bounded heredocs remain useful for Python or source payloads. Keep their scope small, use unique delimiters, and place the closing delimiter visibly at the beginning of its line.",
                        "Use ordinary shell commands for simple work; use Python when exact multi-line replacement, structured transformation, or multi-file coordination is clearer.",
                        "For Python source mutations, prefer pathlib plus exact-match validation over loose global replacement.",
                        "Validate stable mutation assumptions before writing. For coordinated changes, calculate and validate all important replacements before committing any of them to disk when practical.",
                        "Use conditional execution for dependent stages so parse, build, test, publication, refresh, or deployment cannot run merely because it happens to appear later in the pasted text.",
                        "Keep mutations inspectable; do not hide source in encoded blobs merely to transport it.",
                        "Do not commit, push, rewrite history, deploy, or delete unrelated files unless explicitly requested.",
                    ]
                )

                code(
                    language: "zsh",
                    content: #"""
                    : "Mutation"

                    REPO="$HOME/path/to/repository" python3 <<'PY'
                    import os
                    from pathlib import Path

                    root = Path(os.environ["REPO"])
                    path = root / "Sources/Example.swift"
                    text = path.read_text()

                    old = "exact current source"
                    new = "exact replacement"

                    if text.count(old) != 1:
                        raise RuntimeError(
                            "Expected exactly one current source match."
                        )

                    changed = text.replace(
                        old,
                        new,
                        1,
                    )

                    path.write_text(changed)
                    PY

                    : "Proof"

                    swiftc -parse "$HOME/path/to/repository/Sources/Example.swift" &&
                        git -C "$HOME/path/to/repository" diff --check
                    """#
                )
            }

        case .testflows_by_default:
            .init(
                title: "Use TestFlows as the default Swift test harness",
                summary: #"""
                For Swift packages, default to dedicated TestFlows executable
                targets instead of XCTest, Swift Testing, or `swift test`.
                """#
            ) {
                list(
                    style: .unordered,
                    items: [
                        "Do not introduce XCTest, Swift Testing, or another framework-backed SwiftPM test target by default. Use such a system only when the repository already deliberately depends on it or the user explicitly requests it.",
                        "Use the TestFlows library as the default Swift testing mechanism. Expose tests through a dedicated executable target so flow orchestration, diagnostics, formatting, and exit behavior remain under repository control.",
                        "Avoiding XCTest and Swift Testing also avoids importing their testing machinery into CLI-oriented toolchains where it can conflict with or complicate use of the native Swift tool set.",
                        "When `swift package init` or another SwiftPM initializer creates a default `.testTarget(...)` and `Tests/` tree, normally remove both while shaping the package. Treat that generated testing scaffold as disposable unless there is an explicit reason to retain it.",
                        "For a library or executable package, typically place the flow executable target under `Sources/<PackageName>TestFlows/`, for example `Sources/AccountingTestFlows/` or `Sources/WritersTestFlows/`.",
                        "The TestFlows executable target should depend on the package surface it exercises and on the TestFlows library rather than importing XCTest or Swift Testing.",
                        "Expose the TestFlows target through a short executable product that is convenient to run repeatedly. For example, `AccountingTestFlows` uses `acctest`.",
                        "`WritersTestFlows` using `wtest` illustrates the lower bound on abbreviation: it is convenient, but a shorthand derived from only one leading letter is already prone to collision with another downstream package. Prefer a slightly more distinctive executable name when a short name could plausibly collide.",
                        "Keep TestFlow executable product names package-specific rather than generic names such as `test`, `tests`, or `testflows`; dependency graphs may contain several packages exposing their own flow executables.",
                        "Run the relevant flow directly, typically as `swift run <flow-bin> --verbose`, rather than invoking `swift test`.",
                        "Add or extend TestFlows when changed behavior has a meaningful executable proof boundary. Do not manufacture a flow for a trivial syntax-only change when parse or build proof is sufficient.",
                        "Dedicated Swift test executables are allowed when TestFlows cannot cleanly represent the required proof case, when using TestFlows would interfere with the behavior being exercised, or when the test needs to own a specialized execution environment that does not belong in the shared harness.",
                        "Treat a dedicated test executable as a deliberate exception rather than a second default testing architecture. Prefer TestFlows whenever it can express the proof without materially changing what is being tested.",
                        "A dedicated test binary may live under a package-specific target such as `Sources/GuidelinesTest/` and expose a short package-specific executable such as `guidetest`. It does not need a `TestFlows` suffix because it is not a TestFlows target.",
                        "Keep dedicated test executable names specific enough to avoid downstream product collisions, just as with TestFlows executables.",
                        "Preserve and restore tracked TestFlow run-state when executing a flow would otherwise create an unrelated working-tree diff.",
                    ]
                )

                code(
                    language: "text",
                    content: #"""
                    Typical package shape

                    Sources/
                        Accounting/
                        AccountingTestFlows/

                    Package products
                        AccountingTestFlows -> acctest

                    Another existing pattern
                        WritersTestFlows -> wtest

                    Deliberate dedicated-test exception
                        GuidelinesTest -> guidetest

                    Prefer:
                        short
                        memorable
                        package-specific
                        unlikely to collide downstream

                    Default proof
                        swift run <flow-bin> --verbose

                    Not the default
                        XCTest
                        Swift Testing
                        swift test
                    """#
                )

                quote(
                    "Test execution is an executable package capability, not a framework convention imposed by SwiftPM scaffolding."
                )
            }

        case .execution_proof:
            .init(
                title: "Prove changes through the real execution path",
                summary: #"""
                Verification should follow the repository's actual build,
                test, render, generation, and deployment model.
                """#
            ) {
                list(
                    style: .unordered,
                    items: [
                        "Use targeted syntax or parser checks before heavier proof when useful, then run git diff --check.",
                        "For a normal Swift library, use swift build unless that repository defines a more specific build workflow.",
                        "For an SBM-managed Swift binary, use sbm when proving the runnable binary because swift build alone does not update the installed executable.",
                        "For Swift package behavior covered by TestFlows, run the relevant flow executable, typically `swift run <flow-bin> --verbose`, when changed behavior has a flow or a new flow was added. TestFlows is the default testing path; do not substitute `swift test`, XCTest, or Swift Testing by habit.",
                        "When the repository deliberately uses a dedicated test executable because TestFlows cannot faithfully cover that proof boundary, run that executable through its real package product instead of forcing the case back into TestFlows.",
                        "Preserve and restore tracked TestFlow run-state when executing a flow would otherwise create an unrelated diff.",
                        "For generators and websites, run the project-specific generation command when the bug concerns generated output.",
                        "Inspect the generated HTML, JavaScript, CSS, JSON, routes, or artifacts for the exact property being fixed; compilation alone is not proof of generated behavior.",
                        "Prefer project-specific commands already supplied by the user over guessed generic substitutes.",
                        "Condition later stages on required earlier proof. A failed parse, build, TestFlow, render, or output assertion must prevent dependent publication, refresh, or deployment.",
                        "Surface important failures at the boundary where they occur while preserving the command's original diagnostics.",
                        "Use `command || return 1` inside an intentionally scoped function when the stage is already obvious, or add a precise message such as `command || { print -u2 -- \"FAIL: build Guidelines\"; false; }` when the failed boundary should be named.",
                        "Do not use a bare `|| 1`; in shell that attempts to execute a command named `1`. Propagate failure with a real shell status operation such as `false`, `return 1` in a function, or the surrounding conditional chain.",
                        "Do not sync, publish, push, or otherwise create external effects unless those are explicitly part of the requested workflow.",
                        "Finish with git diff --check and show the relevant final diff or status.",
                    ]
                )

                quote(
                    "Success means the intended behavior is observed at the real boundary, not merely that a command returned zero."
                )
            }
        }
    }
}
