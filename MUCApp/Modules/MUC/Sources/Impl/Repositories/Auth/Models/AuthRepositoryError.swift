import Foundation

public enum AuthRepositoryError: Error {
    case loginRequired
    
    var localizedDescription: String {
        switch self {
            case .loginRequired: return "[AuthRepository] Login is required"
        }
    }
}
