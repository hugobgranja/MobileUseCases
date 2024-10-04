//
// Designed to store sensitive data such as tokens, and personal information.
// The size of the encoded data should not exceed the keychain's limit of 4 kilobytes.
//

import Foundation
import Security

final class SecureStorageImpl: SecureStorage {
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    init(
        encoder: JSONEncoder,
        decoder: JSONDecoder
    ) {
        self.encoder = encoder
        self.decoder = decoder
    }
    
    func set<T: Encodable>(key: String, value: T) throws {
        let data = try encoder.encode(value)
        try set(key: key, data: data)
    }
    
    private func set(key: String, data: Data) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        // Remove any existing item with the same key
        SecItemDelete(query as CFDictionary)
        
        // Add new data to Keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status != errSecSuccess {
            throw SecureStorageError.setFailed(status: status)
        }
    }
    
    func get<T: Decodable>(key: String, type: T.Type) throws -> T? {
        return try get(key: key).flatMap {
            try decoder.decode(T.self, from: $0)
        }
    }
    
    private func get(key: String) throws -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            return dataTypeRef as? Data
        } else if status == errSecItemNotFound {
            return nil
        } else {
            throw SecureStorageError.getFailed(status: status)
        }
    }
    
    func delete(key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status != errSecSuccess {
            throw SecureStorageError.deleteFailed(status: status)
        }
    }
}
