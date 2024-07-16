// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IconFinder",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "IconFinder",
            targets: ["IconFinder"]),
    ],
    dependencies: [.package(name: "Network", path: "../Network"),
                   .package(name: "Configuration", path: "../Configuration"),
                   .package(name: "UIComponents", path: "../UIComponents"),
                   .package(name: "RootFeature", path: "../RootFeature"),
                   .package(name: "DataServices", path: "../DataServices")],
    targets: [
        .target(
            name: "IconFinder",
            dependencies: [
                "Network",
                "Configuration",
                "UIComponents",
                "RootFeature",
                "DataServices"
            ]),
        .testTarget(
            name: "IconFinderTests",
            dependencies: ["IconFinder", "DataServices"]
        )
    ]
)
