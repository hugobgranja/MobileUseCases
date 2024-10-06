import Foundation

public protocol AsyncSecureStorage {
    func set<T: Encodable>(key: String, value: T) async throws
    func get<T: Decodable>(key: String, type: T.Type) async throws -> T?
    func delete(key: String) async throws
}
