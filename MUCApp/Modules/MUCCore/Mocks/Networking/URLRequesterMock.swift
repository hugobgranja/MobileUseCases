import Foundation
import MUCCoreAPI

public final class URLRequesterMock: URLRequester, @unchecked Sendable {
    // Mock
    private static let httpVersion = "HTTP/1.1"
    private var responseData: Data = Data()
    private var responseStatusCode: Int = 200
    private var responseHeaders: [String: String] = [:]
    
    // Spy
    private(set) public var requestedURL: String?
    private(set) public var requestedHTTPMethod: HTTPMethod?
    private(set) public var requestedHeaders: [String: String]?
    
    
    public init() {}
    
    public init(
        responseData: Data,
        responseStatusCode: Int = 200,
        responseHeaders: [String: String] = [:]
    ) {
        self.responseData = responseData
        self.responseStatusCode = responseStatusCode
        self.responseHeaders = responseHeaders
    }
    
    public func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        self.requestedURL = request.url?.absoluteString
        self.requestedHTTPMethod = request.typedHttpMethod
        self.requestedHeaders = request.allHTTPHeaderFields
        
        let response = HTTPURLResponse(
            url: request.url!,
            statusCode: responseStatusCode,
            httpVersion: Self.httpVersion,
            headerFields: responseHeaders
        )!
        
        return (responseData, response)
    }
    
    public func setResponseData(_ data: Data) {
        self.responseData = data
    }
    
    public func setResponseStatusCode(_ statusCode: Int) {
        self.responseStatusCode = statusCode
    }
    
    public func setResponseHeaders(_ headers: [String: String]) {
        self.responseHeaders = headers
    }
}
