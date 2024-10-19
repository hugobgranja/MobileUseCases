import MUCMocks
import SwiftUI

public struct LoginView: View {
    @Bindable var viewModel: LoginViewModel
    
    public init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        Form {
            Section(header: Text("Login")) {
                TextField("Email", text: $viewModel.email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $viewModel.password)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    Task {
                        await viewModel.login()
                    }
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Login")
                    }
                }
                .disabled(!viewModel.isFormValid || viewModel.isLoading)
            }
        }
    }
}

#Preview {
    let authRepository = AuthRepositoryMock()
    let viewModel = LoginViewModel(authRepository: authRepository)
    LoginView(viewModel: viewModel)
}
