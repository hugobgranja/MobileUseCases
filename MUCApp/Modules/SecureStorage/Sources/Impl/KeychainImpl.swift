import Foundation
import SecureStorageAPI
import Security

public final class KeychainImpl: Keychain {
    public func add(_ query: [String: Any]) -> OSStatus {
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    public func copyMatching(_ query: [String: Any]) -> (AnyObject?, OSStatus) {
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        return (dataTypeRef, status)
    }
    
    @discardableResult
    public func delete(_ query: [String: Any]) -> OSStatus {
        return SecItemDelete(query as CFDictionary)
    }
}
