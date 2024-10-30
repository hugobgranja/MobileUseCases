import Foundation
import MUCCoreAPI

public final class StringRepositoryImpl: StringRepository {
    public init() {}

    public func get(_ key: any RawRepresentable<String>) -> String {
        NSLocalizedString(key.rawValue, comment: "")
    }
}
