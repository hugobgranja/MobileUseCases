import Foundation
import MUCCoreAPI

public final class MUCBaseClient: MUCClient {
    private let urlRequester: URLRequester
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    public init(
        urlRequester: URLRequester,
        encoder: JSONEncoder,
        decoder: JSONDecoder
    ) {
        self.urlRequester = urlRequester
        self.encoder = encoder
        self.decoder = decoder
    }

    public func request(
        url: String,
        method: HTTPMethod,
        encodableBody: AnyEncodable? = nil,
        headers: [String: String]? = nil
    ) async throws -> MUCResponse {
        let request = try makeRequest(
            url: url,
            method: method,
            encodableBody: encodableBody,
            headers: headers
        )

        let (data, response) = try await urlRequester.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw MUCClientError.invalidResponse
        }

        try validateResponse(statusCode: response.statusCode)

        return MUCResponseImpl(
            data: data,
            statusCode: response.statusCode,
            headers: response.allHeaderFields,
            decoder: decoder
        )
    }

    private func makeRequest(
        url: String,
        method: HTTPMethod,
        encodableBody: AnyEncodable?,
        headers: [String: String]?
    ) throws -> URLRequest {
        guard let url = URL(string: url) else {
            throw MUCClientError.invalidUrl
        }
        
        // Create URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let encodableBody {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try encoder.encode(encodableBody)
        }

        // Set headers
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return request
    }

    private func validateResponse(statusCode: Int) throws {
        if !((200...299) ~= statusCode) {
            throw makeError(from: statusCode)
        }
    }

    private func makeError(from statusCode: Int) -> MUCClientError {
        if statusCode == 401 {
            return MUCClientError.unauthorized
        } else {
            return MUCClientError.serverError(statusCode: statusCode)
        }
    }
}
