import Foundation
import MUCCoreAPI

public final class StringRepositoryMock: StringRepository {
    public init() {}
    
    public func get(_ key: any RawRepresentable<String>) -> String {
        return key.rawValue
    }
}
