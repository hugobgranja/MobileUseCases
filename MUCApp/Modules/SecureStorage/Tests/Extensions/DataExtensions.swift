import Foundation

extension Data {
    static func random(size: Int) -> Data {
        let randomBytes = (0..<size).map { _ in UInt8.random(in: 0...255) }
        return Data(randomBytes)
    }
}
