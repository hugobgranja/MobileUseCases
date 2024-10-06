import Foundation

public enum SecureDataStorageError: Error {
    case setFailed(status: OSStatus)
    case dataExceedsMaximumSize
    case getFailed(status: OSStatus)
    case deleteFailed(status: OSStatus)
}
