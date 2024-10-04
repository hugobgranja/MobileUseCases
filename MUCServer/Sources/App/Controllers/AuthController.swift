import Fluent
import Vapor

struct AuthController: RouteCollection {
    enum Constants {
        static let accessTokenDuration: TimeInterval = 3600
        static let refreshTokenDuration: TimeInterval = 604800
    }
    
    func boot(routes: RoutesBuilder) throws {
        let auth = routes.grouped("auth")
        auth.post("login", use: login)
        auth.post("refresh", use: refresh)
    }
    
    @Sendable
    func login(req: Request) async throws -> TokenDTO {
        let dto = try req.content.decode(UserDTO.self)
        
        guard
            let user = try await User.query(on: req.db)
                .filter(\.$email == dto.email)
                .first()
        else {
            throw Abort(.notFound)
        }
        
        guard
            try await req.password.async.verify(dto.password, created: user.passwordHash)
        else {
            throw Abort(.unauthorized)
        }
        
        let accessToken = generateAccessToken()
        let accessTokenExpiration = Date().addingTimeInterval(Constants.accessTokenDuration)
        
        let refreshToken = generateRefreshToken()
        let refreshTokenExpiration = Date().addingTimeInterval(Constants.refreshTokenDuration)
        
        let token = Token(
            userID: user.id!,
            accessToken: accessToken,
            accessExpiresAt: accessTokenExpiration,
            refreshToken: refreshToken,
            refreshExpiresAt: refreshTokenExpiration
        )
        
        try await token.save(on: req.db)
        
        return token.toDTO()
    }
    
    @Sendable
    func refresh(req: Request) async throws -> TokenDTO {
        let dto = try req.content.decode(RefreshTokenRequest.self)
        
        guard
            let token = try await Token.query(on: req.db)
                .filter(\.$refreshToken == dto.refreshToken)
                .first()
        else {
            throw Abort(.unauthorized)
        }
        
        if token.refreshExpiresAt < Date.now {
            throw Abort(.unauthorized, reason: "Refresh token expired")
        }
        
        let newAccessToken = generateAccessToken()
        token.accessToken = newAccessToken
        token.accessExpiresAt = Date.now.addingTimeInterval(Constants.accessTokenDuration)
        
        try await token.save(on: req.db)
        
        return token.toDTO()
    }
}

extension AuthController {
    private func generateAccessToken() -> String {
        return [UInt8].random(count: 16).base64
    }
    
    private func generateRefreshToken() -> String {
        return [UInt8].random(count: 32).base64
    }
}
