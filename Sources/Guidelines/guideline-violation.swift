public struct GuidelineViolation:
    Error,
    Sendable,
    CustomStringConvertible,
    GuidelineReferencing
{
    public let guideline: Guideline
    public let reasoning: String?

    public init(
        _ guideline: Guideline,
        reasoning: String? = nil
    ) {
        self.guideline = guideline
        self.reasoning = reasoning
    }

    public var reference: String {
        guideline.reference
    }

    public var description: String {
        guard let reasoning else {
            return reference
        }

        return "\(reference): \(reasoning)"
    }
}
