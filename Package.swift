// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Compute",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        .library(name: "Compute", targets: ["Compute"])
    ],
    targets: [
        .target(name: "Compute", dependencies: ["ComputeRuntime"]),
        .target(name: "ComputeRuntime")
    ]
)
