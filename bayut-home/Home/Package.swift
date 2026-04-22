// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Home",
    defaultLocalization: "en",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Home",
            targets: ["Home"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/SectorLabs/ios-network-core", from: "1.0.4"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "7.10.0"),
        .package(url: "https://github.com/Juanpe/SkeletonView.git", from: "1.7.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Home",
            dependencies: [
                .product(name: "NetworkLayer", package: "ios-network-core"),
                "Kingfisher",
                .product(name: "SkeletonView", package: "SkeletonView")
            ],
            path: "Sources/Home",
            resources: [
                .process("Resources/Assets.xcassets"),
                .process("Resources/Lato"),
                .process("Resources/Localizable.xcstrings")
            ]
        ),
    ]
)
