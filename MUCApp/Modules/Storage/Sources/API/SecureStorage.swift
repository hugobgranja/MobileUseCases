import Foundation
import Security

public protocol SecureStorage {
    func set<T: Encodable>(key: String, value: T) throws
    func get<T: Decodable>(key: String, type: T.Type) throws -> T?
    func delete(key: String) throws
}
