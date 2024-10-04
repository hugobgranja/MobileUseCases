import Foundation

struct MUCResponse: @unchecked Sendable {
    let statusCode: Int?
    let headers: [AnyHashable: Any]?
}
