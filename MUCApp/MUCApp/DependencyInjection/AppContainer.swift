import Foundation
import DependencyInjection

@MainActor
class AppContainer {
    private let container = Container()

    func assemble() {
        LoginAssembler.assemble(container)
    }

    func resolve<T>(_ type: T.Type) -> T {
        return container.resolve(type)
    }
}
