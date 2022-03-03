// swift-tools-version:5.0
//
// AsyncViewController
//

import PackageDescription

let package = Package(
    name: "AsyncViewKit",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "AsyncViewKit",
            targets: ["AsyncViewKit"]
        )
    ],
    targets: [
        .target(
            name: "AsyncViewKit",
            path: "AsyncViewKit"
        )
    ],
    swiftLanguageVersions: [
        .v4,
        .v4_2,
        .v5
    ]
)
