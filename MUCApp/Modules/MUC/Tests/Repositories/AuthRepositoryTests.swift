import Foundation
import MUCAPI
@testable import MUCImpl
import MUCMocks
import SecureStorageMocks
import Testing

struct AuthRepositoryTests {
    private let endpoints = MUCEndpointsMock()
    private let client = MUCClientMock()
    private let authRepository: AuthRepository
    
    init() {
        self.authRepository = AuthRepositoryImpl(
            endpoints: endpoints,
            client: client,
            storage: AsyncSecureStorageMock()
        )
    }
    
    @Test("Login sends correct params")
    func loginSendsCorrectParams() async throws {
        // Arrange
        let loginResponse = LoginResponse(
            accessToken: "accessToken",
            accessTokenExpiration: Date.now.addingTimeInterval(3600),
            refreshToken: "refreshToken",
            refreshTokenExpiration: Date.now.addingTimeInterval(3600)
        )
        
        client.responseData = loginResponse
        
        // Act
        try await authRepository.login(email: "a@muctest.com", password: "123")
        
        // Assert
        #expect(client.requestedURL == endpoints.login)
        #expect(client.requestedHTTPMethod == .post)
        #expect(client.requestedHeaders == nil)
    }
    
    @Test("Get access token throws error when called before login")
    func getAccessTokenWhenCalledBeforeLoginThenThrowsError() async throws {
        await #expect(
            throws: AuthRepositoryError.loginRequired,
            performing: {
                try await authRepository.getAccessToken()
            }
        )
    }
    
    @Test("Get access token returns access token when valid")
    func getAccessTokenGivenLoginWhenAccessValidReturnsAccessToken() async throws {
        // Arrange
        let loginResponse = LoginResponse(
            accessToken: "accessToken",
            accessTokenExpiration: Date.now.addingTimeInterval(3600),
            refreshToken: "refreshToken",
            refreshTokenExpiration: Date.now.addingTimeInterval(3600)
        )
        
        // Act
        client.responseData = loginResponse
        try await authRepository.login(email: "a@muctest.com", password: "123")
        let accessToken = try await authRepository.getAccessToken()
        
        // Assert
        #expect(accessToken == loginResponse.accessToken)
    }
    
    @Test("Get access token tries to refresh when access token invalid")
    func getAccessTokenGivenLoginWhenAccessInvalidRefreshes() async throws {
        // Arrange
        let loginResponse = LoginResponse(
            accessToken: "accessToken",
            accessTokenExpiration: Date.now.addingTimeInterval(-3600),
            refreshToken: "refreshToken",
            refreshTokenExpiration: Date.now.addingTimeInterval(3600)
        )
        
        let refreshResponse = RefreshResponse(
            accessToken: "refreshedAccessToken",
            accessTokenExpiration: Date.now.addingTimeInterval(3600),
            refreshToken: "refreshToken",
            refreshTokenExpiration: Date.now.addingTimeInterval(3600)
        )
        
        // Act
        client.responseData = loginResponse
        try await authRepository.login(email: "a@muctest.com", password: "123")
        
        client.responseData = refreshResponse
        let accessToken = try await authRepository.getAccessToken()
        
        // Assert
        #expect(client.requestedURL == endpoints.refresh)
        #expect(client.requestedHTTPMethod == .post)
        #expect(client.requestedHeaders == nil)
        #expect(accessToken == refreshResponse.accessToken)
    }
    
    @Test("Get access token after login throws if access token and refresh token invalid")
    func getAccessTokenGivenLoginWhenAccessAndRefreshInvalidThrows() async throws {
        // Arrange
        let loginResponse = LoginResponse(
            accessToken: "accessToken",
            accessTokenExpiration: Date.now.addingTimeInterval(-3600),
            refreshToken: "refreshToken",
            refreshTokenExpiration: Date.now.addingTimeInterval(-3600)
        )
        
        // Act
        client.responseData = loginResponse
        try await authRepository.login(email: "a@muctest.com", password: "123")
        
        // Assert
        await #expect(
            throws: AuthRepositoryError.loginRequired,
            performing: {
                try await authRepository.getAccessToken()
            }
        )
    }
}
