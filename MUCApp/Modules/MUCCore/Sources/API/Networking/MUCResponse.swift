import Foundation

public struct MUCResponse: @unchecked Sendable {
    public let statusCode: Int?
    public let headers: [AnyHashable: Any]?
    
    public init(
        statusCode: Int?,
        headers: [AnyHashable : Any]?
    ) {
        self.statusCode = statusCode
        self.headers = headers
    }
}
