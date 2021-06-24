// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Flow",
    platforms: [.iOS(.v14), .macOS(.v11)],
    products: [
        .library(
            name: "Flow",
            targets: ["Flow"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Flow",
            dependencies: []),
        .testTarget(
            name: "FlowTests",
            dependencies: ["Flow"]),
    ]
)
