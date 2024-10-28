import Foundation
import MUCCoreAPI
import SwiftUI

@Observable
@MainActor
public final class LoginViewModel: Sendable {
    enum Event {
        case loginSuccessful
    }
    
    private let authRepository: AuthRepository
    var email: String = ""
    var password: String = ""
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String?
    private(set) var event: Event?
    
    var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func login() async {
        guard isFormValid else {
            errorMessage = "Please fill in all fields."
            return
        }
        
        isLoading = true
        
        do {
            try await authRepository.login(email: email, password: password)
            event = .loginSuccessful
            clearFields()
        }
        catch {
            errorMessage = "There was a problem processing your login.\nPlease try again."
        }
        
        isLoading = false
    }

    private func clearFields() {
        email = ""
        password = ""
    }
}
