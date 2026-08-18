public enum SourceOrganizationGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
    case focused_files

    public var content: GuidelineContent {
        switch self {
        case .focused_files:
            .init(
                title: "Prefer focused source files over monolithic files",
                summary: #"""
                Prefer organizing a subsystem as a directory of focused,
                purpose-named source files rather than allowing one source
                file to accumulate every construction in the subsystem.
                """#
            ) {
                paragraph(
                    #"""
                    Source files are useful organizational and navigational boundaries.
                    """#
                )

                paragraph(
                    #"""
                    When a subsystem contains multiple independently recognizable constructions, prefer giving those constructions focused files within a shared semantic directory rather than accumulating them into one increasingly monolithic source file.
                    """#
                )

                quote(
                    "A small dedicated source file is not a defect."
                )

                paragraph(
                    #"""
                    The directory may provide the broad subsystem context while individual filenames provide more precise addresses for its models, operations, helpers, extensions, adapters, conformances, and other implementation concerns.
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    casing/
                        casing.swift
                        separators.swift
                        scalar-kind.swift
                        classify-scalar.swift
                        tokenize-identifier.swift
                        json-encoder-casing.swift
                        json-decoder-casing.swift
                    """#
                )

                paragraph(
                    #"""
                    This preference is not a rule that every declaration requires its own file, nor is it a fixed maximum-line-count rule.
                    """#
                )

                paragraph(
                    #"""
                    Closely related code may remain contiguous when reading and changing it as one construction is clearer than scattering it across files. A substantial parser, state machine, or other genuinely cohesive implementation may reasonably remain in one file.
                    """#
                )

                paragraph(
                    #"""
                    The distinction is whether the file still represents one useful construction or whether it has become a container for many separately nameable concerns.
                    """#
                )

                section(
                    "Models and extensions"
                ) {
                    paragraph(
                        #"""
                        File boundaries may also be used to expose the shape of a type without forcing all of its implementation into the type's primary file.
                        """#
                    )

                    list(
                        style: .unordered,
                        items: [
                            "A basic model may keep its stored state, initializer, and central public surface together.",
                            "Implementation-only helpers or extension families may live in a sibling file when they form a coherent concern and their access requirements allow it.",
                            "A distinct public capability may live in a purpose-named extension file rather than continually enlarging the primary model file.",
                            "Several related extensions may remain together when they form one clear capability.",
                            "Do not manufacture extension files merely to make files artificially short.",
                        ]
                    )

                    code(
                        language: "text",
                        content: #"""
                        lead/
                            lead.swift
                            lead+normalization.swift
                            lead+validation.swift
                            lead+database.swift
                        """#
                    )

                    paragraph(
                        #"""
                        The exact split is contextual. The objective is that opening a file gives the reader a reasonably focused piece of the subsystem, while opening the directory reveals the larger composition.
                        """#
                    )
                }

                section(
                    "Prefer addressability over accumulation"
                ) {
                    paragraph(
                        #"""
                        As a subsystem grows, prefer creating another clearly named sibling file over repeatedly extending a general-purpose file whose name no longer describes everything inside it.
                        """#
                    )

                    paragraph(
                        #"""
                        A directory containing several short, obvious files is generally preferable to a thousand-line source file that requires searching and scrolling to discover unrelated constructions.
                        """#
                    )

                    paragraph(
                        #"""
                        Split by meaningful purpose rather than by arbitrary size. Preserve contiguity where it improves understanding; introduce file boundaries where they improve addressability, navigation, local reasoning, or ownership of a concern.
                        """#
                    )
                }
            }
        }
    }
}
