// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "FirebaseSupport",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "FirebaseSupport",
            targets: ["FirebaseSupport"]
        ),
        .library(
            name: "FirebaseSupportInterface",
            targets: ["FirebaseSupportInterface"]
        ),
        .library(
            name: "FirebaseSupportMocks",
            targets: ["FirebaseSupportMocks"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            exact: "10.14.0"
        ),
        .package(
            url: "https://github.com/google/GoogleSignIn-iOS.git",
            exact: "7.0.0"
        )
    ],
    targets: [
        .target(
            name: "FirebaseSupportInterface",
            dependencies: [
                .product(
                    name: "FirebaseAuth",
                    package: "firebase-ios-sdk"
                ),
                .product(
                    name: "FirebaseFirestore",
                    package: "firebase-ios-sdk"
                ),
                .product(
                    name: "FirebaseFirestoreSwift",
                    package: "firebase-ios-sdk"
                ),
                .product(
                    name: "GoogleSignInSwift",
                    package: "GoogleSignIn-iOS"
                )
            ]
        ),
        .target(
            name: "FirebaseSupport",
            dependencies: ["FirebaseSupportInterface"]
        ),
        .target(
            name: "FirebaseSupportMocks",
            dependencies: ["FirebaseSupport"]
        )
    ]
)
