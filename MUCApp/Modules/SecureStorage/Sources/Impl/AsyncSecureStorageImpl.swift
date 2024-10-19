import Foundation
import SecureStorageAPI
import Security

public final class AsyncSecureStorageImpl: AsyncSecureStorage {
    private let secureDataStorage: SecureDataStorage
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    public init(
        secureDataStorage: SecureDataStorage,
        encoder: JSONEncoder,
        decoder: JSONDecoder
    ) {
        self.secureDataStorage = secureDataStorage
        self.encoder = encoder
        self.decoder = decoder
    }
    
    public func set<T: Encodable & Sendable>(key: String, value: T) async throws {
        let task = Task { [encoder, secureDataStorage] in
            let data = try encoder.encode(value)
            try secureDataStorage.set(key: key, data: data)
        }
        
        try await task.value
    }
    
    public func get<T: Decodable & Sendable>(key: String, type: T.Type) async throws -> T? {
        let task = Task { [decoder, secureDataStorage] in
            return try secureDataStorage.get(key: key).flatMap {
                try decoder.decode(T.self, from: $0)
            }
        }
        
        return try await task.value
    }
    
    public func delete(key: String) async throws {
        let task = Task { [secureDataStorage] in
            try secureDataStorage.delete(key: key)
        }
        
        try await task.value
    }
}
