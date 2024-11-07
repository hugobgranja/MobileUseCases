import Foundation
import MUCCoreAPI

public struct MUCResponseMock: MUCResponse, @unchecked Sendable {
    public let data: Data
    public let statusCode: Int?
    public let headers: [AnyHashable : Any]?
    public let decodedData: Any?

    public init(
        data: Data,
        statusCode: Int? = nil,
        headers: [AnyHashable : Any]? = nil,
        decodedData: Any? = nil
    ) {
        self.data = data
        self.statusCode = statusCode
        self.headers = headers
        self.decodedData = decodedData
    }

    public func decode<T: Decodable>(_ type: T.Type) throws -> T {
        return decodedData as! T
    }
}
