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
        .library(name: "AppPolicy", targets: ["AppPolicy"]),
    ],
    targets: [
        .target(name: "LifeDomain"),
        .target(name: "LifeContent", dependencies: ["LifeDomain"]),
        // Oyun kuralı değil, uygulama politikası (reklam). Saf ve testli
        // tutulur ki SDK'sız doğrulanabilsin — CLAUDE.md reklam politikası.
        .target(name: "AppPolicy"),
        .testTarget(
            name: "LifeDomainTests",
            dependencies: ["LifeDomain"]
        ),
        .testTarget(
            name: "AppPolicyTests",
            dependencies: ["AppPolicy"]
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
