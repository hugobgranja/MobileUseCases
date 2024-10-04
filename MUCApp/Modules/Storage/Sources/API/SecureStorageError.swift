import Foundation

enum SecureStorageError: Error {
    case setFailed(status: OSStatus)
    case getFailed(status: OSStatus)
    case deleteFailed(status: OSStatus)
}
