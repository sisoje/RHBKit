// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "RHBCoreData",
    platforms: [
        .macOS(.v10_12), .iOS("10.3")
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "RHBCoreData",
            targets: ["RHBCoreData"]
        ),
        .library(
            name: "RHBCoreDataTestUtilities",
            targets: ["RHBCoreDataTestUtilities"]
        )
    ],
    dependencies: [
        .package(path: "../RHBFoundation")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "RHBCoreData",
            dependencies: ["RHBFoundation"],
            path: "Sources"
        ),
        .target(
            name: "RHBCoreDataTestUtilities",
            dependencies: [],
            path: "TestUtilities"
        ),
        .testTarget(
            name: "RHBCoreDataTests",
            dependencies: ["RHBCoreData", "RHBCoreDataTestUtilities"],
            path: "Tests"
        )
    ]
)
