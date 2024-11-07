import Foundation
import MUCCoreAPI
@testable import MUCCoreImpl
import MUCCoreMocks
import Testing

struct MUCBaseClientTests {
    struct Token: Codable, Equatable {
        let accessToken: String
        let expirationDate: Date
    }
    
    enum Constants {
        static let url = "http://localhost:8080"
        static let acceptHeader = ["Accept": "application/json"]
        
        static let token = Token(
            accessToken: "123",
            expirationDate: Date.now.addingTimeInterval(3600)
        )
    }
    
    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()
    private let urlRequester = URLRequesterMock()
    private let sut: MUCClient
    
    init() {
        self.sut = MUCBaseClient(
            urlRequester: urlRequester,
            encoder: Self.encoder,
            decoder: Self.decoder
        )
    }
    
    @Test(
        "Request sending no data sends correct headers",
        arguments: [nil, [:], Constants.acceptHeader]
    )
    func requestSendingNoDataSendsCorrectHeaders(
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
        let expectedHeaders = [:].mergingKeepingCurrent(requestHeaders)
        #expect(requestedHeaders == expectedHeaders)
    }

    @Test(
        "Request sending data sends correct headers",
        arguments: [nil, [:], Constants.acceptHeader]
    )
    func requestSendingDataSendsCorrectHeaders(
        requestHeaders: [String: String]?
    ) async throws {
        // Arrange
        let contentTypeHeader = ["Content-Type": "application/json"]

        // Act
        let _ = try await sut.request(
            url: Constants.url,
            method: .get,
            body: Constants.token,
            headers: requestHeaders
        )
        
        // Assert
        let requestedHeaders = try #require(urlRequester.requestedHeaders)
        let expectedHeaders = contentTypeHeader.mergingKeepingCurrent(requestHeaders)
        #expect(requestedHeaders == expectedHeaders)
    }
}
