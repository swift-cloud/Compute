// swift-tools-version:6.2

import PackageDescription

let package = Package(
    name: "Compute",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .library(name: "Compute", targets: ["Compute"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-crypto", from: "3.12.0")
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
    ]
)
