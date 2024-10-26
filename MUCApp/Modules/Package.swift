// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [.iOS(.v18)]
)

// MARK: DI
package.targets.append(contentsOf: [
    .target(
        name: "DependencyInjection",
        path: "DependencyInjection/Sources"
    ),
    .testTarget(
        name: "DependencyInjectionTests",
        dependencies: [
            "DependencyInjection"
        ],
        path: "DependencyInjection/Tests"
    )
])

package.products.append(contentsOf: [
    .library(
        name: "DependencyInjection",
        targets: ["DependencyInjection"]
    )
])

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
        dependencies: [
            "MUCAPI",
            "MUCMocks",
            "SecureStorageAPI"
        ],
        path: "MUC/Sources/Impl"
    ),
    .target(
        name: "MUCMocks",
        dependencies: ["MUCAPI"],
        path: "MUC/Mocks"
    ),
    .testTarget(
        name: "MUCTests",
        dependencies: [
            "MUCAPI",
            "MUCImpl",
            "MUCMocks",
            "SecureStorageMocks"
        ],
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
