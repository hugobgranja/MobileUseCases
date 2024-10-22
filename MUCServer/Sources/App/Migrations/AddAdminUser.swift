import Fluent
import Vapor

struct AddAdminUser: AsyncMigration {
    private let email = "hello@world.com"
    private let password = "qwert"
    
    func prepare(on database: Database) async throws {
        let passwordHash = try! Bcrypt.hash(password)
        let user = User(email: email, passwordHash: passwordHash)
        try await user.save(on: database)
    }

    func revert(on database: Database) async throws {
        try await User.query(on: database)
            .filter(\User.$email == email)
            .delete()
    }
}
