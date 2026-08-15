import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

public struct GuidelineViolationMacro:
    PeerMacro
{
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard
            let arguments = node.arguments?.as(LabeledExprListSyntax.self),
            let argument = arguments.first
        else {
            return []
        }

        let reference = argument.expression
            .description
            .trimmingCharacters(in: .whitespacesAndNewlines)

        context.diagnose(
            Diagnostic(
                node: Syntax(node),
                message: ViolationDiagnostic(
                    reference: reference
                )
            )
        )

        return []
    }
}

private struct ViolationDiagnostic:
    DiagnosticMessage
{
    let reference: String

    var message: String {
        "Guideline violation: \(reference)"
    }

    var diagnosticID: MessageID {
        .init(
            domain: "Guidelines",
            id: "violation"
        )
    }

    var severity: DiagnosticSeverity {
        .warning
    }
}

@main
struct GuidelinesPlugin:
    CompilerPlugin
{
    let providingMacros: [Macro.Type] = [
        GuidelineViolationMacro.self,
    ]
}
