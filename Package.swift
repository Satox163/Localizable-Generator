// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LocalizableGenerator",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
       .executable(name: "lgenerator", targets: ["LocalizableGenerator"])
     ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/kylef/PathKit.git", from: "1.0.1"),
        
    ],
    targets: [
        .executableTarget(
            name: "LocalizableGenerator",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "PathKit", package: "PathKit"),
            ],
            path: "Sources/..",
            exclude: ["README.md"]
        )
    ]
)
