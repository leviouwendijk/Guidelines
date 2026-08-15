public enum Something:
    String,
    Sendable
{
    case string

    public var reference: String {
        rawValue
    }
}

public struct GuidelineViolationError:
    Error,
    Sendable,
    CustomStringConvertible
{
    public let guideline: Something
    public let reasoning: String?

    public init(
        _ guideline: Something,
        reasoning: String? = nil
    ) {
        self.guideline = guideline
        self.reasoning = reasoning
    }

    public var reference: String {
        guideline.reference
    }

    public var description: String {
        if let reasoning {
            "\(reference): \(reasoning)"
        } else {
            reference
        }
    }
}

public enum Guidelines {
    public static func violation(
        _ guideline: Something,
        reasoning: String? = nil
    ) -> GuidelineViolationError {
        .init(
            guideline,
            reasoning: reasoning
        )
    }
}

@attached(peer)
public macro GuidelineViolation(
    _ guideline: Something
) = #externalMacro(
    module: "GuidelinesMacros",
    type: "GuidelineViolationMacro"
)

@GuidelineViolation(.string)
public enum TypoType {
    case hello
}

public func throwConceptViolation() throws {
    throw Guidelines.violation(
        .string,
        reasoning: "This is the runtime form of the same guideline violation."
    )
}
