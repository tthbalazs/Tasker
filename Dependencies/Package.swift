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
        ),
    ],
    dependencies: [ 
        .package(path: "Authentication"),
        .package(path: "Repository")
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
                    name: "Repository",
                    package: "Repository"
                ),
                .product(
                    name: "RepositoryMocks",
                    package: "Repository"
                )
            ]
        ),
    ]
)
