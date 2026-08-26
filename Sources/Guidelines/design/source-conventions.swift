public enum SourceConventionGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
    case no_emoji
    case indentation
    case vertical_layout
    case initializer_call_layout

    public var content: GuidelineContent {
        switch self {
        case .no_emoji:
            .init(
                title: "Do not use emoji characters",
                summary: #"""
                Do not introduce emoji characters into source.
                """#
            ) {
                paragraph(
                    #"""
                    Keep source text and generated code readable and searchable without depending on pictographic glyphs whose appearance, width, and interpretation can vary across terminals, fonts, and tooling.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "Use textual labels, ordinary symbols, and explicit words instead of emoji characters in source and generated code.",
                        "Do not use emoji as semantic markers in diagnostics, workflow output, identifiers, comments, fixtures, or generated examples when a textual representation communicates the same meaning.",
                    ]
                )
            }

        case .indentation:
            .init(
                title: "Preserve consistent indentation",
                summary: #"""
                Use four spaces for indentation and preserve the
                relative indentation of existing source.
                """#
            ) {
                paragraph(
                    #"""
                    Indentation should reveal the structural depth of the source without introducing incidental reformatting around an otherwise focused change.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "Use four spaces for each indentation level.",
                        "Preserve the relative indentation of existing source unless the change intentionally reformats the surrounding construction.",
                        "When moving or inserting code, align it to the structural level it actually belongs to rather than to the transport or patch representation used to edit it.",
                    ]
                )
            }

        case .vertical_layout:
            .init(
                title: "Use vertical space when it improves structural readability",
                summary: #"""
                Prefer compact layout while a shallow construction remains
                comfortably readable as one unit. Introduce vertical layout
                when width, complexity, or nesting creates real scanning
                pressure; line breaks should expose structure rather than
                mechanically expand syntax.
                """#
            ) {
                paragraph(
                    #"""
                    Vertical source layout is valuable when it makes meaningful structure easier to see. It is not valuable merely because a declaration, expression, or syntactic list can be split across several lines. Prefer the compact form while the complete construction can still be recognized comfortably as one unit, and make vertical space earn its keep by exposing useful boundaries.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "Keep one conformance, and usually a short list of familiar conformances such as `Sendable, Codable`, on the declaration line when the complete header remains comfortably readable.",
                        "The number of conformances or elements is a signal, not a mechanical threshold. A declaration containing several short and familiar conformances may still be clearer as one horizontal unit.",
                        "Treat horizontal width as increasing pressure toward vertical layout rather than as a hard cutoff. Roughly the 80-to-120-column region is a useful warning zone: as a construction approaches or exceeds that width, ask whether verticalization improves scanning.",
                        "Do not break a readable declaration merely to satisfy an arbitrary line-length number, but do not preserve a long horizontal form once width or element complexity makes its structure difficult to apprehend.",
                        "Verticalize sooner when individual elements are themselves long, generic, nested, constrained, labelled, or otherwise visually substantial.",
                        "Use vertical layout when several independently meaningful siblings benefit from being scanned as an inventory rather than decoded from one dense line.",
                        "Local regularity may justify choosing the same compact or vertical shape as nearby equivalent constructions when that consistency materially helps comparison.",
                        "Do not let local regularity turn every trivial construction into a multiline one. Consistency should support readability rather than replace judgment.",
                        "Avoid partial wrapping that leaves some siblings on the opening line and others stranded below it. Once a construction genuinely needs verticalization, commit to a deliberate vertical shape.",
                        "Line count is not itself evidence of readability. Expanding shallow syntax across several lines can make a simple construction harder to apprehend by separating tokens that naturally form one unit.",
                    ]
                )

                example("Keep shallow declarations compact") {
                    code(
                        language: "swift",
                        content: #"""
                        struct Configuration: Sendable {
                            let value: String
                        }

                        struct Payload: Sendable, Codable {
                            let value: String
                        }

                        enum State: String, Sendable, Codable {
                            case ready
                            case failed
                        }

                        public struct AgentToolCall: Sendable, Codable, Hashable, Identifiable {
                            // ...
                        }
                        """#
                    )

                    paragraph(
                        #"""
                        These declarations are structurally shallow. The conformance lists are short, familiar, and immediately recognizable, so splitting each conformance onto its own line would consume vertical space without revealing additional meaning.
                        """#
                    )
                }

                example("Verticalize when the declaration becomes substantial") {
                    code(
                        language: "swift",
                        content: #"""
                        public struct PreparedInvocation:
                            Sendable,
                            Codable,
                            Hashable,
                            Identifiable,
                            CustomStringConvertible,
                            SomeLongDomainSpecificProtocol
                        {
                            // ...
                        }
                        """#
                    )

                    paragraph(
                        #"""
                        Here the horizontal declaration would become visually dominant and increasingly difficult to scan. The vertical form exposes the conformance list as a set of siblings and gives each substantial element a stable visual position.
                        """#
                    )
                }

                example("Do not half-wrap") {
                    code(
                        language: "swift",
                        content: #"""
                        // Avoid.
                        struct Something: Sendable, Codable,
                            Hashable, Identifiable
                        {
                            // ...
                        }

                        // If vertical layout is actually needed, commit to it.
                        struct Something:
                            Sendable,
                            Codable,
                            Hashable,
                            Identifiable
                        {
                            // ...
                        }
                        """#
                    )
                }

                paragraph(
                    #"""
                    The general progression is therefore `compact while trivial -> vertical when structure needs help -> deliberate vertical organization once expanded`. Do not infer from a preference for readable vertical code that every syntax node should receive its own line.
                    """#
                )
            }

        case .initializer_call_layout:
            .init(
                title: "Give substantial calls and initializers a vertical argument shape",
                summary: #"""
                Let several meaningful arguments form a readable vertical
                inventory, while keeping simple calls and individual argument
                values locally compact. Make indentation correspond to actual
                nesting rather than introducing artificial depth beneath labels.
                """#
            ) {
                paragraph(
                    #"""
                    Calls and initializers deserve vertical layout earlier than shallow declarations. Several labelled arguments naturally behave like a small record: each input carries independent meaning and often benefits from a stable line of its own. This does not mean recursively putting every token on another line. The outer call may be vertical while each argument remains as compact as its own value allows.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "Keep zero-argument, one-argument, and simple two-argument calls compact when the complete expression remains immediately readable.",
                        "Prefer one argument per line once a call or initializer contains several meaningful labelled arguments, even when the horizontal form might technically fit within a nominal line-width limit.",
                        "Argument count establishes a bias rather than a law. A tiny positional call such as `Point3D(x, y, z)` may remain clearer inline, while one or two arguments containing substantial expressions may deserve vertical layout.",
                        "Nested substantial values lower the threshold for verticalization because their internal structure benefits from its own visual level.",
                        "Keep an argument label attached to the beginning of the expression it introduces whenever practical. Prefer `options: Options(` over placing `options:` on one line and `Options(` on a deeper line.",
                        "Do not create an indentation level merely to separate a label from its value. Indentation should correspond to actual syntactic or semantic nesting, not formatting ceremony.",
                        "Inside an otherwise vertical initializer, keep simple values on the same line as their labels. Prefer `outputStream: configuration.outputStream` over vertically separating the property expression from `outputStream:`.",
                        "Verticality applies recursively but not indiscriminately. Each nested construction should independently earn its own expansion.",
                        "Align a closing delimiter with the indentation level of the construct that opened it. A nested initializer should close at its own level, then the containing initializer should close at the containing level.",
                        "If a single argument value requires so much staircase indentation that its structure becomes difficult to follow, consider extracting that value into a meaningfully named local before constructing the outer value.",
                    ]
                )

                example("Keep simple calls compact") {
                    code(
                        language: "swift",
                        content: #"""
                        let state = State()
                        let request = Request(path: path)
                        let range = Range(start: start, end: end)
                        """#
                    )

                    paragraph(
                        #"""
                        A call does not become clearer merely because its parentheses can be expanded. One or two small arguments usually remain easier to recognize as a single expression.
                        """#
                    )
                }

                example("Use a vertical argument inventory for substantial initializers") {
                    code(
                        language: "swift",
                        content: #"""
                        let configuration = Configuration(
                            timeout: 30,
                            retryCount: 3,
                            cacheResponses: true
                        )
                        """#
                    )

                    paragraph(
                        #"""
                        The vertical form is preferable here even if the initializer could still be forced onto one line. The labels represent independently meaningful inputs and become easier to scan, compare, reorder, and modify when each receives a stable row.
                        """#
                    )
                }

                example("Keep labels attached to nested values") {
                    code(
                        language: "swift",
                        content: #"""
                        // Prefer.
                        let session = try TerminalSession(
                            options: TerminalSession.Options(
                                useAlternateScreen: false,
                                hideCursor: true,
                                useRawMode: true,
                                restoreOnInterrupt: true,
                                outputStream: outputStream
                            )
                        )

                        // Avoid.
                        let session = try TerminalSession(
                            options:
                                TerminalSession.Options(
                                    useAlternateScreen: false,
                                    hideCursor: true,
                                    useRawMode: true,
                                    restoreOnInterrupt: true,
                                    outputStream: outputStream
                                )
                        )
                        """#
                    )

                    paragraph(
                        #"""
                        In the avoided form, `options:` is only an argument label, yet the line break after it invents another apparent level of nesting. That extra indentation pushes the nested initializer farther right and leaves its closing delimiter visually displaced from the structural level at which the argument began. Keeping `options: TerminalSession.Options(` together makes the indentation tree correspond to the actual expression tree.
                        """#
                    )
                }

                example("Do not recursively verticalize simple argument values") {
                    code(
                        language: "swift",
                        content: #"""
                        // Prefer.
                        let options = Options(
                            mode: .automatic,
                            outputStream: configuration.outputStream,
                            selectedIndex: initialSelectionIndex(
                                in: results,
                                id: initialID
                            )
                        )

                        // Avoid.
                        let options = Options(
                            mode:
                                .automatic,
                            outputStream:
                                configuration.outputStream,
                            selectedIndex:
                                initialSelectionIndex(
                                    in: results,
                                    id: initialID
                                )
                        )
                        """#
                    )

                    paragraph(
                        #"""
                        The outer initializer is correctly vertical because its arguments are meaningful siblings. That does not justify giving `.automatic` or `configuration.outputStream` another indentation level. The nested `initialSelectionIndex(...)` call may expand because it has its own internal structure, but its label should still remain attached to the call it introduces.
                        """#
                    )
                }

                example("Let delimiters reveal the nesting tree") {
                    code(
                        language: "swift",
                        content: #"""
                        let value = Outer(
                            first: First(
                                one: 1,
                                two: 2
                            ),
                            second: Second(
                                three: 3,
                                four: 4
                            )
                        )
                        """#
                    )

                    paragraph(
                        #"""
                        Each opening initializer introduces one genuine nesting level, and each closing parenthesis returns to that same level. This makes the closing delimiters useful structural landmarks instead of producing a staircase of indentation created by formatting choices alone.
                        """#
                    )
                }

                example("Extract a genuinely substantial argument when useful") {
                    code(
                        language: "swift",
                        content: #"""
                        let predicate = source
                            .filter(isEligible)
                            .map(normalize)

                        let configuration = Configuration(
                            predicate: predicate,
                            mode: .automatic
                        )
                        """#
                    )

                    paragraph(
                        #"""
                        Do not extract every nested value merely to reduce indentation. Extraction is useful when the argument already represents an independently meaningful construction and naming it makes both the value and the containing initializer easier to understand.
                        """#
                    )
                }

                paragraph(
                    #"""
                    The two source-layout rules intentionally have different thresholds. Declarations stay compact relatively aggressively because short conformance and type lists are shallow syntax. Calls and initializers move vertical sooner because their arguments often carry independently meaningful labelled structure. In both cases, the governing question is whether the chosen layout exposes real structure without inventing visual complexity that the program does not have.
                    """#
                )
            }
        }
    }
}
