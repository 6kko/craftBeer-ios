// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EssentialKit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "EssentialKit",
            targets: ["EssentialKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/bignerdranch/Deferred.git", from: "4.1.0"),
        .package(url: "https://github.com/kean/Nuke.git", from: "9.3.0"),
    ],
    targets: [
        .target(
            name: "EssentialKit",
            dependencies: ["Deferred", "Nuke"]),
        .testTarget(
            name: "EssentialKitTests",
            dependencies: ["EssentialKit"]),
    ]
)
