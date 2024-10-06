import Foundation
import SecureStorageAPI
import SecureStorageImpl
import SecureStorageMocks
import Testing

struct AsyncSecureStorageTests {
    struct TestData: Codable, Equatable {
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
        let testData = TestData(accessToken: "Test", expirationDate: Date.now)
        let testKey = "Test"
        try await sut.set(key: testKey, value: testData)
        let returnedData = try await sut.get(key: testKey, type: TestData.self)
        #expect(testData == returnedData)
    }
    
    @Test("Get returns nil if no data set")
    func getWhenNoDataSet() async throws {
        let testKey = "Test"
        let returnedData = try await sut.get(key: testKey, type: TestData.self)
        #expect(returnedData == nil)
    }
    
    @Test("Delete removes correct data")
    func deleteSuccess() async throws {
        let testData = TestData(accessToken: "Test", expirationDate: Date.now)
        let testKey = "Test"
        
        let deleteData = TestData(accessToken: "Delete", expirationDate: Date.now)
        let deleteKey = "Delete"
        
        try await sut.set(key: testKey, value: testData)
        try await sut.set(key: deleteKey, value: deleteData)
        try await sut.delete(key: deleteKey)
        
        let unchangedData = try await sut.get(key: testKey, type: TestData.self)
        #expect(unchangedData != nil)
        
        let deletedData = try await sut.get(key: deleteKey, type: TestData.self)
        #expect(deletedData == nil)
    }
}
