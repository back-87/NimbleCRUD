// swift-tools-version:5.5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NimbleCRUD",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "NimbleCRUD",
            targets: ["NimbleCRUD"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "ScrollViewProxy", url: "https://github.com/back-87/ScrollViewProxy.git", from: "1.0.7"),
        .package(name: "NumericText", url: "https://github.com/back-87/NumericText.git", from: "1.3.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "NimbleCRUD",
            dependencies: [
                            "ScrollViewProxy",
                            "NumericText",
                            //.product(name: "NumericText", package: "NumericText"),
                        ]),
        .testTarget(
            name: "NimbleCRUDTests",
            dependencies: ["NimbleCRUD"]),
    ]
)
