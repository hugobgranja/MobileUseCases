import Foundation
import MUCAPI

struct DevEndpoints: MUCEndpoints {
    private let base: String
    
    private let auth: String
    let login: String
    let refresh: String
    
    let users: String
    
    init() {
        self.base = "http://127.0.0.1:8080"
        
        self.auth = base + "/auth"
        self.login = auth + "/login"
        self.refresh = auth + "/refresh"
        
        self.users = base + "/users"
    }
}
