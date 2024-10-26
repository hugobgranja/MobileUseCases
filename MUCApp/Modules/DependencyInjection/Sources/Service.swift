import Foundation

/// A wrapper class for a registered service, including its lifetime and factory method.
final class Service<T, each A> {
    let lifetime: Lifetime
    let factory: (Container, repeat each A) -> T

    /// Initializes a new service with a specified lifetime and factory method.
    ///
    /// - Parameters:
    ///   - lifetime: The lifetime of the service.
    ///   - factory: A closure that creates an instance of the service.
    init(
        _ lifetime: Lifetime,
        _ factory: @escaping (Container, repeat each A) -> T
    ) {
        self.lifetime = lifetime
        self.factory = factory
    }
}
