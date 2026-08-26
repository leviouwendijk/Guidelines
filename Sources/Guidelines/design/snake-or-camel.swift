enum SnakeOrCamelGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
    case contextual_style

    var content: GuidelineContent {
        switch self {
        case .contextual_style:
            .init(
                title: "Choose camelCase or snake_case by context",
                summary: #"""
                Prefer Swift's usual camelCase by default, but allow
                snake_case when it materially improves call-site
                ergonomics, local regularity, internal distinction, or
                external-interface alignment.
                """#
            ) {
            paragraph(
                #"""
                As stated before, although camelCase is very swift-ly, we can prefer snake_case when:
                """#
            )

            list(
                style: .ordered,
                items: [
                    "it makes the call site more ergonomic, or look better",
                    "there is a local pattern we'd like to keep",
                    "the functions are more 'internal' facing (sometimes i then purposefully distinguish them in one file) -- but this does not mean that they cannot be public-facing",
                    "(important): it makes integration with other interfaces easier (we may desire snake case in Codable situations where we'd otherwise need to add an extra rawvalue string by hand). If we can avoid that, this improves alignment, homogeneity, and ergonomics.",
                ]
            )
            }
        }
    }
}
