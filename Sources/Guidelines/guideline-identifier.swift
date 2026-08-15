public struct GuidelineIdentifier:
    Sendable,
    Hashable,
    Comparable,
    GuidelineReferencing
{
    public let section: any GuidelineSection
    public let number: UInt16

    public init(
        section: some GuidelineSection,
        number: UInt16
    ) {
        self.section = section
        self.number = number
    }

    public var area: GuidelineArea {
        section.area
    }

    public var reference: String {
        [
            area.reference,
            section.reference,
            Self.reference(
                number: number
            ),
        ]
        .joined(separator: ".")
    }

    public static func == (
        lhs: Self,
        rhs: Self
    ) -> Bool {
        lhs.area == rhs.area &&
        lhs.section.reference == rhs.section.reference &&
        lhs.number == rhs.number
    }

    public func hash(
        into hasher: inout Hasher
    ) {
        hasher.combine(area)
        hasher.combine(section.reference)
        hasher.combine(number)
    }

    public static func < (
        lhs: Self,
        rhs: Self
    ) -> Bool {
        if lhs.area.reference != rhs.area.reference {
            return lhs.area.reference < rhs.area.reference
        }

        if lhs.section.reference != rhs.section.reference {
            return lhs.section.reference < rhs.section.reference
        }

        return lhs.number < rhs.number
    }

    private static func reference(
        number: UInt16
    ) -> String {
        let value = String(number)

        guard value.count < 3 else {
            return value
        }

        return String(
            repeating: "0",
            count: 3 - value.count
        ) + value
    }
}
