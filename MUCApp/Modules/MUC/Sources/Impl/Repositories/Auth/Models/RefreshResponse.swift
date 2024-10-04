import Foundation

struct RefreshResponse: Decodable {
    let accessToken: String
    let accessTokenExpiration: Date
    let refreshToken: String
    let refreshTokenExpiration: Date
    
    func toToken() -> Token {
        return Token(
            accessToken: accessToken,
            accessTokenExpiration: accessTokenExpiration,
            refreshToken: refreshToken,
            refreshTokenExpiration: refreshTokenExpiration
        )
    }
}
