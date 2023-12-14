// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LocalizableGenerator",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "lgenerator", targets: ["cli"]),
        .library(name: "Localizable-Core", targets: ["Localizable-Core"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
        .package(url: "https://github.com/kylef/PathKit.git", from: "1.0.1"),
        .package(url: "https://github.com/CoreOffice/CoreXLSX.git", .upToNextMinor(from: "0.14.2"))
    ],
    targets: [
        .executableTarget(
            name: "cli",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .target(name: "Localizable-Core"),
                .product(name: "PathKit", package: "PathKit"),
            ],
            path: nil,
            exclude: ["README.md"]
        ),
        .target(
            name: "Localizable-Core",
            dependencies: [
                .product(name: "CoreXLSX", package: "CoreXLSX"),
            ],
            path: nil
        )
    ]
)
