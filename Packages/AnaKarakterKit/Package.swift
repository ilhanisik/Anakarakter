// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "AnaKarakterKit",
    platforms: [
        .iOS(.v17),
        .macOS(.v14), // `swift test` paket kökünde Xcode'suz koşabilsin diye
    ],
    products: [
        .library(name: "LifeDomain", targets: ["LifeDomain"]),
        .library(name: "LifeContent", targets: ["LifeContent"]),
    ],
    targets: [
        .target(name: "LifeDomain"),
        .target(name: "LifeContent", dependencies: ["LifeDomain"]),
        .testTarget(
            name: "LifeDomainTests",
            dependencies: ["LifeDomain"]
        ),
        .testTarget(
            name: "ContentLintTests",
            dependencies: ["LifeDomain", "LifeContent"]
        ),
        .testTarget(
            name: "LifeSimulationTests",
            dependencies: ["LifeDomain", "LifeContent"]
        ),
    ]
)
