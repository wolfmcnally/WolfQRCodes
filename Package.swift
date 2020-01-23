// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WolfQRCodes",
    platforms: [
        .iOS(.v12), .macOS(.v10_13), .tvOS(.v12)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "WolfQRCodes",
            type: .dynamic,
            targets: ["WolfQRViews"]),
    ],
    dependencies: [
        .package(url: "https://github.com/wolfmcnally/WolfWith", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfPipe", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfFoundation", from: "5.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfImage", from: "4.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfViews", from: "5.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfConcurrency", from: "3.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfNesting", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfApp", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfAutolayout", from: "2.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "WolfQRCodes",
            dependencies: [
                "WolfWith",
                "WolfPipe",
                "WolfFoundation",
                "WolfImage",
                "WolfViews",
                "WolfConcurrency",
                "WolfNesting",
                "WolfApp",
                "WolfAutolayout"
        ])
    ]
)
