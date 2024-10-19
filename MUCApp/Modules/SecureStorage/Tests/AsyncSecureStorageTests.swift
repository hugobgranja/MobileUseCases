import Foundation
import SecureStorageAPI
import SecureStorageImpl
import SecureStorageMocks
import Testing

struct AsyncSecureStorageTests {
    struct Token: Codable, Equatable {
        let accessToken: String
        let expirationDate: Date
    }
    
    enum Constants {
        static let testKey = "Test"
        static let testToken = Token(accessToken: "Test", expirationDate: Date.now)
    }
    
    private let keychain = KeychainMock()
    private let sut: AsyncSecureStorage
    
    init() {
        let secureDataStorage = SecureDataStorageImpl(keychain: keychain)
        self.sut = AsyncSecureStorageImpl(
            secureDataStorage: secureDataStorage,
            encoder: JSONEncoder(),
            decoder: JSONDecoder()
        )
    }
    
    @Test("Get returns expected data given data was set")
    func getGivenDataWasSetThenReturnsData() async throws {
        try await sut.set(key: Constants.testKey, value: Constants.testToken)
        let returnedToken = try await sut.get(key: Constants.testKey, type: Token.self)
        #expect(Constants.testToken == returnedToken)
    }
    
    @Test("Get returns nil if key is not found")
    func getWhenKeyNotFoundThenReturnsNil() async throws {
        keychain.status = errSecItemNotFound
        let returnedToken = try await sut.get(key: Constants.testKey, type: Token.self)
        #expect(returnedToken == nil)
    }
    
    @Test("Delete removes data given data was set")
    func deleteGivenDataWasSetThenRemovesData() async throws {
        let token = Token(accessToken: "Test", expirationDate: Date.now)
        let testKey = "Test"
        
        let deleteData = Token(accessToken: "Delete", expirationDate: Date.now)
        let deleteKey = "Delete"
        
        try await sut.set(key: testKey, value: token)
        try await sut.set(key: deleteKey, value: deleteData)
        try await sut.delete(key: deleteKey)
        
        let unchangedData = try await sut.get(key: testKey, type: Token.self)
        #expect(unchangedData != nil)
        
        let deletedData = try await sut.get(key: deleteKey, type: Token.self)
        #expect(deletedData == nil)
    }
    
    @Test("Get throws on keychain error")
    func getWhenKeychainErrorThenThrows() async throws {
        let status = errSecBadReq
        keychain.status = status
        
        await #expect(
            throws: SecureDataStorageError.keychainError(status),
            performing: {
                let _ = try await sut.get(key: "Test", type: Token.self)
            }
        )
    }
    
    @Test("Set throws on keychain error")
    func setWhenKeychainErrorThenThrows() async throws {
        let status = errSecBadReq
        keychain.status = status
        
        await #expect(
            throws: SecureDataStorageError.keychainError(status),
            performing: {
                try await sut.set(key: Constants.testKey, value: Constants.testToken)
            }
        )
    }
    
    @Test("Delete throws on keychain error")
    func deleteWhenKeychainErrorThenThrows() async throws {
        let status = errSecBadReq
        keychain.status = status
        
        await #expect(
            throws: SecureDataStorageError.keychainError(status),
            performing: {
                try await sut.delete(key: Constants.testKey)
            }
        )
    }
}
