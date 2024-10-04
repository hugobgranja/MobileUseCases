import Vapor

struct TokenDTO: Content {
    let accessToken: String
    let accessTokenExpiration: Date
    let refreshToken: String
    let refreshTokenExpiration: Date
}

