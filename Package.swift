// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "MarkdownFileCreator",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        .executable(name: "MarkdownFileCreator", targets: ["MarkdownFileCreator"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kylef/Commander.git", from: "0.9.2"),
        .package(url: "https://github.com/JohnSundell/Files.git", from: "4.2.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "4.0.6")
    ],
    targets: [
        .target(
            name: "MarkdownFileCreator",
            dependencies: ["Commander", "Files", "Yams"]),
        .testTarget(
            name: "MarkdownFileCreatorTests",
            dependencies: ["MarkdownFileCreator", "Commander", "Files", "Yams"]),
    ]
)
