import Fluent
import Vapor

struct TokenAuthenticator: AsyncBearerAuthenticator {
    func authenticate(bearer: BearerAuthorization, for request: Request) async throws {
        guard
            let token = try await Token.query(on: request.db)
                .filter(\.$accessToken == bearer.token)
                .first()
        else {
            return
        }

        if token.accessExpiresAt > Date.now {
            request.auth.login(token.user)
        }
    }
}
