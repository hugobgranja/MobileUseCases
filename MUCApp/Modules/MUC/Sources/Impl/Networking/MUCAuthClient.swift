import Foundation

final class MUCAuthClient: MUCClient {
    private let client: MUCClient
    private let authRepository: AuthRepository
    
    init(
        client: MUCClient,
        authRepository: AuthRepository
    ) {
        self.client = client
        self.authRepository = authRepository
    }
    
    func request(
        url: String,
        method: HTTPMethod,
        headers: [String: String]?
    ) async throws -> MUCResponse {
        let authenticatedHeaders = try await attachBearerToken(to: headers)
        return try await client.request(url: url, method: method, headers: authenticatedHeaders)
    }
    
    func request<U: Decodable>(
        url: String,
        method: HTTPMethod,
        headers: [String: String]?
    ) async throws -> MUCDataResponse<U> {
        let authenticatedHeaders = try await attachBearerToken(to: headers)
        return try await client.request(url: url, method: method, headers: authenticatedHeaders)
    }
    
    func request<T: Encodable>(
        url: String,
        method: HTTPMethod,
        body: T,
        headers: [String: String]?
    ) async throws -> MUCResponse {
        let authenticatedHeaders = try await attachBearerToken(to: headers)
        return try await client.request(url: url, method: method, body: body, headers: authenticatedHeaders)
    }
    
    func request<T: Encodable, U: Decodable>(
        url: String,
        method: HTTPMethod,
        body: T,
        headers: [String: String]?
    ) async throws -> MUCDataResponse<U> {
        let authenticatedHeaders = try await attachBearerToken(to: headers)
        return try await client.request(url: url, method: method, body: body, headers: authenticatedHeaders)
    }
    
    private func attachBearerToken(to headers: [String: String]?) async throws -> [String: String] {
        let token = try await authRepository.getAccessToken()
        var headers = headers ?? [:]
        headers["Authorization"] = "Bearer \(token)"
        return headers
    }
}
