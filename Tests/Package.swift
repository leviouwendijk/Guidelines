// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "GuidelinesTests",
    products: [
        .executable(
            name: "guidetest",
            targets: ["GuidelinesTest"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/leviouwendijk/DSL.git",
            branch: "master"
        ),
        .package(
            url: "https://github.com/leviouwendijk/Schema.git",
            branch: "master"
        ),
        .package(path: ".."),
    ],
    targets: [
        .executableTarget(
            name: "GuidelinesTest",
            dependencies: [
                .product(name: "Guidelines", package: "Guidelines"),
                .product(
                    name: "DSL",
                    package: "DSL"
                ),
                .product(
                    name: "Schema",
                    package: "Schema"
                ),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
