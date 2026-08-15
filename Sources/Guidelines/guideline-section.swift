public protocol GuidelineSection:
    Sendable,
    GuidelineReferencing
{
    var area: GuidelineArea { get }
    var rawValue: String { get }
}

public extension GuidelineSection {
    var reference: String {
        rawValue
    }
}
