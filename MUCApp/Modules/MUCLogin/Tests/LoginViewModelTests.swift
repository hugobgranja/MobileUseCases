import CoreUI
import MUCCoreMocks
@testable import MUCLoginImpl
import Testing

@MainActor
struct LoginViewModelTests {
    private let authRepository = AuthRepositoryMock()
    private let sut: LoginViewModel

    init() {
        self.sut = LoginViewModel(
            authRepository: authRepository,
            stringRepository: StringRepositoryMock()
        )
    }

    @Test("IsFormValid returns true when email and password fields are filled")
    func isFormValidGivenFieldsFilledThenValid() {
        sut.email = "hello@world.com"
        sut.password = "qwert"
        #expect(sut.isFormValid)
    }

    @Test("IsFormValid returns false when email field is empty")
    func isFormValidGivenEmailEmptyThenInvalid() {
        sut.email = ""
        sut.password = "qwert"
        #expect(!sut.isFormValid)
    }

    @Test("IsFormValid returns false when password field is empty")
    func isFormValidGivenPasswordEmptyThenInvalid() {
        sut.email = "hello@world.com"
        sut.password = ""
        #expect(!sut.isFormValid)
    }

    @Test("Login when successful sets event to loginSuccessful")
    func LoginWhenSuccessfulThenEventIsLoginSuccessful() async throws {
        sut.email = "hello@world.com"
        sut.password = "qwert"
        await sut.login()
        _ = try #require(try await authRepository.getAccessToken())
    }

    @Test("Login when successful clears fields")
    func LoginWhenSuccessfulThenClearsFields() async throws {
        sut.email = "hello@world.com"
        sut.password = "qwert"
        await sut.login()
        #expect(sut.email.isEmpty)
        #expect(sut.password.isEmpty)
    }

    @Test("Login when successful then error state is invisible")
    func LoginWhenSuccessfulThenNoErrorStateIsSet() async throws {
        sut.email = "hello@world.com"
        sut.password = "qwert"
        await sut.login()
        #expect(sut.errorState == .invisible)
    }

    @Test("Login given form not valid sets error view")
    func LoginGivenFormNotValidThenSetsError() async throws {
        let expectedErrorState = ErrorState.visible(
            title: LSKey.error.rawValue,
            message: LSKey.fillAllFields.rawValue,
            buttonTitle: LSKey.ok.rawValue
        )

        sut.email = "hello@world.com"
        sut.password = ""
        await sut.login()
        #expect(sut.errorState == expectedErrorState)
    }

    @Test("Login when server error sets error view")
    func LoginWhenServerErrorThenSetsError() async throws {
        let expectedErrorState = ErrorState.visible(
            title: LSKey.error.rawValue,
            message: LSKey.generalError.rawValue,
            buttonTitle: LSKey.ok.rawValue
        )

        sut.email = "hello@world.com"
        sut.password = "qwert"

        authRepository.isSuccessful = false
        await sut.login()
        #expect(sut.errorState == expectedErrorState)
    }
}
