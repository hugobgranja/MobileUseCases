import MUCAPI
import MUCMocks
import SwiftUI

public struct LoginView: View {
    @Bindable var viewModel: LoginViewModel
    private var navDelegate: any LoginNavDelegate
    
    public init(
        viewModel: LoginViewModel,
        navDelegate: any LoginNavDelegate
    ) {
        self.viewModel = viewModel
        self.navDelegate = navDelegate
    }

    public var body: some View {
        ZStack {
            MUCGradientView()
            
            VStack {
                Image(systemName: "music.note.list")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundStyle(.black, .blue)
                    .symbolEffect(.bounce, options: .nonRepeating)
                
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.top, 40)
                    .padding(.bottom, 4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Sign in to continue.")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
             
                TextField("Email", text: $viewModel.email)
                    .modifier(EmailFieldViewModifier())
                    .modifier(FormFieldViewModifier())
                
                PasswordFieldView("Password", password: $viewModel.password)
                    .modifier(FormFieldViewModifier())
                
                Button(action: {
                    Task {
                        await viewModel.login()
                    }
                }) {
                    PrimaryButtonView("Login")
                }
                .padding(.top, 10)
            }
            .padding(.horizontal, 40)
        }
        .onChange(of: viewModel.event, initial: false) { _, new in handleEvent(new) }
    }
    
    private func handleEvent(_ event: LoginViewModel.Event?) {
        guard let event else { return }
        
        switch event {
        case .loginSuccessful:
            navDelegate.onLoginSuccessful()
        }
    }
}

#Preview {
    let authRepository = AuthRepositoryMock()
    let viewModel = LoginViewModel(authRepository: authRepository)
    LoginView(viewModel: viewModel, navDelegate: LoginNavDelegateMock())
}
