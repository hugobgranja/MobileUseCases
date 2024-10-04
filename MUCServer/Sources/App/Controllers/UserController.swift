import Fluent
import Vapor

struct UserController: RouteCollection {    
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.post(use: create)
    }

    @Sendable
    func create(req: Request) async throws -> HTTPStatus {
        let dto = try req.content.decode(UserDTO.self)
        let digest = try await req.password.async.hash(dto.password)
        let user = User(email: dto.email, passwordHash: digest)

        try await user.save(on: req.db)
        return .ok
    }
}
