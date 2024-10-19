import Foundation
import SecureStorageAPI

public final class AsyncSecureStorageMock: AsyncSecureStorage, @unchecked Sendable {
    private var store: [String: Any] = [:]
    
    public init() {}
    
    public func set<T: Encodable & Sendable>(
        key: String,
        value: T
    ) async throws {
        store[key] = value
    }
    
    public func get<T: Decodable>(key: String, type: T.Type) async throws -> T? {
        return store[key] as? T
    }
    
    public func delete(key: String) async throws {
        store[key] = nil
    }
}
