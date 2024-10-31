import Foundation
import BackpackDI

@MainActor
class AppContainer {
    private let container = Container()

    init() {
        assemble()
    }

    func assemble() {
        SecureStorageAssembler.assemble(container)
        MUCCoreAssembler.assemble(container)
        MUCLoginAssembler.assemble(container)
        AppAssembler.assemble(container)
    }

    func resolve<T>(_ type: T.Type) -> T {
        return container.resolve(type)
    }
}
