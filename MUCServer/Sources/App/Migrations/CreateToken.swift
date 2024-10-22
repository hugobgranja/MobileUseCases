import Fluent

struct CreateToken: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("tokens")
            .id()
            .field("user_id", .string, .required)
            .field("access_token", .string, .required)
            .field("access_token_expiration", .string, .required)
            .field("refresh_token", .string, .required)
            .field("refresh_token_expiration", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("tokens").delete()
    }
}

