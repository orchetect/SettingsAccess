// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SettingsAccess",
    platforms: [.macOS(.v11)],
    products: [.library(name: "SettingsAccess", targets: ["SettingsAccess"])],
    targets: [.target(name: "SettingsAccess")]
)
