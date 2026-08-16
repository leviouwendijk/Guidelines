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
                title: "Keep local option symbols compact but readable",
                summary: #"""
                Within well-scoped option values, prefer compact names when
                context already carries the meaning, but use separators
                when compacting would destroy readability.
                """#
            ) {
            paragraph(
                #"""
                Example 1:
                """#
            )

            code(
                language: "swift",
                content: #"""
                // Good: compact compound stays readable.
                let filepath = "/Users/levi/Documents/notes.md"
                
                // Unnecessary: the separator adds ceremony without adding much clarity.
                let filePath = "/Users/levi/Documents/notes.md"
                let file_path = "/Users/levi/Documents/notes.md"
                
                // Bad: compacting too many words destroys the shape of the phrase.
                let someoptionalthing: String? = nil
                
                // Better: the separator earns its keep here.
                let someOptionalThing: String? = nil
                let some_optional_thing: String? = nil
                
                // We may want to shorten or nest there though, consdidering what is best.
                struct OptionalThing: Sendable {
                    let some: String? = nil
                }
                
                // or:
                
                struct OptionalThings: Sendable {
                    let string: String? = nil
                }
                
                // of course also applying similarly to interior scope parameters (structures and funcs)
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
