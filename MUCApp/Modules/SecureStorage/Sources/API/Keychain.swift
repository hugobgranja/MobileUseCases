import Foundation

public protocol Keychain: Sendable {
    func add(_ query: [String: Any]) -> OSStatus
    func copyMatching(_ query: [String: Any]) -> (AnyObject?, OSStatus)
    @discardableResult func delete(_ query: [String: Any]) -> OSStatus
}
