import BackpackDI
import CoreUI
import Foundation
import MUCLoginImpl

@MainActor
public final class AppAssembler {
    static func assemble(_ container: Container) {
        container.register(AppCoordinator.self) { r in
            AppCoordinator(loginViewFactory: { loginNavDelegate in
                r.resolve(LoginView.self, arguments: loginNavDelegate)
            })
        }

        container.register(Theme.self) { _ in
            return ThemeImpl()
        }
    }
}
