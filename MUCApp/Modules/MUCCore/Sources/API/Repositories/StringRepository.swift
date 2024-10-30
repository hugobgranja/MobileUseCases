import Foundation

public protocol StringRepository {
    func get(_ key: any RawRepresentable<String>) -> String
}
