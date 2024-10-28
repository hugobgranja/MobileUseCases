import Foundation
import MUCCoreAPI

public struct MUCEndpointsMock: MUCEndpoints {
    public var login: String = "http://127.0.0.1:8080/auth/login"
    public var refresh: String = "http://127.0.0.1:8080/auth/refresh"
    
    public init() {}
}
