import CoreUI
import MUCLoginAPI
import MUCLoginMocks
import MUCCoreMocks
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
                AppLogoView(width: 150, height: 150)
                    .symbolEffect(.bounce, options: .nonRepeating)

                Text(viewModel.localize(LSKey.title))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.top, 40)
                    .padding(.bottom, 4)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(viewModel.localize(LSKey.subtitle))
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

             
                TextField(viewModel.localize(LSKey.email), text: $viewModel.email)
                    .modifier(EmailFieldViewModifier())
                    .modifier(FormFieldViewModifier())
                
                PasswordFieldView(viewModel.localize(LSKey.password), password: $viewModel.password)
                    .modifier(FormFieldViewModifier())

                PrimaryButtonView(viewModel.localize(LSKey.primaryButtonTitle)) {
                    Task {
                        await viewModel.login()
                    }
                }
                .padding(.top, 10)
            }
            .padding(.horizontal, 40)
        }
        .overlayError($viewModel.errorState)
        .onChange(of: viewModel.event, initial: false) { _, new in handleEvent(new)
        }
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
    let viewModel = LoginViewModel(
        authRepository: AuthRepositoryMock(),
        stringRepository: StringRepositoryMock()
    )
    LoginView(viewModel: viewModel, navDelegate: LoginNavDelegateMock())
}
