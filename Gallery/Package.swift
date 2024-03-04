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
            name: "AlbumRepository",
            targets: ["AlbumRepository"]
        ),
        .library(
            name: "AlbumEntity",
            targets: ["AlbumEntity"]
        ),
        .library(
            name: "PermissionTestSupport",
            targets: ["PermissionTestSupport"]
        ),
        .library(
            name: "AlbumRepositoryTestSupport",
            targets: ["AlbumRepositoryTestSupport"]
        )
    ],
    dependencies: [     
        .package(path: "../Platform"),
        .package(url: "https://github.com/DevYeom/ModernRIBs", branch: "main"),
    ],
    targets: [
        .target(
            name: "Gallery",
            dependencies: [
                .product(name: "UIUtils", package: "Platform"),
                "ModernRIBs",
                "Permission",
                "AlbumRepository",
            ]
        ),
        .target(
            name: "Permission"
        ),
        .target(
            name: "AlbumRepository",
            dependencies: [
                .product(name: "CombineUtils", package: "Platform"),
                "AlbumEntity"
            ]
        ),
        .target(
            name: "AlbumEntity"
        ),
        .target(
            name: "PermissionTestSupport"
        ),
        .target(
            name: "AlbumRepositoryTestSupport"
        ),
        .testTarget(
            name: "GalleryTests",
            dependencies: [
                "Gallery",
                "PermissionTestSupport",
                "AlbumRepositoryTestSupport"
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
