import Foundation
import BackpackDI
import SecureStorageAPI
import SecureStorageImpl

@MainActor
public final class SecureStorageAssembler {
    static func assemble(_ container: Container) {
        container.autoRegister(Keychain.self, using: KeychainImpl.init)

        container.autoRegister(SecureDataStorage.self, using: SecureDataStorageImpl.init)

        container.register(AsyncSecureStorage.self) { r in
            return AsyncSecureStorageImpl(
                secureDataStorage: r.resolve(SecureDataStorage.self),
                encoder: JSONEncoder(),
                decoder: JSONDecoder()
            )
        }
    }
}
