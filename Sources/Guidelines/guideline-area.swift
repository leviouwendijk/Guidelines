public enum GuidelineArea:
    String,
    Sendable,
    Hashable,
    CaseIterable,
    GuidelineReferencing
{
    case design
    case ergonomics
    case structure

    public var reference: String {
        rawValue
    }
}
