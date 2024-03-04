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
    ],
    dependencies: [
        .package(url: "https://github.com/DevYeom/ModernRIBs", branch: "main"),
        .package(path: "../Gallery"),
    ],
    targets: [
        .target(
            name: "PhotoPicker",
            dependencies: [
                "ModernRIBs",
                .product(name: "Gallery", package: "Gallery"),
                .product(name: "Permission", package: "Gallery"),
                .product(name: "AlbumRepository", package: "Gallery")
            ]
        ),
        .testTarget(
            name: "PickerTests",
            dependencies: ["PhotoPicker"]),
    ]
)
