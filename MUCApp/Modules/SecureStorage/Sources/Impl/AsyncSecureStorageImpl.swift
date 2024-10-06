import Foundation
import SecureStorageAPI
import Security

public final class AsyncSecureStorageImpl: AsyncSecureStorage {
    private let secureDataStorage: SecureDataStorage
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let queue: DispatchQueue
    
    public init(
        secureDataStorage: SecureDataStorage,
        encoder: JSONEncoder,
        decoder: JSONDecoder,
        queue: DispatchQueue
    ) {
        self.secureDataStorage = secureDataStorage
        self.encoder = encoder
        self.decoder = decoder
        self.queue = queue
    }
    
    public func set<T: Encodable & Sendable>(key: String, value: T) async throws {
        try await performOnQueue { [encoder, secureDataStorage] in
            let data = try encoder.encode(value)
            try secureDataStorage.set(key: key, data: data)
        }
    }
    
    public func get<T: Decodable>(key: String, type: T.Type) async throws -> T? {
        try await performOnQueue { [decoder, secureDataStorage] in
            return try secureDataStorage.get(key: key).flatMap {
                try decoder.decode(T.self, from: $0)
            }
        }
    }
    
    public func delete(key: String) async throws {
        try await performOnQueue { [secureDataStorage] in
            try secureDataStorage.delete(key: key)
        }
    }
    
    private func performOnQueue<T>(
        _ operation: @escaping @Sendable () throws -> T?
    ) async throws -> T? {
        return try await withCheckedThrowingContinuation { continuation in
            queue.async {
                do {
                    try continuation.resume(returning: operation())
                }
                catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
