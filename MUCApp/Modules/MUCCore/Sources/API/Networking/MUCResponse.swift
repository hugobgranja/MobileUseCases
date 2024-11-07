import Foundation

public protocol MUCResponse: Sendable {
    var data: Data { get }
    var statusCode: Int? { get }
    var headers: [AnyHashable: Any]? { get }

    func decode<T: Decodable>(_ type: T.Type) throws -> T
}
