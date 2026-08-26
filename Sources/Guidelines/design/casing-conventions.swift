public enum CasingConventionGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
    case contextual_style
    case external_facing_names

    public var content: GuidelineContent {
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
                    Casing is contextual notation rather than an end in itself. Use Swift's ordinary camelCase as the default, then deviate only when another spelling makes the surrounding API materially easier to read, more internally regular, or more naturally aligned with a real boundary.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "Prefer camelCase for ordinary Swift values and functions unless another convention has a concrete readability or interoperability advantage.",
                        "Allow snake_case when it improves the shape of a tightly related local API or preserves a deliberate local pattern that would otherwise become visually irregular.",
                        "Internal-facing placement can lower the cost of a local casing exception, but being internal is not by itself a reason to use snake_case.",
                        "External representation is a strong reason to consider snake_case when direct spelling alignment removes redundant raw-value or coding-key ceremony.",
                        "Do not switch casing merely to make a symbol look unusual. The chosen form should make the symbol easier to recognize or integrate in its actual context.",
                        "Decide first whether a word boundary should remain visible; then use the casing convention appropriate to that context to represent it.",
                    ]
                )
            }

        case .external_facing_names:
            .init(
                title: "Align external-facing names with external conventions",
                summary: #"""
                When source names directly represent an external interface,
                prefer spelling that naturally aligns with that representation
                when doing so removes redundant mapping without harming the
                internal API.
                """#
            ) {
                paragraph(
                    #"""
                    Boundary-facing names should acknowledge the vocabulary they actually encode. When an enum case or similar symbol maps directly and mechanically to an external representation, matching that representation can be clearer than maintaining a parallel spelling plus repetitive raw values or coding keys.
                    """#
                )

                example("Avoid redundant one-to-one spelling maps") {
                    code(
                        language: "swift",
                        content: #"""
                        // Avoid when every case exists only to reproduce
                        // the same external snake_case spelling.
                        public enum SomeSettingType: String, Sendable, Codable {
                            case settingParameter = "setting_parameter"
                            case settingParameterDeviating = "setting_parameter_deviating"
                            case alternativeSetting = "alt_setting"
                        }

                        // Prefer when the enum is itself the boundary vocabulary.
                        public enum SomeSettingType: String, Sendable, Codable {
                            case setting_parameter
                            case setting_parameter_deviating
                            case alt_setting
                        }
                        """#
                    )
                }

                list(
                    style: .unordered,
                    items: [
                        "Use direct spelling alignment when the Swift symbol is intentionally modeling the external vocabulary itself.",
                        "Do not introduce raw-value or `CodingKey` mappings that merely duplicate an obvious one-to-one casing transformation without adding semantic value.",
                        "If a boundary already has a deliberate and reliable casing-conversion policy, keep the internal Swift vocabulary natural and let that boundary perform the transformation instead of duplicating external casing throughout domain code.",
                        "Do not force external spelling into unrelated internal APIs. Alignment belongs at the representation boundary or in types that intentionally model that boundary.",
                    ]
                )
            }
        }
    }
}
