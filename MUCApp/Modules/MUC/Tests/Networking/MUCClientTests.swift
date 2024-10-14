import Foundation
import MUCAPI
@testable import MUCImpl
import MUCMocks
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
        "Request sending no data and retrieving throws on invalid url",
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
                    headers: [:]
                )
            }
        )
    }
    
    @Test(
        "Request sending no data and retrieving data throws on invalid url",
        arguments: [Self.makeBaseSut(), Self.makeAuthSut()]
    )
    func requestSendNoDataRetrieveDataThrowsOnInvalidUrl(
        urlRequester: URLRequesterMock,
        sut: MUCClient
    ) async throws {
        await #expect(
            throws: MUCClientError.invalidUrl,
            performing: {
                let _: MUCDataResponse<Token> = try await sut.request(
                    url: Constants.invalidUrl,
                    method: .get,
                    headers: [:]
                )
            }
        )
    }
    
    @Test(
        "Requests sending data and retrieving no data sends throws on invalid url",
        arguments: [Self.makeBaseSut(), Self.makeAuthSut()]
    )
    func requestSendDataRetrieveNoDataThrowsOnInvalidUrl(
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
        "Request sending data and retrieving data sends throws on invalid url",
        arguments: [Self.makeBaseSut(), Self.makeAuthSut()]
    )
    func requestSendDataRetrieveDataThrowsOnInvalidUrl(
        urlRequester: URLRequesterMock,
        sut: MUCClient
    ) async throws {
        await #expect(
            throws: MUCClientError.invalidUrl,
            performing: {
                let _: MUCDataResponse<Token> = try await sut.request(
                    url: Constants.invalidUrl,
                    method: .get,
                    body: Constants.token,
                    headers: [:]
                )
            }
        )
    }
    
    
    // MARK: Test data sent and returned
    @Test(
        "Request sending no data and retrieving no data sends and returns expected values",
        arguments: [Self.makeBaseSut(), Self.makeAuthSut()]
    )
    func requestSendNoDataRetrieveNoDataSendsReturnsAsExpected(
        urlRequester: URLRequesterMock,
        sut: MUCClient
    ) async throws {
        // Arrange
        urlRequester.setResponseHeaders(Constants.responseHeaders)
        
        // Act
        let response = try await sut.request(
            url: Constants.url,
            method: .get,
            headers: [:]
        )
        
        // Assert
        #expect(urlRequester.requestedURL == Constants.url)
        #expect(urlRequester.requestedHTTPMethod == .get)
        
        let responseHeaders = try #require(response.headers)
        #expect(response.statusCode == 200)
        #expect(responseHeaders.isEqual(to: Constants.responseHeaders))
    }
    
    @Test(
        "Request sending no data and retrieving data sends and returns expected values",
        arguments: [Self.makeBaseSut(), Self.makeAuthSut()]
    )
    func requestSendNoDataRetrieveDataSendsReturnsAsExpected(
        urlRequester: URLRequesterMock,
        sut: MUCClient
    ) async throws {
        // Arrange
        let tokenData = try Self.encoder.encode(Constants.token)
        urlRequester.setResponseData(tokenData)
        urlRequester.setResponseHeaders(Constants.responseHeaders)
        
        // Act
        let response: MUCDataResponse<Token> = try await sut.request(
            url: Constants.url,
            method: .get,
            headers: [:]
        )
        
        // Assert
        #expect(urlRequester.requestedURL == Constants.url)
        #expect(urlRequester.requestedHTTPMethod == .get)
        
        let responseHeaders = try #require(response.headers)
        #expect(response.statusCode == 200)
        #expect(response.decodedData == Constants.token)
        #expect(responseHeaders.isEqual(to: Constants.responseHeaders))
    }
    
    @Test(
        "Requests sending data and retrieving no data sends and returns expected values",
        arguments: [Self.makeBaseSut(), Self.makeAuthSut()]
    )
    func requestSendDataRetrieveNoDataSendsReturnsAsExpected(
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
        
        // Assert
        #expect(urlRequester.requestedURL == Constants.url)
        #expect(urlRequester.requestedHTTPMethod == .get)
        
        let responseHeaders = try #require(response.headers)
        #expect(response.statusCode == 200)
        #expect(responseHeaders.isEqual(to: Constants.responseHeaders))
    }
    
    @Test(
        "Request sending data and retrieving data sends and returns expected values",
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
        let response: MUCDataResponse<Token> = try await sut.request(
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
        #expect(response.decodedData == Constants.token)
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
