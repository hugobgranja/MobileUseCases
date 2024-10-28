import Foundation
import MUCCoreAPI

extension URLRequest {
    var typedHttpMethod: HTTPMethod? {
        return httpMethod.flatMap { HTTPMethod(rawValue: $0) }
    }
}
