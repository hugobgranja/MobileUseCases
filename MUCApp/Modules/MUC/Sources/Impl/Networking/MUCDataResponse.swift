import Foundation

struct MUCDataResponse<U: Sendable>: @unchecked Sendable {
    let decodedData: U
    let statusCode: Int?
    let headers: [AnyHashable: Any]?
}
