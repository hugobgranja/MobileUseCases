// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [.iOS(.v18)]
)

// MARK: Storage
package.targets.append(contentsOf: [
    .target(
        name: "StorageAPI",
        path: "Storage/Sources/API"
    ),
    .target(
        name: "StorageImpl",
        dependencies: ["StorageAPI"],
        path: "Storage/Sources/Impl"
    ),
    .testTarget(
        name: "StorageTests",
        dependencies: ["StorageImpl"],
        path: "Storage/Tests"
    )
])

package.products.append(contentsOf: [
    .library(
        name: "StorageAPI",
        targets: ["StorageAPI"]
    ),
    .library(
        name: "StorageImpl",
        targets: ["StorageImpl"]
    )
])

// MARK: MUC
package.targets.append(contentsOf: [
    .target(
        name: "MUCAPI",
        path: "MUC/Sources/API"
    ),
    .target(
        name: "MUCImpl",
        dependencies: ["MUCAPI", "StorageAPI"],
        path: "MUC/Sources/Impl"
    ),
    .testTarget(
        name: "MUCTests",
        dependencies: ["MUCImpl"],
        path: "MUC/Tests"
    )
])

package.products.append(contentsOf: [
    .library(
        name: "MUCAPI",
        targets: ["MUCAPI"]
    ),
    .library(
        name: "MUCImpl",
        targets: ["MUCImpl"]
    )
])
