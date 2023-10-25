// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Connectivity",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Connectivity",
            targets: ["Connectivity"]
        ),
        .library(
            name: "ConnectivityInterface",
            targets: ["ConnectivityInterface"]
        ),
        .library(
            name: "ConnectivityMocks",
            targets: ["ConnectivityMocks"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ConnectivityInterface",
            dependencies: []
        ),
        .target(
            name: "Connectivity",
            dependencies: [
                "ConnectivityInterface"
            ]
        ),
        .target(
            name: "ConnectivityMocks",
            dependencies: [
                "Connectivity"
            ]
        )
    ]
)
