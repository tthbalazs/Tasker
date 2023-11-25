// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Synchronizer",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Synchronizer",
            targets: ["Synchronizer"]
        ),
        .library(
            name: "SynchronizerInterface",
            targets: ["SynchronizerInterface"]
        ),
        .library(
            name: "SynchronizerMocks",
            targets: ["SynchronizerMocks"]
        )
    ],
    dependencies: [
        .package(path: "../CloudDatabase"),
        .package(path: "../Database"),
    ],
    targets: [
        .target(
            name: "SynchronizerInterface",
            dependencies: [
                .product(
                    name: "CloudDatabase",
                    package: "CloudDatabase"
                ),
                .product(
                    name: "Database",
                    package: "Database"
                )
            ]
        ),
        .target(
            name: "Synchronizer",
            dependencies: [
                "SynchronizerInterface",
            ]
        ),
        .target(
            name: "SynchronizerMocks",
            dependencies: [
                "Synchronizer",
                .product(
                    name: "CloudDatabaseMocks",
                    package: "CloudDatabase"
                ),
                .product(
                    name: "DatabaseMocks",
                    package: "Database"
                )
            ]
        )
    ]
)
