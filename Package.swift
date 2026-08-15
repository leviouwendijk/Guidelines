// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "Guidelines",
    products: [
        .library(
            name: "Guidelines",
            targets: ["Guidelines"]
        ),
    ],
    targets: [
        .target(
            name: "Guidelines"
        ),
    ],
    swiftLanguageModes: [.v6]
)
