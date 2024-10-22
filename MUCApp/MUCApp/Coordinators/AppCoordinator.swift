import MUCAPI
import MUCImpl
import SecureStorageAPI
import SecureStorageImpl
import SwiftUI

@MainActor
final class AppCoordinator {
    enum Destination: Hashable {
        case home(next: HomeCoordinator.Destination? = nil)
    }
    
    @Bindable var navPath = ObservableNavigationPath()
    private var childCoordinator: Any?

    public init() {}

    func getInitialView() -> some View {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let baseClient = MUCBaseClient(
            urlRequester: URLSession.shared,
            encoder: encoder,
            decoder: decoder
        )
        
        let keychain = KeychainImpl()
        
        let secureStorage = AsyncSecureStorageImpl(
            secureDataStorage: SecureDataStorageImpl(keychain: keychain),
            encoder: encoder,
            decoder: decoder
        )
        
        let authRepository = AuthRepositoryImpl(
            endpoints: DevEndpoints(),
            client: baseClient,
            storage: secureStorage
        )
        
        let loginViewModel = LoginViewModel(authRepository: authRepository)
        
        return LoginView(
            viewModel: loginViewModel,
            navDelegate: self
        )
        .navigationDestination(
            for: Destination.self,
            destination: destinationView(for:)
        )
    }
    
    private func destinationView(for destination: Destination) -> some View {
        switch destination {
        case .home(let next):
            let coordinator = HomeCoordinator(path: navPath, destination: next)
            self.childCoordinator = coordinator
            return coordinator.getInitialView()
        }
    }
    
    private func go(to destination: Destination) {
        navPath.append(destination)
    }
    
    func handleDeeplink(to destination: Destination) {
        switch destination {
        case .home:
            handleHomeDeeplink(to: destination)
        }
    }
    
    private func handleHomeDeeplink(to destination: Destination) {
        guard case .home(let next) = destination else { return }
        
        if
            let childCoordinator,
            let coordinator = childCoordinator as? HomeCoordinator
        {
            if let next { coordinator.handleDeeplink(to: next) }
        }
        else {
            go(to: destination)
        }
    }
}

extension AppCoordinator: LoginNavDelegate {
    public func onLoginSuccessful() {
        go(to: .home())
    }
}
