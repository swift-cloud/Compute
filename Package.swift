// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "Compute",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(name: "Compute", targets: ["Compute"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
    ],
    targets: [
        .target(name: "Compute", dependencies: ["ComputeRuntime"]),
        .target(name: "ComputeRuntime")
    ]
)
