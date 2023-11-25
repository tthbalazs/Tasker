// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Dependencies",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Dependencies",
            targets: ["Dependencies"]
        )
    ],
    dependencies: [
        .package(path: "Authentication"),
        .package(path: "Project")
    ],
    targets: [
        .target(
            name: "Dependencies",
            dependencies: [
                .product(
                    name: "Authentication",
                    package: "Authentication"
                ),
                .product(
                    name: "AuthenticationMocks",
                    package: "Authentication"
                ),
                .product(
                    name: "Project",
                    package: "Project"
                ),
                .product(
                    name: "ProjectMocks",
                    package: "Project"
                )
            ]
        )
    ]
)
