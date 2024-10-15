import Foundation
import SecureStorageAPI
import SecureStorageImpl
import SecureStorageMocks
import Testing

struct SecureDataStorageTests {
    private let keychain = KeychainMock()
    private let sut: SecureDataStorageImpl
    
    enum Constants {
        static let invalidDataSize = 4097
        static let validDataSize = 4096
        static let testKey = "Test"
        static let testData = Data.random(size: 20)
    }
    
    init() {
        self.sut = SecureDataStorageImpl(keychain: keychain)
    }
    
    @Test("Set throws error if data size exceeds limit")
    func setGivenDataThatExceedsSizeLimitThenThrows() async throws {
        let testData = Data.random(size: Constants.invalidDataSize)
        
        #expect(
            throws: SecureDataStorageError.dataExceedsMaximumSize,
            performing: { try sut.set(key: Constants.testKey, data: testData) }
        )
    }
    
    @Test("Set succeeds if data is within size limits")
    func setGivenDataWithinLimitsThenSucceeds() async throws {
        let testData = Data.random(size: Constants.validDataSize)
        try sut.set(key: Constants.testKey, data: testData)
        #expect(try sut.get(key: Constants.testKey) == testData)
    }
    
    @Test("Get returns expected data given data was set")
    func getGivenDataWasSetThenReturnsData() async throws {
        try sut.set(key: Constants.testKey, data: Constants.testData)
        let storedData = try sut.get(key: Constants.testKey)
        #expect(Constants.testData == storedData)
    }
    
    @Test("Get returns nil if key is not found")
    func getWhenKeyNotFoundThenReturnsNil() async throws {
        keychain.status = errSecItemNotFound
        let storedData = try sut.get(key: Constants.testKey)
        #expect(storedData == nil)
    }
    
    @Test("Delete removes data given data was set")
    func deleteGivenDataWasSetThenRemovesData() async throws {
        let deleteKey = "Delete"
        try sut.set(key: Constants.testKey, data: Constants.testData)
        try sut.set(key: deleteKey, data: Constants.testData)
        try sut.delete(key: deleteKey)
        
        let unchangedData = try sut.get(key: Constants.testKey)
        #expect(unchangedData != nil)
        
        let deletedData = try sut.get(key: deleteKey)
        #expect(deletedData == nil)
    }
    
    @Test("Get throws on keychain error")
    func getWhenKeychainErrorThenThrows() async throws {
        let status = errSecBadReq
        keychain.status = status
        
        #expect(
            throws: SecureDataStorageError.keychainError(status),
            performing: {
                let _ = try sut.get(key: Constants.testKey)
            }
        )
    }
    
    @Test("Set throws on keychain error")
    func setWhenKeychainErrorThenThrows() async throws {
        let status = errSecBadReq
        keychain.status = status
        
        #expect(
            throws: SecureDataStorageError.keychainError(status),
            performing: {
                try sut.set(key: Constants.testKey, data: Constants.testData)
            }
        )
    }
    
    @Test("Delete throws on keychain error")
    func deleteWhenKeychainErrorThenThrows() async throws {
        let status = errSecBadReq
        keychain.status = status
        
        #expect(
            throws: SecureDataStorageError.keychainError(status),
            performing: {
                try sut.delete(key: Constants.testKey)
            }
        )
    }
}
