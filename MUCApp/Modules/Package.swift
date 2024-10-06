// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [.iOS(.v18)]
)

// MARK: SecureStorage
package.targets.append(contentsOf: [
    .target(
        name: "SecureStorageAPI",
        path: "SecureStorage/Sources/API"
    ),
    .target(
        name: "SecureStorageImpl",
        dependencies: ["SecureStorageAPI"],
        path: "SecureStorage/Sources/Impl"
    ),
    .target(
        name: "SecureStorageMocks",
        dependencies: ["SecureStorageAPI"],
        path: "SecureStorage/Mocks"
    ),
    .testTarget(
        name: "SecureStorageTests",
        dependencies: [
            "SecureStorageAPI",
            "SecureStorageImpl",
            "SecureStorageMocks"
        ],
        path: "SecureStorage/Tests"
    )
])

package.products.append(contentsOf: [
    .library(
        name: "SecureStorageAPI",
        targets: ["SecureStorageAPI"]
    ),
    .library(
        name: "SecureStorageImpl",
        targets: ["SecureStorageImpl"]
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
        dependencies: ["MUCAPI", "SecureStorageAPI"],
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
