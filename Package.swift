// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "DalySwift",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "DalySwift",
            targets: ["DalySwift"]),
    ],
    dependencies: [
        .package(url: "https://github.com/christophhagen/SwiftSerial", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "DalySwift",
            dependencies: [.product(name: "SwiftSerial", package: "SwiftSerial")]),
        .testTarget(
            name: "DalySwiftTests",
            dependencies: ["DalySwift"]),
    ]
)
