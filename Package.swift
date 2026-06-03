// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "TWCoreFHIRModels",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .watchOS(.v9),
        .tvOS(.v16),
    ],
    products: [
        .library(
            name: "TWCoreFHIRModels",
            targets: ["TWCoreFHIRModels"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/FHIRModels.git",
            from: "0.9.2"
        ),
    ],
    targets: [
        .target(
            name: "TWCoreFHIRModels",
            dependencies: [
                .product(name: "ModelsR4", package: "FHIRModels"),
            ]
        ),
        .testTarget(
            name: "TWCoreFHIRModelsTests",
            dependencies: ["TWCoreFHIRModels"]
        ),
    ]
)
