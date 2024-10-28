import CoreUI
import MUCLoginAPI
import MUCLoginImpl
import SwiftUI

@MainActor
final class AppCoordinator {
    enum Destination: Hashable {
        case home(next: HomeCoordinator.Destination? = nil)
    }
    
    @Bindable var navPath = ObservableNavigationPath()
    private var childCoordinator: Any?
    private let loginViewFactory: (LoginNavDelegate) -> LoginView

    init(
        loginViewFactory: @escaping (LoginNavDelegate) -> LoginView
    ) {
        self.loginViewFactory = loginViewFactory
    }

    func getInitialView() -> some View {
        let loginView = loginViewFactory(self)

        return NavigationStack(path: $navPath.path) {
            loginView
                .navigationDestination(
                    for: Destination.self,
                    destination: destinationView(for:)
                )
        }
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
