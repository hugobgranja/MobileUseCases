import Fluent
import Vapor

final class Token: Model, @unchecked Sendable {
    static let schema = "tokens"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User
    
    @Field(key: "accessToken")
    var accessToken: String

    @Field(key: "access_expires_at")
    var accessExpiresAt: Date
    
    @Field(key: "refreshToken")
    var refreshToken: String
    
    @Field(key: "refresh_expires_at")
    var refreshExpiresAt: Date

    init() { }

    init(
        id: UUID? = nil,
        userID: UUID,
        accessToken: String,
        accessExpiresAt: Date,
        refreshToken: String,
        refreshExpiresAt: Date
    ) {
        self.id = id
        self.$user.id = userID
        self.accessToken = accessToken
        self.accessExpiresAt = accessExpiresAt
        self.refreshToken = refreshToken
        self.refreshExpiresAt = refreshExpiresAt
    }
    
    func toDTO() -> TokenDTO {
        TokenDTO(
            accessToken: accessToken,
            accessTokenExpiration: accessExpiresAt,
            refreshToken: refreshToken,
            refreshTokenExpiration: refreshExpiresAt
        )
    }
}
