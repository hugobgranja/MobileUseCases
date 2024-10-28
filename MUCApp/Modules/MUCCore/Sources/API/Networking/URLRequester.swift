import Foundation

public protocol URLRequester: Sendable {
    func data(for: URLRequest) async throws -> (Data, URLResponse)
}
