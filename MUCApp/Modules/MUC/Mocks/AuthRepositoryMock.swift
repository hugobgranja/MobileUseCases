import Foundation
import MUCAPI

public actor AuthRepositoryMock: AuthRepository {
    private var accessToken: String?
    
    public init(
        accessToken: String? = nil
    ) {
        self.accessToken = accessToken
    }
    
    public func login(email: String, password: String) async throws {
        accessToken = UUID().uuidString
    }
    
    public func getAccessToken() async throws -> String {
        if let accessToken { return accessToken }
        let newToken = UUID().uuidString
        accessToken = newToken
        return newToken
    }
}
