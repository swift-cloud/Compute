// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "SwiftCompute",
    products: [
        // Swift SDK to build C@E apps
        .library(name: "SwiftCompute", targets: ["SwiftCompute"]),
        // Sample app deployed to C@E using the swift runtime sdk
        .executable(name: "SwiftComputeApp", targets: ["SwiftComputeApp"]),
    ],
    dependencies: [],
    targets: [
        // Swift SDK (+runtime headers) to build C@E apps
        .target(name: "SwiftCompute", dependencies: ["ComputeRuntime"]),
        .target(name: "ComputeRuntime"),
        // Sample app deployed to C@E using the swift runtime sdk
        .executableTarget(name: "SwiftComputeApp", dependencies: ["SwiftCompute"])
    ]
)
