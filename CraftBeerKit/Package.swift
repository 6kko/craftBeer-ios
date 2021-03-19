// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CraftBeerKit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "CraftBeerKit",
            targets: ["CraftBeerKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/bignerdranch/Deferred.git", from: "4.1.0"),
        .package(name: "SnapshotTesting", url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.8.2"),
        .package(path: "../EssentialKit"),
    ],
    targets: [
        .target(
            name: "CraftBeerKit",
            dependencies: ["Deferred", "EssentialKit"]
        ),
        .testTarget(
            name: "CraftBeerKitTests",
            dependencies: ["CraftBeerKit", "Deferred", "SnapshotTesting"],
            exclude: ["__Snapshots__"]
        )
    ]
)
