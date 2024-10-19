import Foundation
import MUCAPI
import SwiftUI

@Observable
@MainActor
public final class LoginViewModel: Sendable {
    private let authRepository: AuthRepository
    var email: String = ""
    var password: String = ""
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String? = nil
    
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
        }
        catch {
            errorMessage = "Login failed"
        }
        
        isLoading = false
    }
}
