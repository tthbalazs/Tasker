// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Project",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Project",
            targets: ["Project"]
        ),
        .library(
            name: "ProjectInterface",
            targets: ["ProjectInterface"]
        ),
        .library(
            name: "ProjectMocks",
            targets: ["ProjectMocks"]
        )
    ],
    dependencies: [
        .package(path: "../Repository")
    ],
    targets: [
        .target(
            name: "ProjectInterface",
            dependencies: [
                .product(
                    name: "Repository",
                    package: "Repository"
                )
            ]
        ),
        .target(
            name: "Project",
            dependencies: [
                "ProjectInterface",
            ]
        ),
        .target(
            name: "ProjectMocks",
            dependencies: [
                "ProjectInterface",
                .product(
                    name: "RepositoryMocks",
                    package: "Repository"
                )
            ]
        ),
        .testTarget(
            name: "ProjectTests",
            dependencies: ["Project"]
        ),
    ]
)
