import Fluent
import struct Foundation.UUID
import Vapor

final class User: Model, Authenticatable, @unchecked Sendable {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "email")
    var email: String
    
    @Field(key: "password_hash")
    var passwordHash: String

    init() { }

    init(
        id: UUID? = nil,
        email: String,
        passwordHash: String
    ) {
        self.id = id
        self.email = email
        self.passwordHash = passwordHash
    }
}
