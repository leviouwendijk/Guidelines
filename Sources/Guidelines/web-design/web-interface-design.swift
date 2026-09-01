public enum WebDesignGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
    case semantics_and_accessibility
    case keyboard_and_focus
    case forms_and_input
    case motion
    case content_and_media
    case navigation_and_state
    case responsive_platform_behavior
    case performance_and_copy

    public var content: GuidelineContent {
        switch self {
        case .semantics_and_accessibility:
            .init(
                title: "Prefer semantic, accessible browser contracts",
                summary: #"""
                Use native web semantics first, and expose enough accessible identity
                that meaning does not depend on visual presentation alone.
                """#
            ) {
                list(
                    style: .unordered,
                    items: [
                        "Use buttons for actions and links for navigation so keyboard, focus, opening, copying, and browser-history behavior remain native.",
                        "Prefer semantic elements such as main, nav, label, table, fieldset, headings, lists, and media elements before reproducing their behavior with generic containers or ARIA.",
                        "Give form controls and icon-only controls accessible names; prefer associated visible labels where the interface benefits from them.",
                        "Give meaningful images useful alternative text and explicitly mark decorative images or icons as decorative.",
                        "Expose asynchronous validation and status updates through an appropriate live region when they would otherwise be silent.",
                        "Keep heading hierarchy meaningful and provide a skip path to primary content when repeated navigation precedes it.",
                    ]
                )
            }

        case .keyboard_and_focus:
            .init(
                title: "Keep interaction keyboard-operable and focus visible",
                summary: #"""
                Every ordinary interaction should remain operable without a pointer
                and preserve a visible, unobscured focus location.
                """#
            ) {
                list(
                    style: .unordered,
                    items: [
                        "Prefer native interactive elements so keyboard behavior is inherited rather than manually reconstructed.",
                        "Provide an evident focus-visible state and never remove the browser outline without an effective replacement.",
                        "Prefer focus-visible over unconditional focus styling when pointer focus should not receive the same treatment as keyboard focus.",
                        "Use focus-within when a compound control needs to communicate focus held by one of its descendants.",
                        "Sticky headers, footers, drawers, sheets, and overlays must not cover the currently focused element.",
                        "Custom keyboard handlers supplement missing semantics; do not add redundant handlers merely to satisfy an implementation pattern.",
                    ]
                )
            }

        case .forms_and_input:
            .init(
                title: "Make forms explicit, permissive, and recoverable",
                summary: #"""
                Forms should communicate field meaning to users and browsers,
                preserve ordinary editing behavior, and make failures actionable.
                """#
            ) {
                list(
                    style: .unordered,
                    items: [
                        "Associate every control with a clickable label and give submitted controls meaningful names.",
                        "Choose input type, input mode, autocomplete, and spellchecking behavior from the value actually being entered.",
                        "Do not block paste, selection, zoom, or ordinary text-editing behavior without a compelling interaction requirement.",
                        "Treat placeholders as examples or hints rather than replacements for labels.",
                        "Keep submit actions available until submission actually begins; then expose progress and prevent accidental duplicates as appropriate.",
                        "Place validation errors beside the affected field, explain the useful corrective action, and focus the first relevant error when submission cannot continue.",
                        "Warn before abandoning meaningful unsaved changes when navigation would otherwise discard them.",
                    ]
                )
            }

        case .motion:
            .init(
                title: "Make motion optional, efficient, and interruptible",
                summary: #"""
                Motion should support comprehension without overriding user
                preference, trapping interaction, or imposing unnecessary rendering work.
                """#
            ) {
                list(
                    style: .unordered,
                    items: [
                        "Honor reduced-motion preferences by removing or substantially reducing non-essential motion.",
                        "Prefer transform and opacity when they can express animation without repeated layout work.",
                        "Transition only the properties intentionally animated; do not use blanket transition-all behavior.",
                        "Set transform origins deliberately, including for transformed SVG groups.",
                        "Animations must respond to new user input rather than forcing users to wait for an earlier transition to finish.",
                        "Persistent autoplay motion needs a pause, stop, hide, or still alternative unless the motion itself is essential.",
                    ]
                )
            }

        case .content_and_media:
            .init(
                title: "Design for real content and stable media",
                summary: #"""
                Interface structure should remain valid across empty, long, translated,
                and user-authored content while media loads without destabilizing layout.
                """#
            ) {
                list(
                    style: .unordered,
                    items: [
                        "Handle empty strings, empty collections, missing optional content, and loading states deliberately.",
                        "Test short, typical, very long, translated, and unbroken user-authored content rather than only nominal fixtures.",
                        "Wrap, truncate, or clamp text according to information hierarchy; do not silently remove essential information.",
                        "Allow flex and grid children to shrink where wrapping or truncation requires it instead of creating accidental horizontal overflow.",
                        "Reserve image and media geometry through intrinsic dimensions or an equivalent aspect-ratio contract to avoid unnecessary layout shift.",
                        "Defer non-critical below-the-fold media and prioritize truly critical above-the-fold media rather than loading everything eagerly.",
                        "Prefer efficient video over animated GIF for continuous motion and provide a still representation when motion is non-essential.",
                    ]
                )
            }

        case .navigation_and_state:
            .init(
                title: "Make navigational state addressable and recoverable",
                summary: #"""
                State that represents a location, selection, or shareable view should
                participate in browser navigation rather than exist only in ephemeral memory.
                """#
            ) {
                list(
                    style: .unordered,
                    items: [
                        "Represent navigation with links so modifier-click, new-tab opening, destination copying, and browser history remain available.",
                        "Put filters, tabs, pagination, expanded views, and similar shareable state in the URL when that state meaningfully identifies what the user is viewing.",
                        "Design stateful views so refreshing or deep-linking reproduces the intended view whenever practical.",
                        "Destructive actions require a recovery boundary such as explicit confirmation or a meaningful undo window.",
                    ]
                )
            }

        case .responsive_platform_behavior:
            .init(
                title: "Respect responsive, touch, theme, and locale behavior",
                summary: #"""
                Use browser and platform capabilities before hardcoded assumptions
                about layout, input device, appearance, geography, or formatting.
                """#
            ) {
                list(
                    style: .unordered,
                    items: [
                        "Use flex, grid, intrinsic sizing, and responsive CSS before introducing JavaScript measurement as a layout dependency.",
                        "Account for device safe-area insets when content or controls extend to viewport edges and deliberately contain overscroll inside modal surfaces.",
                        "Provide tap or click and keyboard alternatives for drag, swipe, pinch, or path gestures unless the gesture itself is essential.",
                        "Avoid autofocus on mobile and use it sparingly elsewhere; set touch-action and tap-highlight behavior intentionally rather than disabling browser behavior indiscriminately.",
                        "Declare the active color scheme and ensure native controls remain readable under custom themes.",
                        "Format dates, times, numbers, percentages, and currencies with locale-aware formatters; resolve language from user or browser preference rather than IP geography.",
                        "Mark brand names, code tokens, and identifiers as non-translatable when automatic translation would corrupt their meaning.",
                    ]
                )
            }

        case .performance_and_copy:
            .init(
                title: "Keep interfaces efficient and interaction copy specific",
                summary: #"""
                Prefer measured structural performance and precise interface language
                over framework folklore, arbitrary thresholds, or generic labels.
                """#
            ) {
                list(
                    style: .unordered,
                    items: [
                        "Virtualize, paginate, defer, or otherwise constrain large rendered collections when measured rendering cost warrants it; do not treat an arbitrary item count as a universal threshold.",
                        "Avoid repeated layout reads in render paths and batch DOM reads and writes instead of interleaving them.",
                        "Keep per-keystroke work small and use resource hints such as preconnect or preload only when criticality justifies their connection and bandwidth cost.",
                        "Prefer active, direct language and specific action labels over generic controls such as Continue when the actual operation can be named.",
                        "Error messages should state both the problem and the useful next action when correction is possible.",
                        "Use conventional typographic punctuation, ellipses for genuinely ongoing states, and tabular numerals where changing numeric values need stable alignment.",
                        "Give hover, active, focus, selected, disabled, loading, success, and error states enough distinction to communicate the current interaction state; do not hide essential behavior behind hover alone.",
                    ]
                )
            }
        }
    }
}
