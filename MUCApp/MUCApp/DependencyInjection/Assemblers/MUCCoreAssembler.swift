import Foundation
import BackpackDI
import MUCCoreAPI
import MUCCoreImpl

@MainActor
public final class MUCCoreAssembler {
    static func assemble(_ container: Container) {
        container.autoRegister(MUCEndpoints.self, using: DevEndpoints.init)

        container.register(MUCClient.self) { _ in
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            return MUCBaseClient(
                urlRequester: URLSession.shared,
                encoder: encoder,
                decoder: decoder
            )
        }

        container.autoRegister(
            AuthRepository.self,
            lifetime: .singleton,
            using: AuthRepositoryImpl.init
        )

        container.autoRegister(
            StringRepository.self,
            using: StringRepositoryImpl.init
        )
    }
}
