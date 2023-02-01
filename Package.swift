// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "Compute",
    platforms: [
        .macOS(.v11),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v9),
        .driverKit(.v22),
        .macCatalyst(.v13)
    ],
    products: [
        .library(name: "Compute", targets: ["Compute"])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-cloud/Crypto", from: "1.6.0")
    ],
    targets: [
        .target(name: "Compute", dependencies: ["ComputeRuntime", "Crypto"]),
        .target(name: "ComputeRuntime"),
        .executableTarget(name: "ComputeDemo", dependencies: ["Compute"]),
        .testTarget(name: "ComputeTests", dependencies: ["Compute"])
    ]
)
