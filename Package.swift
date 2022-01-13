// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Compute",
    products: [
        // Swift SDK to build C@E apps
        .library(name: "Compute", targets: ["Compute"]),
        // Sample app deployed to C@E using the swift runtime sdk
        .executable(name: "HelloCompute", targets: ["HelloCompute"]),
    ],
    dependencies: [],
    targets: [
        // Swift SDK (+runtime headers) to build C@E apps
        .target(name: "Compute", dependencies: ["ComputeRuntime"]),
        .target(name: "ComputeRuntime"),
        // Sample app deployed to C@E using the swift runtime sdk
        .executableTarget(name: "HelloCompute", dependencies: ["Compute"])
    ]
)
