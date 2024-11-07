import Foundation
import MUCCoreAPI

public final class MUCClientMock: MUCClient, @unchecked Sendable {
    // Mock
    public var data: Data = Data()
    public var statusCode = 200
    public var headers = [String: String]()
    public var decodedData: Any?

    // Spy
    private(set) public var requestedURL: String?
    private(set) public var requestedHTTPMethod: HTTPMethod?
    private(set) public var requestedHeaders: [String: String]?
    
    public init() {}

    public func request(
        url: String,
        method: HTTPMethod,
        encodableBody: AnyEncodable?,
        headers: [String : String]?
    ) async throws -> MUCResponse {
        self.requestedURL = url
        self.requestedHTTPMethod = method
        self.requestedHeaders = headers

        return MUCResponseMock(
            data: data,
            statusCode: statusCode,
            headers: headers,
            decodedData: decodedData
        )
    }
}
