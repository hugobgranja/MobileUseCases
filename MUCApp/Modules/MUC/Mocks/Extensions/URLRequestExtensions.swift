import Foundation
import MUCAPI

extension URLRequest {
    var typedHttpMethod: HTTPMethod? {
        return httpMethod.flatMap { HTTPMethod(rawValue: $0) }
    }
}
