import Foundation
import SecureStorageAPI
import SecureStorageImpl
import SecureStorageMocks
import Testing

struct SecureDataStorageTests {
    private let sut: SecureDataStorage
    
    init() {
        self.sut = SecureDataStorageImpl(keychain: KeychainMock())
    }
    
    @Test("Set throws error if data exceeds maximum size")
    func setDataSizeLimitExceedsMaximum() async throws {
        let testData = Data.random(size: 4097)
        let testKey = "Test"
        
        #expect(
            throws: SecureDataStorageError.dataExceedsMaximumSize,
            performing: { try sut.set(key: testKey, data: testData) }
        )
    }
    
    @Test("Set succeeds if data does not exceed maximum size")
    func setDataSizeLimitSuccess() async throws {
        let testData = Data.random(size: 4096)
        let testKey = "Test"
        try sut.set(key: testKey, data: testData)
        #expect(try sut.get(key: testKey) == testData)
    }
    
    @Test("Get returns expected data")
    func getWhenDataSet() async throws {
        let testData = Data.random(size: 20)
        let testKey = "Test"
        try sut.set(key: testKey, data: testData)
        let returnedData = try sut.get(key: testKey)
        #expect(testData == returnedData)
    }
    
    @Test("Get returns nil if no data set")
    func getWhenNoDataSet() async throws {
        let testKey = "Test"
        let returnedData = try sut.get(key: testKey)
        #expect(returnedData == nil)
    }
    
    @Test("Delete removes correct data")
    func deleteSuccess() async throws {
        let testData = Data.random(size: 20)
        let testKey = "Test"
        let deleteKey = "Delete"
        try sut.set(key: testKey, data: testData)
        try sut.set(key: deleteKey, data: testData)
        try sut.delete(key: deleteKey)
        
        let unchangedData = try sut.get(key: testKey)
        #expect(unchangedData != nil)
        
        let deletedData = try sut.get(key: deleteKey)
        #expect(deletedData == nil)
    }
}
