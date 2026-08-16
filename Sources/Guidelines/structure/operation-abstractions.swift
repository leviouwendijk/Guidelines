public enum OperationAbstractionGuideline:
    String,
    Sendable,
    Hashable,
    CaseIterable
{
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
                    The structural model may justify small generic abstractions where several real domains naturally converge.
                    """#
                )

                paragraph(
                    #"""
                    The abstraction should follow the architecture.
                    """#
                )

                paragraph(
                    #"""
                    The architecture should not be distorted to satisfy the abstraction.
                    """#
                )

                paragraph(
                    #"""
                    A minimal experiment might be:
                    """#
                )

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

                paragraph(
                    #"""
                    For planned operations:
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

                paragraph(
                    #"""
                    Observation may remain orthogonal rather than becoming another inheritance requirement:
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

                paragraph(
                    #"""
                    Do not settle such abstractions merely because they look symmetrical.
                    """#
                )

                paragraph(
                    #"""
                    A useful test is:
                    """#
                )

                quote(
                    #"""
                    Do multiple real domains fit the abstraction without contorting their native APIs?
                    """#
                )

                paragraph(
                    #"""
                    Candidate domains may include:
                    """#
                )

                code(
                    language: "text",
                    content: #"""
                    Accounting
                    Concatenation
                    Syncer
                    Executable
                    Media
                    server operations
                    """#
                )

                paragraph(
                    #"""
                    If they converge naturally, a microscopic generic layer may be justified.
                    """#
                )

                paragraph(
                    #"""
                    If they do not, keep the mental model and discard the protocol.
                    """#
                )

                paragraph(
                    #"""
                    The structural discipline is more valuable than a universal generic.
                    """#
                )
            }
        }
    }
}
