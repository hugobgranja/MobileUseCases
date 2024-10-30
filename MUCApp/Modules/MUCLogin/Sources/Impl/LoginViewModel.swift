import CoreUI
import MUCCoreAPI
import SwiftUI

@Observable
@MainActor
public final class LoginViewModel: Sendable {
    enum Event {
        case loginSuccessful
    }

    private let authRepository: AuthRepository
    private let stringRepository: StringRepository

    var email: String = ""
    var password: String = ""
    var errorState: ErrorState = .invisible
    private(set) var isLoading: Bool = false
    private(set) var event: Event?
    
    var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    public init(
        authRepository: AuthRepository,
        stringRepository: StringRepository
    ) {
        self.authRepository = authRepository
        self.stringRepository = stringRepository
    }

    func localize(_ key: LSKey) -> String {
        stringRepository.get(key)
    }

    func login() async {
        guard isFormValid else {
            errorState = .visible(
                title: localize(LSKey.error),
                message: localize(LSKey.fillAllFields),
                buttonTitle: localize(LSKey.ok)
            )
            return
        }
        
        isLoading = true
        
        do {
            try await authRepository.login(email: email, password: password)
            event = .loginSuccessful
            clearFields()
        }
        catch {
            errorState = .visible(
                title: localize(LSKey.error),
                message: localize(LSKey.generalError),
                buttonTitle: localize(LSKey.ok)
            )
        }
        
        isLoading = false
    }

    private func clearFields() {
        email = ""
        password = ""
    }
}
