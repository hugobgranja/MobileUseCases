import Foundation
import DependencyInjection
import MUCAPI
import MUCImpl
import SecureStorageAPI
import SecureStorageImpl

@MainActor
public final class LoginAssembler {
    static func assemble(_ container: Container) {
        container.register(MUCClient.self) { _ in
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            return MUCBaseClient(
                urlRequester: URLSession.shared,
                encoder: encoder,
                decoder: decoder
            )
        }

        container.autoRegister(Keychain.self, using: KeychainImpl.init)
        container.autoRegister(SecureDataStorage.self, using: SecureDataStorageImpl.init)

        container.register(AsyncSecureStorage.self) { r in
            return AsyncSecureStorageImpl(
                secureDataStorage: r.resolve(SecureDataStorage.self),
                encoder: JSONEncoder(),
                decoder: JSONDecoder()
            )
        }

        container.autoRegister(MUCEndpoints.self, using: DevEndpoints.init)

        container.autoRegister(
            AuthRepository.self,
            lifetime: .singleton,
            using: AuthRepositoryImpl.init
        )

        container.autoRegister(LoginViewModel.self, using: LoginViewModel.init)

        container.register(LoginView.self) { r, loginNavDelegate in
            LoginView(
                viewModel: r.resolve(LoginViewModel.self),
                navDelegate: loginNavDelegate
            )
        }

        container.register(AppCoordinator.self) { r in
            AppCoordinator(loginViewFactory: { loginNavDelegate in
                r.resolve(LoginView.self, arguments: loginNavDelegate)
            })
        }
    }
}
