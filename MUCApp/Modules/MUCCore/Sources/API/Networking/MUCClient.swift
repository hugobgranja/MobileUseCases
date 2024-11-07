import Foundation

public protocol MUCClient: Sendable {
    func request(
        url: String,
        method: HTTPMethod,
        encodableBody: AnyEncodable?,
        headers: [String: String]?
    ) async throws -> MUCResponse
}

public extension MUCClient {
    func request<T: Encodable>(
        url: String,
        method: HTTPMethod,
        body: T,
        headers: [String: String]? = nil
    ) async throws -> MUCResponse {
        return try await request(
            url: url,
            method: method,
            encodableBody: AnyEncodable(body),
            headers: headers
        )
    }

    func request(
        url: String,
        method: HTTPMethod
    ) async throws -> MUCResponse {
        return try await request(
            url: url,
            method: method,
            encodableBody: nil,
            headers: nil
        )
    }

    func request(
        url: String,
        method: HTTPMethod,
        encodableBody: AnyEncodable?
    ) async throws -> MUCResponse {
        return try await request(
            url: url,
            method: method,
            encodableBody: encodableBody,
            headers: nil
        )
    }

    func request(
        url: String,
        method: HTTPMethod,
        headers: [String: String]?
    ) async throws -> MUCResponse {
        return try await request(
            url: url,
            method: method,
            encodableBody: nil,
            headers: headers
        )
    }
}
