// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "SwiftCompute",
    products: [
        .executable(name: "SwiftComputeApp", targets: ["SwiftComputeApp"]),
        .library(name: "SwiftCompute", targets: ["SwiftCompute"]),
    ],
    dependencies: [],
    targets: [
        .executableTarget(name: "SwiftComputeApp", dependencies: ["SwiftCompute"]),
        .target(name: "ComputeRuntime"),
        .target(name: "SwiftCompute", dependencies: ["ComputeRuntime"])
    ]
)
