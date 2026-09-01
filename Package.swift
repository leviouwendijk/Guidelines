// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "Guidelines",
    products: [
        .library(
            name: "Guidelines",
            targets: ["Guidelines"]
        ),
        .executable(
            name: "guidetest",
            targets: ["GuidelinesTest"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/leviouwendijk/Primitives.git",
            branch: "master"
        ),
        .package(
            url: "https://github.com/leviouwendijk/DSL.git",
            branch: "master"
        ),
    ],
    targets: [
        .target(
            name: "Guidelines",
            dependencies: [
                .product(
                    name: "Primitives",
                    package: "Primitives"
                ),
                .product(
                    name: "DSL",
                    package: "DSL"
                ),
            ]
        ),
        .executableTarget(
            name: "GuidelinesTest",
            dependencies: [
                "Guidelines",
                .product(
                    name: "DSL",
                    package: "DSL"
                ),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
