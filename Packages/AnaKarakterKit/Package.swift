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
    ],
    targets: [
        .target(name: "LifeDomain"),
        .testTarget(
            name: "LifeDomainTests",
            dependencies: ["LifeDomain"]
        ),
    ]
)
