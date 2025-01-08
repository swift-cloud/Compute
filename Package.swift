// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "Compute",
    platforms: [
        .macOS(.v11),
        .iOS(.v14),
        .tvOS(.v14),
        .watchOS(.v7),
    ],
    products: [
        .library(name: "Compute", targets: ["Compute"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-crypto", "1.0.0"..<"4.0.0")
    ],
    targets: [
        .target(
            name: "Compute",
            dependencies: [
                "ComputeRuntime",
                .product(name: "Crypto", package: "swift-crypto"),
            ]
        ),
        .target(
            name: "ComputeRuntime"
        ),
        .executableTarget(
            name: "ComputeDemo",
            dependencies: ["Compute"]
        ),
        .testTarget(
            name: "ComputeTests",
            dependencies: ["Compute"]
        ),
    ],
    swiftLanguageVersions: [
        .version("6"),
        .v5,
    ]
)
