// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Authentication",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Authentication",
            targets: ["Authentication"]
        ),
        .library(
            name: "AuthenticationInterface",
            targets: ["AuthenticationInterface"]
        ),
        .library(
            name: "AuthenticationMocks",
            targets: ["AuthenticationMocks"]
        )
    ],
    dependencies: [
        .package(path: "../DependencyInjection"),
        .package(path: "../FirebaseSupport"),
    ],
    targets: [
        .target(
            name: "AuthenticationInterface",
            dependencies: [
                .product(
                    name: "FirebaseSupport",
                    package: "FirebaseSupport"
                )
            ]
        ),
        .target(
            name: "Authentication",
            dependencies: [
                "AuthenticationInterface",
                .product(
                    name: "DependencyInjection",
                    package: "DependencyInjection"
                ),
            ]
        ),
        .target(
            name: "AuthenticationMocks",
            dependencies: ["Authentication"]
        ),
    ]
)
