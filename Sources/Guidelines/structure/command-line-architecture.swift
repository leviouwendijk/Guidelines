public enum CommandLineArchitectureGuideline: String, Sendable, Hashable, CaseIterable {
    case arguments_default
    case native_argument_values
    case declaration_style_choice
    case root_command_topology
    case thin_command_router
    case parsed_options_boundary
    case runner_execution
    case source_layout
    case swiftpm_cli_identity

    public var content: GuidelineContent {
        switch self {
        case .arguments_default:
            .init(
                title: "Use Arguments as the default Swift CLI dependency",
                summary: #"""
                Use the first-party Arguments library for Swift command-line parsing by
                default; do not introduce swift-argument-parser when Arguments covers the
                required behavior.
                """#
            ) {
                paragraph(
                    #"""
                    Arguments is the canonical lightweight CLI parsing dependency in our Swift package ecosystem. It replaces the historical default of swift-argument-parser for our own packages and is intentionally cheap enough to participate in library-level integrations as well as executable targets.
                    """#
                )

                paragraph(
                    #"""
                    One reason for the replacement is architectural rather than stylistic: importing swift-argument-parser through library dependencies created linker and product-graph friction in real packages. Arguments keeps the parsing contract intentionally smaller so library code can adopt the pieces it genuinely needs without inheriting the same integration cost.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "Prefer Arguments for new Swift CLIs.",
                        "Do not introduce swift-argument-parser by default merely because older packages used it.",
                        "Treat linker or build-graph friction caused by a parser dependency as part of its architectural cost.",
                        "When existing swift-argument-parser code is touched substantially and Arguments covers its required semantics, prefer migrating to Arguments rather than extending the older dependency surface.",
                        "Use an external parser only as an explicit dependency exception when Arguments lacks a required capability and the replacement cost is justified under Dependency Architecture.",
                    ]
                )

                paragraph(
                    #"""
                    The purpose of the replacement is not only parser syntax. A lightweight owned contract lets argument-facing conformances live near native values when that is the most cohesive boundary.
                    """#
                )
            }

        case .native_argument_values:
            .init(
                title: "Let native values conform to ArgumentValue when the mapping is faithful",
                summary: #"""
                Prefer one canonical domain value with a lightweight ArgumentValue
                conformance over CLI-only mirror enums, duplicate conversion tables, or
                unnecessary retroactive conformances.
                """#
            ) {
                paragraph(
                    #"""
                    Arguments is deliberately lightweight enough that a native library may import it when argument parsing is a faithful capability of an existing value. This is a concrete application of the Boundary Adaptation lightweight-native-conformance rule.
                    """#
                )

                paragraph(
                    #"""
                    Under the older swift-argument-parser boundary, ExpressibleByArgument integration often pushed us toward a CLI-only mirror enum for a value that already existed, or toward an @retroactive conformance with its associated warning and ownership noise. ArgumentValue should normally remove that ceremony when the native value already has exactly the accepted command-line meaning.
                    """#
                )

                example("Keep one canonical value") {
                    code(
                        language: "swift",
                        content: #"""
                        import Arguments

                        public enum OutputFormat:
                            String,
                            Sendable,
                            Codable,
                            ArgumentValue
                        {
                            case text
                            case json
                        }
                        """#
                    )
                }

                example("Avoid a mirror CLI enum when it adds no meaning") {
                    code(
                        language: "swift",
                        content: #"""
                        // Avoid.
                        enum OutputFormatArgument: String, ArgumentValue {
                            case text
                            case json

                            var outputFormat: OutputFormat {
                                switch self {
                                case .text:
                                    .text
                                case .json:
                                    .json
                                }
                            }
                        }
                        """#
                    )
                }

                list(
                    style: .unordered,
                    items: [
                        "Keep the conformance native when CLI spelling and domain meaning are genuinely the same.",
                        "Do not create a second enum merely to reproduce cases that already exist in the domain.",
                        "Avoid @retroactive conformance when the type and lightweight integration protocol are both under our control and native conformance is the clearer ownership boundary.",
                        "If CLI parsing introduces aliases, policy, contextual defaults, or representation that is not intrinsic to the domain value, keep that adaptation in the CLI options boundary instead of distorting the native type.",
                    ]
                )
            }

        case .declaration_style_choice:
            .init(
                title: "Support both Arguments declaration styles",
                summary: #"""
                The Arguments DSL and the typed conformance-based API are both valid;
                choose the representation that makes the command surface clearest.
                """#
            ) {
                paragraph(
                    #"""
                    Arguments intentionally exposes both a builder DSL and typed command, group, and parsed-option conformances. Do not make either syntax mandatory for every CLI.
                    """#
                )

                example("Both forms are legitimate") {
                    code(
                        language: "swift",
                        content: #"""
                        // Compact or dynamic DSL.
                        let spec = try cmd("render") {
                            opt(
                                "format",
                                as: String.self
                            )
                            flag("verbose")
                        }

                        // Typed command architecture.
                        enum RenderCommand: ParsedArgumentCommand {
                            typealias Options = RenderCommandOptions

                            static let name = "render"
                        }
                        """#
                    )
                }

                paragraph(
                    #"""
                    For a substantive shipped CLI, prefer the typed conformance-based structure exemplified by Capture because command topology, raw argument declaration, semantic parsing, and execution each gain an explicit source boundary. The DSL remains a good choice for compact specifications, dynamic composition, tests, or places where a separate type hierarchy would add ceremony without structure.
                    """#
                )
            }

        case .root_command_topology:
            .init(
                title: "Let the root command own CLI topology",
                summary: #"""
                The root ArgumentCommand owns the binary command identity, child topology,
                default routing, program entry, and top-level error policy rather than
                command execution.
                """#
            ) {
                example("Capture-style root command") {
                    code(
                        language: "swift",
                        content: #"""
                        import Arguments

                        @main
                        enum CaptureCLICommand: ArgumentCommand {
                            static let name = "capturer"
                            static let defaultChild = HelpCommand.self

                            static let children: [ArgumentCommandType] = [
                                HelpCommand.self,
                                DevicesCommand.self,
                                RecordCommand.self,
                                SourcesCommand.self,
                            ]

                            static func main() async {
                                await ArgumentProgram.main(
                                    command: Self.self,
                                    errorHandler: { error in
                                        CaptureCLI.writeError(
                                            error
                                        )

                                        return 1
                                    }
                                )
                            }
                        }
                        """#
                    )
                }

                list(
                    style: .unordered,
                    items: [
                        "Declare the root command name and child command graph in one obvious place.",
                        "Keep the top-level ArgumentProgram lifecycle and error policy at the root.",
                        "Use a default child when the product has a meaningful default route.",
                        "Do not accumulate leaf-command orchestration or domain execution in the root merely because it is the @main type.",
                    ]
                )
            }

        case .thin_command_router:
            .init(
                title: "Keep parsed command conformances thin",
                summary: #"""
                A ParsedArgumentCommand should identify the route, bind its Options type,
                and delegate non-trivial execution rather than becoming a mixed parser and
                operation object.
                """#
            ) {
                example("Command as a small routing boundary") {
                    code(
                        language: "swift",
                        content: #"""
                        import Arguments

                        enum VideoCommand: ParsedArgumentCommand {
                            typealias Options =
                                VideoCommandOptions

                            static let name = "video"

                            static func run(
                                _ options: VideoCommandOptions,
                                invocation: ParsedInvocation
                            ) async throws {
                                try await VideoCommandRunner.run(
                                    options
                                )
                            }
                        }
                        """#
                    )
                }

                paragraph(
                    #"""
                    Small commands may execute directly when delegation would add no useful boundary. Once parsing declarations and operational work begin to compete for the same file, keep the command type declarative and move the operation behind a runner or reusable domain API.
                    """#
                )
            }

        case .parsed_options_boundary:
            .init(
                title: "Parse raw CLI payloads into semantic options before execution",
                summary: #"""
                Use ArgumentParsed to keep argument wrappers and raw CLI shape at the
                boundary, then hand stronger semantic options to execution.
                """#
            ) {
                paragraph(
                    #"""
                    A useful Capture-style Options type separates the argument payload from the values the operation should actually consume. The nested ArgumentGroup describes command-line spelling and defaults; init(arguments:) resolves that payload into semantic fields.
                    """#
                )

                example("Separate payload declaration from semantic options") {
                    code(
                        language: "swift",
                        content: #"""
                        import Arguments

                        struct VideoCommandOptions:
                            Sendable,
                            ArgumentParsed
                        {
                            typealias ArgumentPayload = Payload

                            let output: URL
                            let durationSeconds: Int?

                            init(
                                arguments: Payload
                            ) throws {
                                output =
                                    try arguments.output.url()

                                durationSeconds =
                                    try arguments.duration.optional()
                            }

                            struct Payload: ArgumentGroup {
                                @Group("output")
                                var output: CaptureOutputOptions

                                @Group("duration")
                                var duration: CaptureDurationOptions
                            }
                        }
                        """#
                    )
                }

                list(
                    style: .unordered,
                    items: [
                        "Keep property-wrapper declarations and CLI spelling in the payload rather than leaking them through operational code.",
                        "Resolve paths, identifiers, modes, and grouped CLI input into stronger semantic values before the runner begins effects.",
                        "Reuse nested ArgumentGroup types for coherent option clusters rather than flattening every concern into one root payload.",
                        "Apply Parse Don't Validate: successful option construction should establish the invariants downstream execution relies on.",
                    ]
                )
            }

        case .runner_execution:
            .init(
                title: "Keep non-trivial command execution in runners or domain operations",
                summary: #"""
                Let command types route parsed input while runners or reusable domain APIs
                own orchestration, effects, and operation-specific control flow.
                """#
            ) {
                example("Runner owns the operation") {
                    code(
                        language: "swift",
                        content: #"""
                        enum RecordCommandRunner {
                            static func run(
                                _ options: RecordCommandOptions
                            ) async throws {
                                let provider =
                                    MacCaptureDeviceProvider()

                                let configuration =
                                    try await resolveConfiguration(
                                        options,
                                        provider: provider
                                    )

                                try await record(
                                    configuration
                                )
                            }
                        }
                        """#
                    )
                }

                list(
                    style: .unordered,
                    items: [
                        "Use the runner for CLI-specific orchestration that is too substantial for the command declaration.",
                        "Call reusable library operations from the runner rather than reproducing domain behavior in the CLI target.",
                        "Keep presentation and process-exit policy at appropriate CLI boundaries instead of pushing them into the library operation.",
                        "Do not create a runner for a trivial one-line command when the extra type adds no durable meaning.",
                    ]
                )
            }

        case .source_layout:
            .init(
                title: "Organize substantial CLI targets by command role",
                summary: #"""
                For non-trivial CLIs, use a stable <Package>CLI source target with explicit
                command, option, runner, and shared CLI-helper boundaries as they earn
                meaning.
                """#
            ) {
                example("Preferred substantial CLI layout") {
                    code(
                        language: "text",
                        content: #"""
                        Sources/<Package>CLI/
                            <package>-main.swift

                            commands/
                                cmd-<command>.swift

                            options/
                                opts-<command>.swift

                            runners/
                                run-<command>.swift

                            cli/
                                ... shared CLI-only helpers when needed
                        """#
                    )
                }

                list(
                    style: .unordered,
                    items: [
                        "Keep the root command easy to find at the target root.",
                        "Place command route declarations under commands/ once there are enough commands for the distinction to help navigation.",
                        "Place ArgumentParsed and reusable ArgumentGroup declarations under options/ when they form a meaningful parsing boundary.",
                        "Place substantial CLI orchestration under runners/.",
                        "Use cli/ for shared CLI-only support that is neither a command, option model, nor runner.",
                        "Do not create empty directories or force this decomposition on a tiny executable; introduce each boundary when the code has earned it.",
                    ]
                )
            }

        case .swiftpm_cli_identity:
            .init(
                title: "Separate the SwiftPM CLI target from the invoked binary product",
                summary: #"""
                By default, name the executable target <Package>CLI and let its source path
                be Sources/<Package>CLI/, while the executable product carries the
                lowercase user-facing binary name.
                """#
            ) {
                paragraph(
                    #"""
                    The SwiftPM target names the source module; the executable product names what the user invokes. Keep those identities distinct instead of renaming the source target to match the command-line spelling.
                    """#
                )

                example("Capture package relationship") {
                    code(
                        language: "swift",
                        content: #"""
                        let package = Package(
                            name: "Capture",
                            products: [
                                .library(
                                    name: "Capture",
                                    targets: [
                                        "Capture",
                                    ]
                                ),
                                .executable(
                                    name: "capturer",
                                    targets: [
                                        "CaptureCLI",
                                    ]
                                ),
                            ],
                            dependencies: [
                                .package(
                                    url: "https://github.com/leviouwendijk/Arguments.git",
                                    branch: "master"
                                ),
                            ],
                            targets: [
                                .target(
                                    name: "Capture",
                                    dependencies: [
                                        .product(
                                            name: "Arguments",
                                            package: "Arguments"
                                        ),
                                    ]
                                ),
                                .executableTarget(
                                    name: "CaptureCLI",
                                    dependencies: [
                                        "Capture",
                                        .product(
                                            name: "Arguments",
                                            package: "Arguments"
                                        ),
                                    ]
                                ),
                            ]
                        )
                        """#
                    )
                }

                list(
                    style: .unordered,
                    items: [
                        "Use <Package>CLI as the default executable target name.",
                        "Let SwiftPM resolve that target from Sources/<Package>CLI/ by convention; do not add an explicit path when the conventional path is used.",
                        "Use the lowercase invocable command name for the executable product, which may intentionally differ from the target name.",
                        "Make the executable product target <Package>CLI rather than creating a target whose name merely duplicates the binary product.",
                        "Only make the library target depend on Arguments when native library values or APIs actually use its lightweight contracts; otherwise keep Arguments confined to the CLI target.",
                    ]
                )
            }
        }
    }
}
