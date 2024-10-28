import Foundation

public struct MUCDataResponse<U: Sendable>: @unchecked Sendable {
    public let decodedData: U
    public let statusCode: Int?
    public let headers: [AnyHashable: Any]?
    
    public init(
        decodedData: U,
        statusCode: Int?,
        headers: [AnyHashable : Any]?
    ) {
        self.decodedData = decodedData
        self.statusCode = statusCode
        self.headers = headers
    }
}
