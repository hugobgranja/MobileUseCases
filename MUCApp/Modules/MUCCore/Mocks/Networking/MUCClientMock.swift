import Foundation
import MUCCoreAPI

public final class MUCClientMock: MUCClient, @unchecked Sendable {
    // Mock
    public var statusCode = 200
    public var headers = [String: String]()
    public var responseData: Sendable?
    
    // Spy
    private(set) public var requestedURL: String?
    private(set) public var requestedHTTPMethod: HTTPMethod?
    private(set) public var requestedHeaders: [String: String]?
    
    public init() {}
    
    public func request(
        url: String,
        method: HTTPMethod,
        headers: [String: String]?
    ) async throws -> MUCResponse {
        self.requestedURL = url
        self.requestedHTTPMethod = method
        self.requestedHeaders = headers
        return MUCResponse(statusCode: statusCode, headers: headers)
    }
    
    public func request<U: Sendable>(
        url: String,
        method: HTTPMethod,
        headers: [String: String]?
    ) async throws -> MUCDataResponse<U> {
        self.requestedURL = url
        self.requestedHTTPMethod = method
        self.requestedHeaders = headers
        
        return MUCDataResponse(
            decodedData: responseData as! U,
            statusCode: statusCode,
            headers: headers
        )
    }
    
    public func request<T: Encodable>(
        url: String,
        method: HTTPMethod,
        body: T,
        headers: [String: String]?
    ) async throws -> MUCResponse {
        self.requestedURL = url
        self.requestedHTTPMethod = method
        self.requestedHeaders = headers
        return MUCResponse(statusCode: statusCode, headers: headers)
    }
    
    public func request<T: Encodable, U: Sendable>(
        url: String,
        method: HTTPMethod,
        body: T,
        headers: [String: String]?
    ) async throws -> MUCDataResponse<U> {
        self.requestedURL = url
        self.requestedHTTPMethod = method
        self.requestedHeaders = headers
        
        return MUCDataResponse(
            decodedData: responseData as! U,
            statusCode: statusCode,
            headers: headers
        )
    }
}
