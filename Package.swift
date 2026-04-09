// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "Maskli",
    platforms: [
        .macOS(.v14),
    ],
    products: [
        .library(
            name: "MaskliCore",
            targets: ["MaskliCore"]
        ),
        .executable(
            name: "MaskliApp",
            targets: ["MaskliApp"]
        ),
    ],
    targets: [
        .target(
            name: "MaskliCore"
        ),
        .executableTarget(
            name: "MaskliApp",
            dependencies: ["MaskliCore"]
        ),
        .testTarget(
            name: "MaskliCoreTests",
            dependencies: ["MaskliCore"]
        ),
    ]
)
