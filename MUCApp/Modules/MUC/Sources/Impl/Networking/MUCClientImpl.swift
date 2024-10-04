import Foundation

final class MUCClientImpl: MUCClient {
    private let urlSession: URLSession
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    init(
        urlSession: URLSession,
        encoder: JSONEncoder,
        decoder: JSONDecoder
    ) {
        self.urlSession = urlSession
        self.encoder = encoder
        self.decoder = decoder
    }
    
    // Request that sends no data and retrieves no data
    func request(
        url: String,
        method: HTTPMethod,
        headers: [String: String]? = nil
    ) async throws -> MUCResponse {
        let request = try makeRequest(
            url: url,
            method: method,
            headers: headers
        )
        
        let (_, response) = try await urlSession.data(for: request)
        return makeResponse(response: response)
    }
    
    // Request that sends no data and retrieves data
    func request<U: Decodable>(
        url: String,
        method: HTTPMethod,
        headers: [String: String]? = nil
    ) async throws -> MUCDataResponse<U> {
        let request = try makeRequest(
            url: url,
            method: method,
            headers: headers
        )
        
        let (data, response) = try await urlSession.data(for: request)
        return try makeResponse(data: data, response: response)
    }
    
    // Requests that sends data and retrieves no data
    func request<T: Encodable>(
        url: String,
        method: HTTPMethod,
        body: T,
        headers: [String: String]? = nil
    ) async throws -> MUCResponse {
        let request = try makeRequest(
            url: url,
            method: method,
            body: body,
            headers: headers
        )
        
        let (_, response) = try await urlSession.data(for: request)
        return makeResponse(response: response)
    }
    
    // Request that sends data and retrieves data
    func request<T: Encodable, U: Decodable>(
        url: String,
        method: HTTPMethod,
        body: T,
        headers: [String: String]? = nil
    ) async throws -> MUCDataResponse<U> {
        let request = try makeRequest(
            url: url,
            method: method,
            body: body,
            headers: headers
        )
        
        let (data, response) = try await urlSession.data(for: request)
        return try makeResponse(data: data, response: response)
    }
    
    private func makeRequest(
        url: String,
        method: HTTPMethod,
        headers: [String: String]?
    ) throws -> URLRequest {
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        // Create URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Set headers
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return request
    }
    
    private func makeRequest<T: Encodable>(
        url: String,
        method: HTTPMethod,
        body: T,
        headers: [String: String]?
    ) throws -> URLRequest {
        var request = try makeRequest(url: url, method: method, headers: headers)
        try attachBody(body, to: &request)
        return request
    }
    
    private func attachBody<T: Encodable>(
        _ body: T,
        to request: inout URLRequest
    ) throws {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try encoder.encode(body)
    }
    
    private func makeResponse<U: Decodable>(
        data: Data,
        response: URLResponse
    ) throws -> MUCDataResponse<U> {
        let response = response as? HTTPURLResponse
        
        return MUCDataResponse<U>(
            decodedData: try decoder.decode(U.self, from: data),
            statusCode: response?.statusCode,
            headers: response?.allHeaderFields
        )
    }
    
    private func makeResponse(response: URLResponse) -> MUCResponse {
        let response = response as? HTTPURLResponse
        
        return MUCResponse(
            statusCode: response?.statusCode,
            headers: response?.allHeaderFields
        )
    }
}
