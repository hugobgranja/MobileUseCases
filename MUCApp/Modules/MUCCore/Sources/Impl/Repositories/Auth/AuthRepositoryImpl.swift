import Foundation
import MUCCoreAPI
import SecureStorageAPI

public actor AuthRepositoryImpl: AuthRepository {
    private let tokenKey: String = "accessToken"
    private let tokenExpirationMargin: TimeInterval = 300
    private let endpoints: MUCEndpoints
    private let client: MUCClient
    private let storage: AsyncSecureStorage
    private var token: Token?
    private var tokenTask: Task<Token, Error>?
    
    public init(
        endpoints: MUCEndpoints,
        client: MUCClient,
        storage: AsyncSecureStorage
    ) {
        self.endpoints = endpoints
        self.client = client
        self.storage = storage
    }
    
    public func login(email: String, password: String) async throws {
        if tokenTask == nil {
            let url = endpoints.login
            let request = LoginRequest(email: email, password: password)
            
            tokenTask = Task { [client] in
                let token = try await client.request(url: url, method: .post, body: request)
                    .decode(LoginResponse.self)
                    .toToken()

                await setToken(token)
                return token
            }
        }
        
        defer { tokenTask = nil }
        
        _ = try await tokenTask?.value
    }
    
    public func getAccessToken() async throws -> String {
        guard
            let token = await getCachedToken()
        else {
            throw AuthRepositoryError.loginRequired
        }

        if self.token == nil {
            self.token = token
        }

        if isAccessTokenValid() {
            return token.accessToken
        }
        else if isRefreshTokenValid() {
            return try await refresh(refreshToken: token.refreshToken).accessToken
        }
        else {
            throw AuthRepositoryError.loginRequired
        }
    }
    
    private func setToken(_ token: Token) async {
        self.token = token
        try? await storage.set(key: tokenKey, value: token)
    }
    
    private func getCachedToken() async -> Token? {
        if let token { return token }
        return try? await storage.get(key: tokenKey, type: Token.self)
    }
    
    private func isAccessTokenValid() -> Bool {
        guard let token else { return false }
        let paddedNow = Date.now.addingTimeInterval(tokenExpirationMargin)
        return token.accessTokenExpiration > paddedNow
    }
    
    private func isRefreshTokenValid() -> Bool {
        guard let token else { return false }
        let paddedNow = Date.now.addingTimeInterval(tokenExpirationMargin)
        return token.refreshTokenExpiration > paddedNow
    }
    
    private func refresh(refreshToken: String) async throws -> Token {
        if tokenTask == nil {
            let url = endpoints.refresh
            let request = RefreshRequest(refreshToken: refreshToken)
            
            tokenTask = Task { [client] in
                let token = try await client.request(url: url, method: .post, body: request)
                    .decode(RefreshResponse.self)
                    .toToken()
                
                await setToken(token)
                return token
            }
        }
        
        defer { tokenTask = nil }
        
        return try await tokenTask!.value
    }
}
