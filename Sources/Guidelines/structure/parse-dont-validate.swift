public extension Guideline {
    enum structure {}
}

public extension Guideline.structure {
    enum parse_dont_validate {
        public static let strong_result = Guideline(
            identifier: .init(
                section: StructureGuidelineSection.parse_dont_validate,
                number: 1
            ),
            title: "Successful parsing should become structural",
            content: """
            When successful interpretation establishes an invariant,
            prefer making that invariant structural in the returned value.
            """
        )
    }
}
