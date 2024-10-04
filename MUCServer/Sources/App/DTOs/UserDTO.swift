import Vapor

struct UserDTO: Content {
    let email: String
    let password: String
}
