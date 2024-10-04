import Vapor

struct RefreshTokenRequest: Content {
    let refreshToken: String
}

