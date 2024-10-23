import Foundation

final class Service<T, each A> {
    let lifetime: Lifetime
    let factory: (Container, repeat each A) -> T

    init(
        _ lifetime: Lifetime,
        _ factory: @escaping (Container, repeat each A) -> T
    ) {
        self.lifetime = lifetime
        self.factory = factory
    }
}
