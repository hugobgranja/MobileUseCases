import Foundation
import MUCCoreAPI
@testable import MUCCoreImpl
import MUCCoreMocks
import Testing

struct MUCClientTests {
    struct Token: Codable, Equatable {
        let accessToken: String
        let expirationDate: Date
    }
    
    enum Constants {
        static let url = "http://localhost:8080"
        static let invalidUrl = ""
        static let responseHeaders = ["Content-Type": "application/json"]
        
        static let token = Token(
            accessToken: "123",
            expirationDate: Date.now.addingTimeInterval(3600)
        )
    }
    
    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()
    
    // MARK: Test throw on invalid url
    @Test(
        "Request throws on invalid url",
        arguments: [Self.makeBaseSut(), Self.makeAuthSut()]
    )
    func requestSendNoDataRetrieveNoDataThrowsOnInvalidUrl(
        urlRequester: URLRequesterMock,
        sut: MUCClient
    ) async throws {
        await #expect(
            throws: MUCClientError.invalidUrl,
            performing: {
                let _ = try await sut.request(
                    url: Constants.invalidUrl,
                    method: .get,
                    body: Constants.token,
                    headers: [:]
                )
            }
        )
    }

    @Test(
        "Request throws on server error",
        arguments: [Self.makeBaseSut(), Self.makeAuthSut()]
    )
    func requestSendNoDataRetrieveNoDataThrowsOnServerError(
        urlRequester: URLRequesterMock,
        sut: MUCClient
    ) async throws {
        urlRequester.setResponseStatusCode(500)

        await #expect(
            throws: MUCClientError.serverError(statusCode: 500),
            performing: {
                let _ = try await sut.request(
                    url: Constants.url,
                    method: .get,
                    body: Constants.token,
                    headers: [:]
                )
            }
        )
    }

    @Test(
        "Request throws on unauthorized",
        arguments: [Self.makeBaseSut(), Self.makeAuthSut()]
    )
    func requestSendNoDataRetrieveNoDataThrowsOnUnauthorized(
        urlRequester: URLRequesterMock,
        sut: MUCClient
    ) async throws {
        urlRequester.setResponseStatusCode(401)

        await #expect(
            throws: MUCClientError.unauthorized,
            performing: {
                let _ = try await sut.request(
                    url: Constants.url,
                    method: .get,
                    body: Constants.token,
                    headers: [:]
                )
            }
        )
    }
    
    @Test(
        "Request sends and returns expected values",
        arguments: [Self.makeBaseSut(), Self.makeAuthSut()]
    )
    func requestSendDataRetrieveDataSendsReturnsAsExpected(
        urlRequester: URLRequesterMock,
        sut: MUCClient
    ) async throws {
        // Arrange
        let tokenData = try Self.encoder.encode(Constants.token)
        urlRequester.setResponseData(tokenData)
        urlRequester.setResponseHeaders(Constants.responseHeaders)
        
        // Act
        let response = try await sut.request(
            url: Constants.url,
            method: .get,
            body: Constants.token,
            headers: [:]
        )
        
        //Assert
        #expect(urlRequester.requestedURL == Constants.url)
        #expect(urlRequester.requestedHTTPMethod == .get)
        
        let responseHeaders = try #require(response.headers)
        #expect(response.statusCode == 200)
        #expect(try response.decode(Token.self) == Constants.token)
        #expect(responseHeaders.isEqual(to: Constants.responseHeaders))
    }
}

extension MUCClientTests {
    private static func makeBaseSut() -> (URLRequesterMock, MUCClient) {
        let urlRequester = URLRequesterMock()
        
        let sut = MUCBaseClient(
            urlRequester: urlRequester,
            encoder: Self.encoder,
            decoder: Self.decoder
        )
        
        return (urlRequester, sut)
    }
    
    private static func makeAuthSut() -> (URLRequesterMock, MUCClient) {
        let (urlRequester, baseClient) = Self.makeBaseSut()
        
        let sut = MUCAuthClient(
            client: baseClient,
            authRepository: AuthRepositoryMock()
        )
        
        return (urlRequester, sut)
    }
}
