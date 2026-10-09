// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "flutter_secure_storage",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(name: "flutter-secure-storage", targets: ["flutter_secure_storage"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "flutter_secure_storage",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            // SwiftPM targets cannot mix Objective-C and Swift. The Objective-C
            // FlutterSecureStoragePlugin is only a thin wrapper that forwards to
            // SwiftFlutterSecureStoragePlugin, which is registered directly as the
            // pluginClass. The wrapper is still compiled by the CocoaPods build.
            exclude: [
                "FlutterSecureStoragePlugin.h",
                "FlutterSecureStoragePlugin.m",
            ],
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ]
        )
    ]
)
