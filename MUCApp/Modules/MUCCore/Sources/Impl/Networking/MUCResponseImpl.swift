import Foundation
import MUCCoreAPI

public struct MUCResponseImpl: MUCResponse, @unchecked Sendable {
    public let data: Data
    public let statusCode: Int?
    public let headers: [AnyHashable: Any]?
    private let decoder: JSONDecoder

    public init(
        data: Data,
        statusCode: Int?,
        headers: [AnyHashable: Any]?,
        decoder: JSONDecoder
    ) {
        self.data = data
        self.statusCode = statusCode
        self.headers = headers
        self.decoder = decoder
    }

    public func decode<T: Decodable>(_ type: T.Type) throws -> T {
        return try decoder.decode(type, from: data)
    }
}
