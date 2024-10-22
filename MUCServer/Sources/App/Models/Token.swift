import Fluent
import Vapor

final class Token: Model, @unchecked Sendable {
    static let schema = "tokens"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User
    
    @Field(key: "access_token")
    var accessToken: String

    @Field(key: "access_token_expiration")
    var accessTokenExpiration: Date
    
    @Field(key: "refresh_token")
    var refreshToken: String
    
    @Field(key: "refresh_token_expiration")
    var refreshTokenExpiration: Date

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
        self.accessTokenExpiration = accessExpiresAt
        self.refreshToken = refreshToken
        self.refreshTokenExpiration = refreshExpiresAt
    }
    
    func toDTO() -> TokenDTO {
        TokenDTO(
            accessToken: accessToken,
            accessTokenExpiration: accessTokenExpiration,
            refreshToken: refreshToken,
            refreshTokenExpiration: refreshTokenExpiration
        )
    }
}
