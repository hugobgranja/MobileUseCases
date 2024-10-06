//
// Store sensitive data such as authentication tokens.
// The size of the encoded data should not exceed the keychain's limit of 4 kilobytes.
//

import Foundation
import SecureStorageAPI
import Security

public final class SecureDataStorageImpl: SecureDataStorage {
    private static let maximumDataSize: Int = 4096
    private let keychain: Keychain
    
    public init(keychain: Keychain) {
        self.keychain = keychain
    }
    
    public func set(key: String, data: Data) throws {
        guard isDataSizeWithinLimit(data: data) else {
            throw SecureDataStorageError.dataExceedsMaximumSize
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        // Remove any existing item with the same key
        keychain.delete(query)
        
        // Add new data to Keychain
        let status = keychain.add(query)
        
        if status != errSecSuccess {
            throw SecureDataStorageError.setFailed(status: status)
        }
    }
    
    public func get(key: String) throws -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        let (dataTypeRef, status) = keychain.copyMatching(query)
        
        if status == errSecSuccess {
            return dataTypeRef as? Data
        } else if status == errSecItemNotFound {
            return nil
        } else {
            throw SecureDataStorageError.getFailed(status: status)
        }
    }
    
    public func delete(key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = keychain.delete(query)
        
        if status != errSecSuccess {
            throw SecureDataStorageError.deleteFailed(status: status)
        }
    }
    
    private func isDataSizeWithinLimit(data: Data) -> Bool {
        return data.count <= Self.maximumDataSize
    }
}
