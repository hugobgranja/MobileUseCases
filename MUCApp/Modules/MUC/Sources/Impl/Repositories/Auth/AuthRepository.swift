import Foundation
import MUCAPI
import StorageAPI

public actor AuthRepository {
    private let tokenKey: String = "accessToken"
    private let tokenExpirationMargin: TimeInterval = 300
    private let endpoints: MUCEndpoints
    private let client: MUCClient
    private let storage: SecureStorage
    private var token: Token?
    private var tokenTask: Task<Token, Error>?
    
    init(
        endpoints: MUCEndpoints,
        client: MUCClient,
        storage: SecureStorage
    ) {
        self.endpoints = endpoints
        self.client = client
        self.storage = storage
    }
    
    func login(email: String, password: String) async throws {
        if tokenTask == nil {
            let url = endpoints.login
            let request = LoginRequest(email: email, password: password)
            
            tokenTask = Task { [client] in
                let response: MUCDataResponse<LoginResponse>
                response = try await client.request(url: url, method: .post, body: request)
                
                let token = response.decodedData.toToken()
                setToken(response.decodedData.toToken())
                
                return token
            }
        }
        
        defer { tokenTask = nil }
        
        _ = try await tokenTask?.value
    }
    
    func getAccessToken() async throws -> String {
        guard
            let token = getCachedToken()
        else {
            throw AuthRepositoryError.loginRequired
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
    
    private func setToken(_ token: Token) {
        self.token = token
        try? storage.set(key: tokenKey, value: token)
    }
    
    private func getCachedToken() -> Token? {
        return try? token ?? storage.get(key: tokenKey, type: Token.self)
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
                let response: MUCDataResponse<RefreshResponse>
                response = try await client.request(url: url, method: .post, body: request)
                
                let token = response.decodedData.toToken()
                setToken(token)
                
                return token
            }
        }
        
        defer { tokenTask = nil }
        
        return try await tokenTask!.value
    }
}
