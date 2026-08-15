public enum Guidelines {
    public static func violation(
        _ guideline: Guideline,
        reasoning: String? = nil
    ) -> GuidelineViolation {
        .init(
            guideline,
            reasoning: reasoning
        )
    }

    public static func violation(
        _ guideline: Guideline,
        _ reasoning: () -> String
    ) -> GuidelineViolation {
        .init(
            guideline,
            reasoning: reasoning()
        )
    }
}

public func violation(
    _ guideline: Guideline,
    _ reasoning: () -> String
) -> GuidelineViolation {
    Guidelines.violation(
        guideline,
        reasoning
    )
}
