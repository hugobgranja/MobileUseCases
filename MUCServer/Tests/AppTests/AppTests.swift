@testable import App
import XCTVapor
import Fluent

final class AppTests: XCTestCase {
    var app: Application!
    
    override func setUp() async throws {
        self.app = try await Application.make(.testing)
        try await configure(app)
        try await app.autoMigrate()
    }
    
    override func tearDown() async throws { 
        try await app.autoRevert()
        try await self.app.asyncShutdown()
        self.app = nil
    }
    
    func testUserCreate() async throws {
        let newDTO = UserDTO(id: nil, username: "test")
        
        try await app.test(.POST, "users", beforeRequest: { req in
            try req.content.encode(newDTO)
        }, afterResponse: { res async throws in
            XCTAssertEqual(res.status, .ok)
            let models = try await User.query(on: self.app.db).all()
            XCTAssertEqual(models.map { $0.toDTO().username }, [newDTO.username])
        })
    }
}
