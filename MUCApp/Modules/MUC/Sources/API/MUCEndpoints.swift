import Foundation

public protocol MUCEndpoints {
    // Auth
    var login: String { get }
    var refresh: String { get }
    
    // Users
    var users: String { get }
}
