import Foundation
import MUCCoreAPI

public final class MUCAuthClient: MUCClient {
    private let client: MUCClient
    private let authRepository: AuthRepository
    
    public init(
        client: MUCClient,
        authRepository: AuthRepository
    ) {
        self.client = client
        self.authRepository = authRepository
    }

    public func request(
        url: String,
        method: HTTPMethod,
        encodableBody: AnyEncodable?,
        headers: [String: String]?
    ) async throws -> MUCResponse {
        let authenticatedHeaders = try await attachBearerToken(to: headers)

        return try await client.request(
            url: url,
            method: method,
            encodableBody: encodableBody,
            headers: authenticatedHeaders
        )
    }

    private func attachBearerToken(to headers: [String: String]?) async throws -> [String: String] {
        let token = try await authRepository.getAccessToken()
        var headers = headers ?? [:]
        headers["Authorization"] = "Bearer \(token)"
        return headers
    }
}
