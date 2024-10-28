import Foundation

public protocol MUCEndpoints: Sendable {
    // Auth
    var login: String { get }
    var refresh: String { get }
}
