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
    
    private let sut: AsyncSecureStorage
    
    init() {
        let keychain = KeychainMock()
        let secureDataStorage = SecureDataStorageImpl(keychain: keychain)
        self.sut = AsyncSecureStorageImpl(
            secureDataStorage: secureDataStorage,
            encoder: JSONEncoder(),
            decoder: JSONDecoder(),
            queue: DispatchQueue.main
        )
    }
    
    @Test("Get returns expected data")
    func getWhenDataSet() async throws {
        let token = Token(accessToken: "Test", expirationDate: Date.now)
        let testKey = "Test"
        try await sut.set(key: testKey, value: token)
        let returnedToken = try await sut.get(key: testKey, type: Token.self)
        #expect(token == returnedToken)
    }
    
    @Test("Get returns nil if no data set")
    func getWhenNoDataSet() async throws {
        let testKey = "Test"
        let returnedToken = try await sut.get(key: testKey, type: Token.self)
        #expect(returnedToken == nil)
    }
    
    @Test("Delete removes correct data")
    func deleteSuccess() async throws {
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
}
