import Foundation

protocol MUCClient {
    func request(
        url: String,
        method: HTTPMethod,
        headers: [String: String]?
    ) async throws -> MUCResponse
    
    func request<U: Decodable>(
        url: String,
        method: HTTPMethod,
        headers: [String: String]?
    ) async throws -> MUCDataResponse<U>
    
    func request<T: Encodable>(
        url: String,
        method: HTTPMethod,
        body: T,
        headers: [String: String]?
    ) async throws -> MUCResponse
    
    func request<T: Encodable, U: Decodable>(
        url: String,
        method: HTTPMethod,
        body: T,
        headers: [String: String]?
    ) async throws -> MUCDataResponse<U>
}

extension MUCClient {
    func request(
        url: String,
        method: HTTPMethod,
        headers: [String: String]? = nil
    ) async throws -> MUCResponse {
        return try await request(url: url, method: method, headers: nil)
    }
    
    func request<U: Decodable>(
        url: String,
        method: HTTPMethod,
        headers: [String: String]? = nil
    ) async throws -> MUCDataResponse<U> {
        return try await request(url: url, method: method, headers: nil)
    }
    
    func request<T: Encodable>(
        url: String,
        method: HTTPMethod,
        body: T,
        headers: [String: String]? = nil
    ) async throws -> MUCResponse {
        return try await request(url: url, method: method, body: body, headers: nil)
    }
    
    func request<T: Encodable, U: Decodable>(
        url: String,
        method: HTTPMethod,
        body: T,
        headers: [String: String]? = nil
    ) async throws -> MUCDataResponse<U> {
        return try await request(url: url, method: method, body: body, headers: nil)
    }
}
