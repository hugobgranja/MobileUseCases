import Foundation

public enum MUCClientError: Error, Equatable {
    case invalidUrl
    case unauthorized
    case serverError(statusCode: Int)
    case invalidResponse
}
