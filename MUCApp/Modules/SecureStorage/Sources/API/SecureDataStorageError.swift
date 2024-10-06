import Foundation

public enum SecureDataStorageError: Error, Equatable {
    case setFailed(status: OSStatus)
    case dataExceedsMaximumSize
    case getFailed(status: OSStatus)
    case deleteFailed(status: OSStatus)
}
