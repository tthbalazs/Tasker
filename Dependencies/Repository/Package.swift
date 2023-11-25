// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Repository",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Repository",
            targets: ["Repository"]
        ),
        .library(
            name: "RepositoryInterface",
            targets: ["RepositoryInterface"]
        ),
        .library(
            name: "RepositoryMocks",
            targets: ["RepositoryMocks"]
        )
    ],
    dependencies: [
        .package(path: "../CloudDatabase"),
        .package(path: "../Connectivity"),
        .package(path: "../Database"),
        .package(path: "../Synchronizer")
    ],
    targets: [
        .target(
            name: "RepositoryInterface",
            dependencies: [
                .product(
                    name: "CloudDatabase",
                    package: "CloudDatabase"
                ),
                .product(
                    name: "Connectivity",
                    package: "Connectivity"
                ),
                .product(
                    name: "Database",
                    package: "Database"
                ),
                .product(
                    name: "Synchronizer",
                    package: "Synchronizer"
                )
            ]
        ),
        .target(
            name: "Repository",
            dependencies: [
                "RepositoryInterface",
            ]
        ),
        .target(
            name: "RepositoryMocks",
            dependencies: [
                "Repository",
                .product(
                    name: "CloudDatabaseMocks",
                    package: "CloudDatabase"
                ),
                .product(
                    name: "ConnectivityMocks",
                    package: "Connectivity"
                ),
                .product(
                    name: "DatabaseMocks",
                    package: "Database"
                ),
                .product(
                    name: "SynchronizerMocks",
                    package: "Synchronizer"
                )
            ]
        ),
    ]
)
