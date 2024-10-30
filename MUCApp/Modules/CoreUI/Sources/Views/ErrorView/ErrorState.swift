import Foundation

public enum ErrorState: Equatable {
    case visible(title: String, message: String, buttonTitle: String)
    case invisible
}
