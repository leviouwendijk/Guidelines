public enum OptionClusteringGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
    case cluster_large_options
    case compact_local_symbols
    case nest_related_options
    case keep_reusable_types_independent

    public var content: GuidelineContent {
        switch self {
        case .cluster_large_options:
            .init(
                title: "Cluster large option families",
                summary: #"""
                When argument groups become numerous or excessively long,
                cluster related options into coherent values rather than
                letting one flat signature absorb every concern.
                """#
            ) {
            paragraph(
                #"""
                To of course prevent from overloading argument signatures (as well as making them more easy to pass around), we will use option clusters where arguments exceed normal numbers or become too lengthy.
                """#
            )

            paragraph(
                #"""
                Ideally we keep things flat of course, to prevent unnecessary nest-inits, but you then may run into situations where an option cluster looks like this:
                """#
            )

            code(
                language: "swift",
                content: #"""
                import Writers
                
                public struct ExhaustiveFlatConcatenationRenderOptions: Sendable {
                    public let concatenationRenderDelimiterPresentationStyle: DelimiterStyle
                    public let concatenationRenderShouldIncludeDelimiterClosureMarker: Bool
                
                    public let concatenationRenderMaximumNumberOfLinesAllowedPerFile: Int?
                    public let concatenationRenderShouldTrimBlankLinesFromLineOutput: Bool
                    public let concatenationRenderShouldIncludeLineNumbersInLineOutput: Bool
                
                    public let concatenationRenderShouldEmitRawOutputWithoutFormatting: Bool
                    public let concatenationRenderShouldUseRelativeFilePathsInOutput: Bool
                    public let concatenationRenderShouldIncludeFileModifiedTimestampInOutput: Bool
                    public let concatenationRenderStringObscurationReplacementMapForOutput: [String: String]
                
                    public init(
                        concatenationRenderDelimiterPresentationStyle: DelimiterStyle = .boxed,
                        concatenationRenderShouldIncludeDelimiterClosureMarker: Bool = false,
                        concatenationRenderMaximumNumberOfLinesAllowedPerFile: Int? = 10_000,
                        concatenationRenderShouldTrimBlankLinesFromLineOutput: Bool = true,
                        concatenationRenderShouldIncludeLineNumbersInLineOutput: Bool = false,
                        concatenationRenderShouldEmitRawOutputWithoutFormatting: Bool = false,
                        concatenationRenderShouldUseRelativeFilePathsInOutput: Bool = true,
                        concatenationRenderShouldIncludeFileModifiedTimestampInOutput: Bool = false,
                        concatenationRenderStringObscurationReplacementMapForOutput: [String: String] = [:]
                    ) {
                        self.concatenationRenderDelimiterPresentationStyle = concatenationRenderDelimiterPresentationStyle
                        self.concatenationRenderShouldIncludeDelimiterClosureMarker = concatenationRenderShouldIncludeDelimiterClosureMarker
                        self.concatenationRenderMaximumNumberOfLinesAllowedPerFile = concatenationRenderMaximumNumberOfLinesAllowedPerFile
                        self.concatenationRenderShouldTrimBlankLinesFromLineOutput = concatenationRenderShouldTrimBlankLinesFromLineOutput
                        self.concatenationRenderShouldIncludeLineNumbersInLineOutput = concatenationRenderShouldIncludeLineNumbersInLineOutput
                        self.concatenationRenderShouldEmitRawOutputWithoutFormatting = concatenationRenderShouldEmitRawOutputWithoutFormatting
                        self.concatenationRenderShouldUseRelativeFilePathsInOutput = concatenationRenderShouldUseRelativeFilePathsInOutput
                        self.concatenationRenderShouldIncludeFileModifiedTimestampInOutput = concatenationRenderShouldIncludeFileModifiedTimestampInOutput
                        self.concatenationRenderStringObscurationReplacementMapForOutput = concatenationRenderStringObscurationReplacementMapForOutput
                    }
                }
                """#
            )

            paragraph(
                #"""
                Which should be avoided at all times: that is very bad design.
                """#
            )

            paragraph(
                #"""
                There are two parts we want to do instead:
                """#
            )

            list(
                style: .ordered,
                items: [
                    "simplify symbols: if we can avoid both snake and camel case (usually from nesting) then we should do so. That keeps things simple. Use this sparingly, we don't want to make things unreadable.",
                    "use nesting as previously specified, to reduce the weight of parameter symbols",
                ]
            )
            }

        case .compact_local_symbols:
            .init(
                title: "Compact symbols when word boundaries remain obvious",
                summary: #"""
                Prefer compact compound symbols when a small number of short
                words remain immediately readable as one unit. Preserve an
                explicit word boundary when fusion creates visual, syllabic,
                or interpretive ambiguity, and consider semantic nesting before
                accepting increasingly long compound symbols.
                """#
            ) {
                paragraph(
                    #"""
                    Compactness is useful when removing a casing boundary does not make the reader reconstruct it. The question is therefore not simply whether a symbol contains two words, but whether those words remain immediately recoverable after fusion.
                    """#
                )

                paragraph(
                    #"""
                    Two short words are the strongest candidates for compaction. Familiar compounds are especially safe, but familiarity is not an absolute requirement: a novel compound can still work when its shape and pronunciation expose the intended boundary naturally. Conversely, even two individually simple words should remain separated when their junction becomes visually or linguistically ambiguous.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "Prefer compact forms when the compound contains only a small number of short constituents and can be recognized immediately without consciously locating the hidden boundary.",
                        "Treat familiar lexical compounds as especially strong candidates for compaction. `filepath` is easier to accept than a similarly sized but unfamiliar compound because the reader already recognizes the combined concept.",
                        "Inspect the junction between the words. Repeated letters such as the `r|r` in `userrole`, `letterrunner`, or `errorreport`, the `n|n` in `tokenname`, and the `t|t` in `requesttype` obscure the boundary and usually justify preserving it explicitly.",
                        "Visual collisions need not use the same letter. A junction such as the `t|f` in `outputformat` can be mildly harder to segment because the adjacent shapes compete visually. This is a softer signal, not an automatic rejection.",
                        "Consider syllabic parsing as well as character shape. `modeladapter` has a clean `l|a` junction on paper, but can initially be parsed as something like `modela...`, forcing the reader to decipher the intended `model | adapter` split. If the fused spelling invites a plausible wrong segmentation, preserve the boundary.",
                        "Word count and syllabic weight matter independently. Two short words such as `filepath` or `rootpath` can remain light; three or more words increasingly benefit from explicit casing, shortening, or semantic nesting.",
                        "Do not optimize each member in isolation when it belongs to a tightly related family. If one otherwise acceptable compact symbol avoids becoming the lone camel-cased outlier in an intentionally compact structure, consistency may justify the compact spelling. A form such as `tokenbudget` can therefore be preferable in context even when it is less established than `filepath`.",
                        "Consistency does not rescue a genuinely difficult spelling. A family of compact symbols should not force an unreadable member merely to maintain visual uniformity.",
                        "When compaction no longer works, preserve the word boundary using the casing convention appropriate to that context. This guideline decides whether fusion is readable; casing conventions decide how the visible boundary should be represented.",
                        "Before allowing a symbol to grow into a long sequence of explicit word boundaries, consider whether repeated context belongs in semantic nesting instead. Prefer nesting when it creates meaningful ownership or grouping, not merely as a mechanical way to shorten a name.",
                        "These considerations apply to local properties, parameters, functions, option values, and similar interior symbols. Public API does not automatically forbid compact forms; assess the same readability and context signals. PascalCase type names may naturally expose boundaries that would be less obvious in lowercase spelling.",
                    ]
                )

                example("Compact compounds") {
                    code(
                        language: "swift",
                        content: #"""
                        // Strong compact forms: two short words with
                        // immediately recoverable boundaries.
                        let filepath = "/Users/levi/Documents/notes.md"
                        let rootpath = "/srv/application"

                        // The reverse compound can still remain readable
                        // when its boundary is easy to recover.
                        let pathfile = "notes.md"

                        // A novel compound can also be acceptable when the
                        // surrounding symbol family favors compact spelling
                        // and this form remains effortless to segment.
                        let tokenbudget = 4_096
                        """#
                    )
                }

                example("Boundary collisions") {
                    code(
                        language: "swift",
                        content: #"""
                        // The hidden boundary itself becomes troublesome.
                        let userrole = role
                        let letterrunner = runner
                        let errorreport = report
                        let tokenname = name
                        let requesttype = type

                        // Preserve the boundary instead.
                        let userRole = role
                        let letterRunner = runner
                        let errorReport = report
                        let tokenName = name
                        let requestType = type
                        """#
                    )

                    paragraph(
                        #"""
                        These forms are not rejected because two-word compounds are inherently bad. They are difficult because the final character of the first word collides with the first character of the second, making the hidden boundary slower to recover. `userrole`, for example, is close to acceptable but still introduces enough friction that the explicit boundary is usually preferable.
                        """#
                    )
                }

                example("Syllabic and visual ambiguity") {
                    code(
                        language: "swift",
                        content: #"""
                        // The letters technically permit fusion, but the
                        // reader can initially discover the wrong internal shape.
                        let modeladapter = adapter

                        // Better.
                        let modelAdapter = adapter

                        // This remains fairly readable, but the t|f junction
                        // makes the boundary somewhat less effortless.
                        let outputformat = format

                        // Either may be preferable depending on surrounding style.
                        let outputFormat = format
                        """#
                    )

                    paragraph(
                        #"""
                        Character count alone does not predict readability. `modeladapter` is difficult partly because its additional syllabic weight allows the eye and inner voice to begin grouping it incorrectly, as though the word began `modela...` rather than `model | adapter`. `outputformat` is much more recoverable, although its `t|f` junction introduces slight visual friction because the adjacent letter shapes compete. These are judgment signals rather than a mechanical character-pair blacklist.
                        """#
                    )
                }

                example("Escalate from fusion to casing to structure") {
                    code(
                        language: "swift",
                        content: #"""
                        // Bad: the phrase has lost its internal shape.
                        let someoptionalthing: String? = nil

                        // Better when this genuinely needs to remain one symbol.
                        let someOptionalThing: String? = nil

                        // Depending on the surrounding casing convention,
                        // an explicit boundary may take another form.
                        let some_optional_thing: String? = nil

                        // But a long compound can also indicate that some
                        // context belongs in structure instead of the symbol.
                        struct OptionalThing: Sendable {
                            let some: String?
                        }

                        struct OptionalThings: Sendable {
                            let string: String?
                        }
                        """#
                    )

                    paragraph(
                        #"""
                        The progression is not `always compact, otherwise camelCase`. First ask whether the compact spelling remains effortless. If not, expose the word boundary using the casing convention appropriate to the surrounding context. If that produces a heavy multi-word symbol, ask whether part of the phrase represents reusable context that would read better as a parent accessor, nested value, or other semantic grouping.
                        """#
                    )
                }

                example("Prefer semantic paths over very long operation names") {
                    code(
                        language: "swift",
                        content: #"""
                        // Increasingly heavy: several semantic clauses are
                        // being serialized into one identifier.
                        collectLinesWithIndices()

                        // Prefer a path like this when lines and indices are
                        // real, reusable semantic stages of the API.
                        collect.lines.indices()
                        """#
                    )

                    paragraph(
                        #"""
                        Nesting is not merely another spelling separator. It changes the API structure and should therefore be used only when the intermediate components represent meaningful context or ownership. When they do, a semantic access path can be substantially easier to read than repeatedly encoding the same structure into a long camel-cased symbol.
                        """#
                    )
                }

                paragraph(
                    #"""
                    The practical decision order is therefore: first ask whether a small compound can fuse without requiring re-segmentation; then inspect the visual junction, syllabic reading, familiarity, and consistency with neighboring symbols. If fusion introduces friction, preserve the boundary. If preserving several boundaries produces a heavy symbol, consider shortening or meaningful nesting before accepting the longer spelling.
                    """#
                )
            }

        case .nest_related_options:
            .init(
                title: "Nest related option groups instead of repeating prefixes",
                summary: #"""
                Group related option concerns into shallow nested option
                values so callers and declarations avoid repeating long
                contextual prefixes.
                """#
            ) {
            paragraph(
                #"""
                Example 2:
                """#
            )

            paragraph(
                #"""
                The previous bad example can be refactored to look more like this:
                """#
            )

            code(
                language: "swift",
                content: #"""
                import Writers
                
                public struct DelimiterOptions: Sendable {
                    public let style: DelimiterStyle
                    public let closure: Bool
                
                    public init(
                        style: DelimiterStyle = .boxed,
                        closure: Bool = false
                    ) {
                        self.style = style
                        self.closure = closure
                    }
                }
                
                public struct LineOptions: Sendable {
                    public let filemax: Int?
                    public let trimblanks: Bool
                    public let numbers: Bool
                
                    public init(
                        filemax: Int? = 10_000,
                        trimblanks: Bool = true,
                        numbers: Bool = false
                    ) {
                        self.filemax = filemax
                        self.trimblanks = trimblanks
                        self.numbers = numbers
                    }
                }
                
                public struct OutputOptions: Sendable {
                    public let raw: Bool
                    public let relativepaths: Bool
                    public let modifiedstamp: Bool
                    public let obscurations: [String: String]
                
                    public init(
                        raw: Bool = false,
                        relativepaths: Bool = true,
                        modifiedstamp: Bool = false,
                        obscurations: [String: String] = [:]
                    ) {
                        self.raw = raw
                        self.relativepaths = relativepaths
                        self.modifiedstamp = modifiedstamp
                        self.obscurations = obscurations
                    }
                }
                
                public struct ConcatenationRenderOptions: Sendable {
                    public let delimiter: DelimiterOptions
                    public let line: LineOptions
                    public let output: OutputOptions
                
                    public init(
                        delimiter: DelimiterOptions = .init(),
                        line: LineOptions = .init(),
                        output: OutputOptions = .init()
                    ) {
                        self.delimiter = delimiter
                        self.line = line
                        self.output = output
                    }
                }
                """#
            )

            paragraph(
                #"""
                That incorporates both methods nicely. Any more without snake or camel and we'd either consider nesting (typically  worse the deeper the nesting becomes) or consider adding snake or camel case.
                """#
            )
            }

        case .keep_reusable_types_independent:
            .init(
                title: "Do not over-nest reusable public types",
                summary: #"""
                Short nested types are suitable for local option
                components, but reusable library structs and enums should
                keep sufficiently descriptive, independently reusable
                names.
                """#
            ) {
            paragraph(
                #"""
                Important: we don't necessariliy apply this short insistence on (particularly LIBRARY) structs the way we do on parameters, because structs can be global / public-facing. Meaning we'd want to avoid using excessively short symbols, or too much nesting, since in strut / enum symbols this doesn't buy us a lot.
                """#
            )

            paragraph(
                #"""
                Avoid:
                """#
            )

            code(
                language: "swift",
                content: #"""
                public enum Edit {}
                
                extension Edit {
                    public struct Thing {...}
                }
                """#
            )

            code(
                language: "swift",
                content: #"""
                public enum StandardEdit {} // or something else :
                public enum WritableEdit {}
                public enum LibEdit {}
                public enum WritersEdit {}
                
                // and then we may also want to sometimes just do sibling level component structures:
                
                public struct StandardThing {...}
                public struct StandardThingComponent {...}
                public struct EditableThing {...}
                public struct StandardEditThing {...}
                
                // which continues the pattern
                """#
            )

            paragraph(
                #"""
                More so that we prefer not nesting structures when that type may be reused by other types.
                """#
            )

            paragraph(
                #"""
                Local-only sub-structures (like Option structs) can be short-named sub-structures that do not need global referencing.
                """#
            )
            }
        }
    }
}
