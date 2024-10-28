import Foundation
import BackpackDI
import MUCLoginAPI
import MUCLoginImpl

@MainActor
public final class MUCLoginAssembler {
    static func assemble(_ container: Container) {
        container.autoRegister(LoginViewModel.self, using: LoginViewModel.init)

        container.register(LoginView.self) { r, loginNavDelegate in
            LoginView(
                viewModel: r.resolve(LoginViewModel.self),
                navDelegate: loginNavDelegate
            )
        }
    }
}
