import Foundation

struct Token: Codable {
    let accessToken: String
    let accessTokenExpiration: Date
    let refreshToken: String
    let refreshTokenExpiration: Date
}
