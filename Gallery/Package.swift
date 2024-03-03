// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Gallery",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "Gallery",
            targets: ["Gallery"]),
        .library(
            name: "Permission",
            targets: ["Permission"]
        )
    ],
    targets: [
        .target(
            name: "Gallery"
        ),
        .target(
            name: "Permission"
        ),
        .testTarget(
            name: "GalleryTests",
            dependencies: ["Gallery"]),
        .testTarget(
            name: "PermissionTests",
            dependencies: ["Permission"]
        )
    ]
)
