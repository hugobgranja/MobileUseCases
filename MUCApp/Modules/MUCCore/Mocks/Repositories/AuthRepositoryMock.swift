import Foundation
import MUCCoreAPI

public final class AuthRepositoryMock: AuthRepository, @unchecked Sendable {
    private var accessToken: String?
    public var isSuccessful: Bool = true

    public init(
        accessToken: String? = nil
    ) {
        self.accessToken = accessToken
    }
    
    public func login(email: String, password: String) async throws {
        if isSuccessful {
            accessToken = UUID().uuidString
        }
        else {
            throw MUCClientError.invalidResponse
        }
    }
    
    public func getAccessToken() async throws -> String {
        if let accessToken { return accessToken }
        let newToken = UUID().uuidString
        accessToken = newToken
        return newToken
    }
}
