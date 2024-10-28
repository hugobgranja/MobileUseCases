import Foundation
import BackpackDI
import MUCLoginImpl

@MainActor
public final class AppAssembler {
    static func assemble(_ container: Container) {
        container.register(AppCoordinator.self) { r in
            AppCoordinator(loginViewFactory: { loginNavDelegate in
                r.resolve(LoginView.self, arguments: loginNavDelegate)
            })
        }
    }
}
