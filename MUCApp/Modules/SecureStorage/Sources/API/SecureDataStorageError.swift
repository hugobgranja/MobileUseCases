import Foundation

public enum SecureDataStorageError: Error, Equatable {
    case keychainError(OSStatus)
    case dataExceedsMaximumSize
}
