// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "ExpandableCell",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "ExpandableCell", targets: ["ExpandableCell"])
    ],
    targets: [
        .target(
            name: "ExpandableCell",
            path: "ExpandableCell",
            exclude: [
                "ExpandableCell.h",
                "Info.plist"
            ],
            resources: [
                .process("ExpandableCell.xcassets")
            ],
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        )
    ]
)
