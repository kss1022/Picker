// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PhotoPicker",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "PhotoPicker",
            targets: ["PhotoPicker"]),
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
        ),
        .library(
            name: "PhotoEditor",
            targets: ["PhotoEditor"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/DevYeom/ModernRIBs", branch: "main"),
        .package(path: "../Platform"),
    ],
    targets: [
        .target(
            name: "PhotoPicker",
            dependencies: [
                "ModernRIBs",
                "Gallery",
                "Permission",
                "AlbumRepository",
            ]
        ),
        .target(
            name: "Gallery",
            dependencies: [
                .product(name: "UIUtils", package: "Platform"),
                .product(name: "RIBsUtils", package: "Platform"),
                "ModernRIBs",
                "GalleryUtils",
                "Permission",
                "Selection",
                "AlbumRepository",
                "Albums",
                "PhotoEditor"
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
        .target(
            name: "PhotoEditor",
            dependencies: [
                "ModernRIBs",
                "AlbumEntity",
                "GalleryUtils",
                .product(name: "UIUtils", package: "Platform"),
                .product(name: "RIBsUtils", package: "Platform"),
            ]
        ),
        .testTarget(
            name: "GalleryTests",
            dependencies: [
                "Gallery",
                "Albums",
                "PhotoEditor",
                "PermissionTestSupport",
                "AlbumRepositoryTestSupport",
                .product(name: "RIBsTestSupports", package: "Platform")
            ]
        ),
        .testTarget(
            name: "PickerTests",
            dependencies: ["PhotoPicker"]
        ),
    ]
)
