import Foundation
import SecureStorageAPI

public final class KeychainMock: Keychain, @unchecked Sendable {
    private var dict = [String: [String: Any]]()
    private let queryKey = kSecAttrAccount as String
    private let queryValue = kSecValueData as String
    
    public init() {}
    
    public func add(_ query: [String: Any]) -> OSStatus {
        let key = query[queryKey] as! String
        dict[key] = query
        return errSecSuccess
    }
    
    public func copyMatching(_ query: [String: Any]) -> (AnyObject?, OSStatus) {
        let key = query[queryKey] as! String
        return (dict[key]?[queryValue] as? AnyObject, errSecSuccess)
    }
    
    public func delete(_ query: [String : Any]) -> OSStatus {
        let key = query[queryKey] as! String
        dict[key] = nil
        return errSecSuccess
    }
}
