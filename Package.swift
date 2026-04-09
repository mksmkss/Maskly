// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "ClipboardMasker",
    platforms: [
        .macOS(.v14),
    ],
    products: [
        .library(
            name: "ClipboardMaskerCore",
            targets: ["ClipboardMaskerCore"]
        ),
        .executable(
            name: "ClipboardMaskerApp",
            targets: ["ClipboardMaskerApp"]
        ),
    ],
    targets: [
        .target(
            name: "ClipboardMaskerCore"
        ),
        .executableTarget(
            name: "ClipboardMaskerApp",
            dependencies: ["ClipboardMaskerCore"]
        ),
        .testTarget(
            name: "ClipboardMaskerCoreTests",
            dependencies: ["ClipboardMaskerCore"]
        ),
    ]
)
