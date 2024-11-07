import Foundation
import MUCCoreAPI
@testable import MUCCoreImpl
import MUCCoreMocks
import Testing

struct MUCAuthClientTests {
    struct Token: Codable, Equatable {
        let accessToken: String
        let expirationDate: Date
    }
    
    enum Constants {
        static let url = "http://localhost:8080"
        static let accessToken = "123"
        static let acceptHeader = ["Accept": "application/json"]
        static let authHeader = ["Authorization": "Bearer \(accessToken)"]
        
        static let headersForNonEmptyBodyRequest = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        static let token = Token(
            accessToken: "123",
            expirationDate: Date.now.addingTimeInterval(3600)
        )
    }
    
    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()
    private let urlRequester = URLRequesterMock()
    private let authRepositoryMock: AuthRepositoryMock
    private let sut: MUCClient
    
    init() {
        self.authRepositoryMock = AuthRepositoryMock(
            accessToken: Constants.accessToken
        )
        
        let baseClient = MUCBaseClient(
            urlRequester: urlRequester,
            encoder: Self.encoder,
            decoder: Self.decoder
        )
        
        self.sut = MUCAuthClient(
            client: baseClient,
            authRepository: authRepositoryMock
        )
    }
    
    @Test(
        "Request sends authorization header",
        arguments: [nil, [:], Constants.acceptHeader]
    )
    func requestSendsAuthHeader(
        requestHeaders: [String: String]?
    ) async throws {
        // Act
        let _ = try await sut.request(
            url: Constants.url,
            method: .get,
            headers: requestHeaders
        )
        
        // Assert
        let requestedHeaders = try #require(urlRequester.requestedHeaders)
        let expectedHeaders = Constants.authHeader.mergingKeepingCurrent(requestHeaders)
        #expect(requestedHeaders == expectedHeaders)
    }
}
