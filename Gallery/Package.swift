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
        ),
        .library(
            name: "PermissionTestSupport",
            targets: ["PermissionTestSupport"]
        )
    ],
    dependencies: [        
        .package(url: "https://github.com/DevYeom/ModernRIBs", branch: "main"),
    ],
    targets: [
        .target(
            name: "Gallery",
            dependencies: [
                "ModernRIBs",
                "Permission"
            ]
        ),
        .target(
            name: "Permission"
        ),
        .target(
            name: "PermissionTestSupport"
        ),
        .testTarget(
            name: "GalleryTests",
            dependencies: [
                "Gallery",
                "PermissionTestSupport"
            ]
        ),
        .testTarget(
            name: "PermissionTests",
            dependencies: [
                "Permission",
                "PermissionTestSupport"
            ]
        )
    ]
)
