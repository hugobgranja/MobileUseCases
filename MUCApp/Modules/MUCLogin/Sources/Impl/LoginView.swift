import CoreUI
import MUCLoginAPI
import MUCCoreAPI
import MUCCoreMocks
import SwiftUI

public struct LoginView: View {
    @Environment(\.theme) private var theme
    @Bindable var viewModel: LoginViewModel
    private weak var navDelegate: (any LoginNavDelegate)?
    private let stringRepository: StringRepository

    public init(
        viewModel: LoginViewModel,
        navDelegate: (any LoginNavDelegate)?,
        stringRepository: StringRepository
    ) {
        self.viewModel = viewModel
        self.navDelegate = navDelegate
        self.stringRepository = stringRepository
    }

    public var body: some View {
        ZStack {
            MUCGradientView()

            VStack {
                AppLogoView(width: 150, height: 150)
                    .symbolEffect(.bounce, options: .nonRepeating)

                Text(stringRepository.get(LSKey.title))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(theme.textPrimary)
                    .padding(.top, 40)
                    .padding(.bottom, 4)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(stringRepository.get(LSKey.subtitle))
                    .font(.headline)
                    .foregroundStyle(theme.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                TextField(stringRepository.get(LSKey.email), text: $viewModel.email)
                    .modifier(EmailFieldViewModifier())
                    .modifier(FormFieldViewModifier())
                
                PasswordFieldView(stringRepository.get(LSKey.password), password: $viewModel.password)
                    .modifier(FormFieldViewModifier())

                MUCButtonView(stringRepository.get(LSKey.primaryButtonTitle)) {
                    Task {
                        await viewModel.login()
                    }
                }
                .padding(.top, 10)
            }
            .padding(.horizontal, 40)

            MUCProgressView(isLoading: viewModel.isLoading)
        }
        .overlayError($viewModel.errorState)
        .onChange(of: viewModel.event, initial: false) { _, new in handleEvent(new)
        }
    }
    
    private func handleEvent(_ event: LoginViewModel.Event?) {
        guard let event else { return }
        
        switch event {
        case .loginSuccessful:
            navDelegate?.onLoginSuccessful()
        }
    }
}

#Preview {
    let viewModel = LoginViewModel(
        authRepository: AuthRepositoryMock(),
        stringRepository: StringRepositoryMock()
    )
    LoginView(
        viewModel: viewModel,
        navDelegate: nil,
        stringRepository: StringRepositoryMock()
    )
}
