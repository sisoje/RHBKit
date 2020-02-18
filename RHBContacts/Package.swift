// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RHBContacts",
    platforms: [
        .macOS(.v10_12), .iOS("10.3")
    ],
    products: [
        .library(
            name: "RHBContacts",
            targets: ["RHBContacts"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "RHBContacts",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "RHBContactsTests",
            dependencies: ["RHBContacts"],
            path: "Tests"
        )
    ]
)
