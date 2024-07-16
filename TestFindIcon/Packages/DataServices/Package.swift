// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataServices",
    platforms: [.iOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "DataServices",
            targets: ["DataServices"]),
    ],
    dependencies: [.package(name: "Network", path: "../Network")],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DataServices",
            dependencies: ["Network"]),
        .testTarget(
            name: "DataServicesTests",
            dependencies: ["DataServices"]),
    ]
)
