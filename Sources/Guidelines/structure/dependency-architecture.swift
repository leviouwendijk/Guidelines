public enum DependencyArchitectureGuideline: String, Sendable, Hashable, CaseIterable {
    case first_party_default
    case external_dependency_exception
    case full_dependency_cost
    case lightweight_owned_dependencies
    case owned_replacement_preference

    public var content: GuidelineContent {
        switch self {
        case .first_party_default:
            .init(
                title: "Prefer first-party dependencies by default",
                summary: #"""
                Prefer capabilities we own when a purpose-fit implementation is reasonably
                achievable; dependency ownership gives us control over API shape, build
                behavior, maintenance, and evolution.
                """#
            ) {
                paragraph(
                    #"""
                    When a reusable capability belongs naturally in our package ecosystem, first ask whether an existing first-party library already owns it. If not, and the capability is reasonably small or strategically important, prefer creating or extending a focused first-party library over immediately importing an external package.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "Search for an existing first-party capability before introducing a new dependency.",
                        "When the missing capability is modest and reusable, prefer implementing it once in a focused owned library rather than repeatedly outsourcing the boundary.",
                        "Keep owned dependency libraries purpose-fit so importing them does not drag unrelated runtime, policy, or transitive weight through the graph.",
                        "Treat ownership as stewardship of the repository and API, not as a requirement for local path dependencies; a first-party package may still be consumed from its canonical public repository.",
                        "Do not treat an available third-party package as the default answer merely because it already exists.",
                    ]
                )

                quote(
                    #"""
                    The preference for first-party dependencies is an architectural default, not a requirement to reimplement every difficult subsystem ourselves.
                    """#
                )
            }

        case .external_dependency_exception:
            .init(
                title: "External dependencies require explicit trust and disproportionate replacement cost",
                summary: #"""
                Admit an external dependency only from an explicitly trusted source and
                when owning the required capability would be materially more difficult or
                costly than carrying the dependency.
                """#
            ) {
                paragraph(
                    #"""
                    External code is an exception to the first-party default. The exception requires both a trust decision and a cost decision: the source must be one we are deliberately willing to depend on, and a first-party implementation must be unjustifiably difficult, risky, specialized, or expensive relative to the value of ownership.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "Trust the source explicitly; popularity, familiarity, or package availability alone does not establish trust.",
                        "Consider implementation difficulty, correctness risk, specialized expertise, maintenance burden, and delivery time when judging the cost of owning the capability.",
                        "Convenience alone is weak justification when the required surface is small and stable.",
                        "A substantial, specialized, or expensive implementation can justify a trusted external dependency even when first-party ownership would otherwise be preferable.",
                        "Record or preserve the reason for an exceptional dependency when the choice would not be obvious from the package itself.",
                    ]
                )

                example("Dependency admission is a two-part decision") {
                    code(
                        language: "text",
                        content: #"""
                        external dependency
                            requires
                                trusted source
                            and
                                disproportionate first-party implementation cost
                        """#
                    )
                }
            }

        case .full_dependency_cost:
            .init(
                title: "Count the full architectural cost of a dependency",
                summary: #"""
                Evaluate build, link, transitive, runtime, ownership, and maintenance cost;
                source-code size alone does not describe dependency weight.
                """#
            ) {
                paragraph(
                    #"""
                    Dependency choice affects more than implementation effort. A package that solves a small source-level problem can still impose disproportionate cost through build graph expansion, linker behavior, transitive products, runtime assumptions, or loss of control over the integration surface.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "compile-time and build-graph cost",
                        "linker behavior and product-shape constraints",
                        "transitive dependency weight",
                        "runtime and lifecycle behavior",
                        "API ownership and change control",
                        "release, availability, and repository continuity",
                        "maintenance and upgrade burden",
                    ]
                )

                paragraph(
                    #"""
                    Recurring build or linker friction is architectural evidence, not merely an incidental inconvenience. Apply the Boundary Adaptation dependency-cost rule as well when deciding whether a dependency should be imported into a native domain library or adapted farther outward.
                    """#
                )
            }

        case .lightweight_owned_dependencies:
            .init(
                title: "Keep shared first-party boundary libraries cheap to import",
                summary: #"""
                Libraries intended to provide shared protocols or integration vocabulary
                should remain lightweight enough to be imported by native library targets
                when a faithful direct conformance improves cohesion.
                """#
            ) {
                paragraph(
                    #"""
                    A first-party integration library earns broad reuse when its dependency cost stays small. Protocols such as lightweight parsing or conversion contracts may intentionally be imported into domain libraries when the conformance expresses meaning the native type already has.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "Keep the shared contract smaller than the applications that consume it.",
                        "Avoid coupling a tiny conformance protocol to terminal presentation, process lifecycle, networking, or other unrelated runtime behavior.",
                        "Allow native libraries to adopt the contract when the mapping is faithful and doing so removes mirror adapters or repeated retroactive conformances.",
                        "Do not force every domain library to import the dependency merely because direct conformance is allowed; import it where the native integration actually creates value.",
                    ]
                )

                paragraph(
                    #"""
                    This is the dependency-level counterpart of the Boundary Adaptation lightweight-native-conformance rule.
                    """#
                )
            }

        case .owned_replacement_preference:
            .init(
                title: "Prefer an owned replacement once it has earned the required surface",
                summary: #"""
                An existing external dependency is not permanent architecture; once a
                first-party replacement covers the required semantics and lowers the real
                dependency cost, prefer the owned surface.
                """#
            ) {
                paragraph(
                    #"""
                    Historical dependency choices should be reevaluated when our package ecosystem changes. If a first-party library now supplies the required behavior with a smaller or better-controlled integration surface, migrate toward it rather than keeping both systems through inertia.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "Preserve externally observable behavior that still matters during migration.",
                        "Do not keep parallel dependency systems merely because the old one is already present.",
                        "Do not rewrite for ownership alone when the first-party replacement is materially incomplete, less correct, or more costly.",
                        "Once the owned surface is sufficient, let it become canonical and remove compatibility scaffolding that no longer has a real consumer.",
                    ]
                )
            }
        }
    }
}
