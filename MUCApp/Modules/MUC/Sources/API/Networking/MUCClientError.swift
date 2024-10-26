import Foundation

public enum MUCClientError: Error {
    case invalidUrl
    case unauthorized
    case serverError(statusCode: Int)
    case invalidResponse
}
