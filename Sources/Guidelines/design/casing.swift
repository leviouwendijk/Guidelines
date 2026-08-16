public enum CasingGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
    case no_emoji
    case indentation
    case concise_symbols
    case nest_repeated_context
    case io_facing_casing

    public var content: GuidelineContent {
        switch self {
        case .no_emoji:
            .init(
                title: "Do not use emoji characters",
                summary: #"""
                Do not introduce emoji characters into source.
                """#
            ) {
            list(
                style: .unordered,
                items: [
                    "never input emoji characters",
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
            list(
                style: .unordered,
                items: [
                    "use 4 spaces for indentation",
                    "maintain relative indentation to source (not to violate it)",
                ]
            )
            }

        case .concise_symbols:
            .init(
                title: "Prefer concise symbols",
                summary: #"""
                Prefer short symbols that remain clear over longer
                symbols that repeat meaning already present in context.
                """#
            ) {
            list(
                style: .unordered,
                items: [
                    "prefer short symbols (that are still clear) over long ones:",
                ]
            )

            list(
                style: .unordered,
                items: [
                    "not:",
                ]
            )

            code(
                language: "swift",
                content: #"""
                isAnAllowedTypeToSend
                """#
            )

            list(
                style: .unordered,
                items: [
                    "but:",
                ]
            )

            code(
                language: "swift",
                content: #"""
                isAllowedType
                """#
            )
            }

        case .nest_repeated_context:
            .init(
                title: "Use nesting to carry repeated context",
                summary: #"""
                Use parent context and nesting when doing so makes child
                symbols shorter and clearer without creating unnecessary
                hierarchy.
                """#
            ) {
            list(
                style: .unordered,
                items: [
                    "most times in swift we make use of camelcase, but sometimes it doesn't look nice or type nice in APIs",
                ]
            )

            list(
                style: .unordered,
                items: [
                    "we therefore may prefer nesting (if we can without exhausting length) or, if really preferred, use snake_case locally instead",
                ]
            )

            list(
                style: .unordered,
                items: [
                    "we try to make user-facing APIs clear and descriptive, but not lengthy:",
                ]
            )

            list(
                style: .unordered,
                items: [
                    "instead of:",
                ]
            )

            code(
                language: "swift",
                content: #"""
                CostEstimator.estimateCost()
                """#
            )

            list(
                style: .unordered,
                items: [
                    "we tend to prefer",
                ]
            )

            code(
                language: "swift",
                content: #"""
                CostEstimator.estimate()
                """#
            )

            list(
                style: .unordered,
                items: [
                    "and sometimes where we have types:",
                ]
            )

            list(
                style: .unordered,
                items: [
                    "instead of:",
                ]
            )

            code(
                language: "swift",
                content: #"""
                CostEstimator.estimateTokens()
                """#
            )

            list(
                style: .unordered,
                items: [
                    "we prefer:",
                ]
            )

            code(
                language: "swift",
                content: #"""
                CostEstimator.estimate.tokens()
                """#
            )

            list(
                style: .unordered,
                items: [
                    "or, depending on what makes more sense:",
                ]
            )

            code(
                language: "swift",
                content: #"""
                CostEstimator.tokens.estimate()
                """#
            )

            list(
                style: .unordered,
                items: [
                    "or, if use remains clear:",
                ]
            )

            code(
                language: "swift",
                content: #"""
                CostEstimator.tokens()
                """#
            )

            paragraph(
                #"""
                since Estimator is already in parent symbol
                """#
            )

            list(
                style: .unordered,
                items: [
                    "some decision making for that:",
                ]
            )

            list(
                style: .unordered,
                items: [
                    "is there parental clarity, or should we introduce it to clean children symbols up?",
                ]
            )

            list(
                style: .unordered,
                items: [
                    "if we nest, which category makes more sense? which do we intuitively order and reason outward from, or alternatively: which do we have neighboring variants of that we can sort it by?",
                ]
            )

            list(
                style: .unordered,
                items: [
                    "meaning:",
                ]
            )

            code(
                language: "swift",
                content: #"""
                CostEstimator.tokens.input()
                CostEstimator.tokens.output()
                CostEstimator.tokens.reasoning()
                """#
            )

            list(
                style: .unordered,
                items: [
                    "only makes sense when there is something planned / a sibling for tokens",
                ]
            )

            list(
                style: .unordered,
                items: [
                    "otherwise we should probably do:",
                ]
            )

            code(
                language: "swift",
                content: #"""
                TokenCostEstimator.input()
                TokenCostEstimator.output()
                TokenCostEstimator.reasoning()
                """#
            )
            }

        case .io_facing_casing:
            .init(
                title: "Align IO-facing cases with external conventions",
                summary: #"""
                When an enum directly maps to an external representation,
                prefer case spelling that naturally aligns with that
                interface instead of redundant raw-value or CodingKey
                mappings.
                """#
            ) {
            paragraph(
                #"""
                For anything IO related, that we must convert, say, from Swift to JSON, or to another interface that requires snake_case conventions, we must try to design this preemptively with alignment.
                """#
            )

            paragraph(
                #"""
                Meaning we do not want to create elaborate codingkeys or string rawvalue where we can avoid it by simply aligning the symbol itself to the output format.
                """#
            )

            paragraph(
                #"""
                Example:
                """#
            )

            code(
                language: "swift",
                content: #"""
                public enum SomeSettingType: String, Sendable, Codable {
                    case settingParameter = "setting_parameter"
                    case settingParameterDeviating = "setting_parameter_deviating"
                    case alternativeSetting = "alt_setting"
                }
                """#
            )

            paragraph(
                #"""
                Is not to our liking. Instead we prefer:
                """#
            )

            code(
                language: "swift",
                content: #"""
                public enum SomeSettingType: String, Sendable, Codable {
                    case setting_parameter
                    case setting_parameter_deviating
                    case alt_setting
                }
                """#
            )

            paragraph(
                #"""
                So that we implicitly align with other interfaces without extra work that buys us little.
                """#
            )

            paragraph(
                #"""
                Note: this is somewhat superseded (in Server library) by allowing Primitives' Casing methods to be used as codingkeys.
                """#
            )
            }
        }
    }
}
