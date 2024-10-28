// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [.iOS(.v18)]
)

// MARK: CoreUI
package.targets.append(contentsOf: [
    .target(
        name: "CoreUI",
        path: "CoreUI/Sources"
    )
])

// MARK: MUCHome
package.targets.append(contentsOf: [
    .target(
        name: "MUCHomeAPI",
        path: "MUCHome/Sources/API"
    ),
    .target(
        name: "MUCHomeImpl",
        dependencies: [
            "CoreUI",
            "MUCHomeAPI",
            "MUCHomeMocks"
        ],
        path: "MUCHome/Sources/Impl"
    ),
    .target(
        name: "MUCHomeMocks",
        dependencies: ["MUCHomeAPI"],
        path: "MUCHome/Mocks"
    )
])

package.products.append(contentsOf: [
    .library(
        name: "MUCHomeAPI",
        targets: ["MUCHomeAPI"]
    ),
    .library(
        name: "MUCHomeImpl",
        targets: ["MUCHomeImpl"]
    )
])

// MARK: MUCLogin
package.targets.append(contentsOf: [
    .target(
        name: "MUCLoginAPI",
        path: "MUCLogin/Sources/API"
    ),
    .target(
        name: "MUCLoginImpl",
        dependencies: [
            "CoreUI",
            "MUCLoginAPI",
            "MUCLoginMocks",
            "MUCCoreMocks"
        ],
        path: "MUCLogin/Sources/Impl"
    ),
    .target(
        name: "MUCLoginMocks",
        dependencies: ["MUCLoginAPI"],
        path: "MUCLogin/Mocks"
    ),
    .testTarget(
        name: "MUCLoginTests",
        dependencies: [
            "MUCLoginAPI",
            "MUCLoginImpl"
        ],
        path: "MUCLogin/Tests"
    )
])

package.products.append(contentsOf: [
    .library(
        name: "MUCLoginAPI",
        targets: ["MUCLoginAPI"]
    ),
    .library(
        name: "MUCLoginImpl",
        targets: ["MUCLoginImpl"]
    )
])

// MARK: MUCCore
package.targets.append(contentsOf: [
    .target(
        name: "MUCCoreAPI",
        path: "MUCCore/Sources/API"
    ),
    .target(
        name: "MUCCoreImpl",
        dependencies: [
            "MUCCoreAPI",
            "MUCCoreMocks",
            "SecureStorageAPI"
        ],
        path: "MUCCore/Sources/Impl"
    ),
    .target(
        name: "MUCCoreMocks",
        dependencies: ["MUCCoreAPI"],
        path: "MUCCore/Mocks"
    ),
    .testTarget(
        name: "MUCCoreTests",
        dependencies: [
            "MUCCoreAPI",
            "MUCCoreImpl",
            "MUCCoreMocks",
            "SecureStorageMocks"
        ],
        path: "MUCCore/Tests"
    )
])

package.products.append(contentsOf: [
    .library(
        name: "MUCCoreAPI",
        targets: ["MUCCoreAPI"]
    ),
    .library(
        name: "MUCCoreImpl",
        targets: ["MUCCoreImpl"]
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
