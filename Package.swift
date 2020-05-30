// swift-tools-version:5.0
//
// AsyncViewController
//

import PackageDescription

let package = Package(
    name: "AsyncViewController",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "AsyncViewController",
            targets: ["AsyncViewController"]
        )
    ],
    targets: [
        .target(
            name: "AsyncViewController",
            path: "AsyncViewController"
        )
    ],
    swiftLanguageVersions: [
        .v4,
        .v4_2,
        .v5
    ]
)
