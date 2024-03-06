// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Gallery",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "Gallery",
            targets: ["Gallery"])
        ,
        .library(
            name: "GalleryUtils",
            targets: ["GalleryUtils"]
        ),
        .library(
            name: "Albums",
            targets: ["Albums"]
        ),
        .library(
            name: "Permission",
            targets: ["Permission"]
        ),
        .library(
            name: "Selection",
            targets: ["Selection"]
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
                "GalleryUtils",
                "Permission",
                "Selection",
                "AlbumRepository",
                "Albums"
            ]
        ),
        .target(
            name: "GalleryUtils",
            dependencies: [
                .product(name: "UIUtils", package: "Platform"),
            ]
        ),
        .target(
            name: "Albums",
            dependencies: [
                .product(name: "UIUtils", package: "Platform"),
                "ModernRIBs",
                "GalleryUtils",
                "AlbumRepository",
            ]
        ),
        .target(
            name: "Permission"
        ),
        .target(
            name: "Selection",
            dependencies: [
                "AlbumEntity"
            ]
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
            name: "PermissionTestSupport",
            dependencies: [
                "Permission"
            ]
        ),
        .target(
            name: "AlbumRepositoryTestSupport",
            dependencies: [
                "AlbumRepository"
            ]
        ),
        .testTarget(
            name: "GalleryTests",
            dependencies: [
                "Gallery",
                "Albums",
                "PermissionTestSupport",
                "AlbumRepositoryTestSupport",
                .product(name: "RIBsTestSupports", package: "Platform")
            ]
        )        
    ]
)
