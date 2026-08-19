public enum WebInterfaceInteractionGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
    case provided_state
    case line_ranged_context
    case pasteable_shell_passes
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
                For coordinated edits, prefer one auditable pasteable shell
                block. Default to zsh on macOS and isolate stateful work.
                """#
            ) {
                list(
                    style: .unordered,
                    items: [
                        "Default to zsh on macOS; use bash or another shell when the actual target environment requires it.",
                        "Prefer one pasteable block for one coherent pass.",
                        "Do not leave cwd, shell options, environment variables, traps, aliases, or temporary functions changed in the user's long-lived terminal.",
                        "When cd, set -e, traps, shell options, or temporary environment are useful, contain them in a child shell or equivalent isolated scope.",
                        "Do not place an explicit shell exit in a block intended for an interactive terminal.",
                        "Use ordinary shell commands for simple work; use Python when exact multi-line replacement, structured transformation, or multi-file coordination is clearer.",
                        "For Python source mutations, prefer pathlib plus exact-match validation over loose global replacement.",
                        "Validate expected files and replacement counts before writing whenever practical; unexpected state should fail closed instead of guessing.",
                        "Keep mutations inspectable; do not hide source in encoded blobs merely to transport it.",
                        "Do not commit, push, rewrite history, deploy, or delete unrelated files unless explicitly requested.",
                    ]
                )

                code(
                    language: "zsh",
                    content: #"""
                    zsh <<'ZSH'
                    set -e
                    cd ~/path/to/repository

                    python3 <<'PY'
                    from pathlib import Path

                    path = Path("Sources/Example.swift")
                    text = path.read_text()

                    old = "exact current source"
                    new = "exact replacement"

                    if text.count(old) != 1:
                        raise RuntimeError(
                            "Expected exactly one current source match."
                        )

                    path.write_text(text.replace(old, new, 1))
                    PY

                    swiftc -parse Sources/Example.swift
                    git diff --check
                    ZSH
                    """#
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
                        "In repositories that use TestFlows, run the relevant flow executable, typically swift run <flow-bin> --verbose, when changed behavior has a flow or a new flow was added; do not substitute swift test by habit.",
                        "Preserve and restore tracked TestFlow run-state when executing a flow would otherwise create an unrelated diff.",
                        "For generators and websites, run the project-specific generation command when the bug concerns generated output.",
                        "Inspect the generated HTML, JavaScript, CSS, JSON, routes, or artifacts for the exact property being fixed; compilation alone is not proof of generated behavior.",
                        "Prefer project-specific commands already supplied by the user over guessed generic substitutes.",
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
