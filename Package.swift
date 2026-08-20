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
    targets: [
        .target(
            name: "Guidelines"
        ),
        .executableTarget(
            name: "GuidelinesTest"
        ),
    ],
    swiftLanguageModes: [.v6]
)
