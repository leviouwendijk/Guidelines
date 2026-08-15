// swift-tools-version: 6.3

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "Guidelines",
    products: [
        .library(
            name: "Guidelines",
            targets: ["Guidelines"]
        ),
        .executable(
            name: "guidelines-concept",
            targets: ["GuidelinesConcept"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swiftlang/swift-syntax.git",
            from: "603.0.0"
        ),
    ],
    targets: [
        .macro(
            name: "GuidelinesMacros",
            dependencies: [
                .product(
                    name: "SwiftSyntax",
                    package: "swift-syntax"
                ),
                .product(
                    name: "SwiftSyntaxMacros",
                    package: "swift-syntax"
                ),
                .product(
                    name: "SwiftCompilerPlugin",
                    package: "swift-syntax"
                ),
                .product(
                    name: "SwiftDiagnostics",
                    package: "swift-syntax"
                ),
            ]
        ),

        .target(
            name: "Guidelines",
            dependencies: [
                "GuidelinesMacros",
            ]
        ),

        .executableTarget(
            name: "GuidelinesConcept",
            dependencies: [
                "Guidelines",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
