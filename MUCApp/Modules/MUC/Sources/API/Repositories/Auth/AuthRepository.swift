import Foundation

public protocol AuthRepository: Sendable {
    func login(email: String, password: String) async throws
    func getAccessToken() async throws -> String
}
