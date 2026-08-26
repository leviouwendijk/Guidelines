public enum OperationAbstractionGuideline: String, Sendable, Hashable, CaseIterable {
    case follow_real_convergence

    public var content: GuidelineContent {
        switch self {
        case .follow_real_convergence:
            .init(
                title: "Let operation abstractions follow real domain convergence",
                summary: #"""
                Introduce microscopic generic operation abstractions only when several
                real domains fit naturally without contorting their native APIs.
                """#
            ) {
                paragraph(
                    #"""
                    Small generic operation abstractions can be useful when several real domains already share the same semantic shape. The abstraction should describe that convergence rather than force unrelated domains into symmetry.
                    """#
                )

                example("Start with the smallest plausible abstraction") {
                    code(
                        language: "swift",
                        content: #"""
                        public protocol Operation: Sendable {
                            associatedtype Input: Sendable
                            associatedtype Output: Sendable

                            func run(
                                _ input: Input
                            ) async throws -> Output
                        }
                        """#
                    )

                    code(
                        language: "swift",
                        content: #"""
                        public protocol PlannedOperation: Sendable {
                            associatedtype Input: Sendable
                            associatedtype Plan: Sendable
                            associatedtype Output: Sendable

                            func plan(
                                _ input: Input
                            ) async throws -> Plan

                            func run(
                                _ plan: Plan
                            ) async throws -> Output
                        }
                        """#
                    )
                }

                paragraph(
                    #"""
                    Observation can remain orthogonal instead of becoming another inheritance requirement merely to make the generic model look complete.
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    Operation
                    PlannedOperation

                    OperationObserver<Event>
                    OperationExecution<Result, Event>
                    """#
                )

                quote(
                    #"""
                    Do multiple real domains fit the abstraction without contorting their native APIs?
                    """#
                )

                paragraph(
                    #"""
                    Test candidate abstractions against actual domains rather than hypothetical symmetry.
                    """#
                )

                list(
                    style: .unordered,
                    items: [
                        "Accounting",
                        "Concatenation",
                        "Syncer",
                        "Executable",
                        "Media",
                        "server operations",
                    ]
                )

                paragraph(
                    #"""
                    If several real domains converge naturally, a microscopic generic layer may be justified. If they do not, keep the structural mental model and discard the protocol.
                    """#
                )

                quote(
                    #"""
                    The structural discipline is more valuable than a universal generic.
                    """#
                )
            }
        }
    }
}
