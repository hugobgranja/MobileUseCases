import Foundation

public protocol SecureDataStorage: Sendable {
    func set(key: String, data: Data) throws
    func get(key: String) throws -> Data?
    func delete(key: String) throws
}
