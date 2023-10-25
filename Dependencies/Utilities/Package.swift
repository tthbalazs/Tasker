// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Utilities",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Utilities",
            targets: ["Utilities"]
        ),
    ],
    targets: [
        .target(
            name: "Utilities"
        )
    ]
)
