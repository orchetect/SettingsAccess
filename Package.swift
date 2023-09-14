// swift-tools-version:5.3
// (Remember to update .swift-version if this changes)

import PackageDescription

let package = Package(
    name: "SettingsAccess",
    platforms: [.macOS(.v10_15)],
    products: [.library(name: "SettingsAccess", targets: ["SettingsAccess"])],
    targets: [.target(name: "SettingsAccess")]
)
