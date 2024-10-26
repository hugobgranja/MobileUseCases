import Foundation

/// A dependency injection container for managing service registrations and resolutions.
/// - Note: Sending a protocol that only exposes the resolve method as a factory argument crashes the compiler
public final class Container {
    private var services: [String: Any] = [:]
    private var singletonServices: [String: Any] = [:]
    private let weakServices: NSMapTable<NSString, AnyObject> = .strongToWeakObjects()

    public init() {}

    /// Registers a service with a specified lifetime and factory method.
    ///
    /// - Parameters:
    ///   - type: The type of the service being registered.
    ///   - lifetime: The lifetime of the service (default is `.transient`).
    ///   - factory: A closure that creates an instance of the service.
    /// - Note: If a service with the same type is already registered, it will be overwritten.
    public func register<T, each A>(
        _ type: T.Type,
        lifetime: Lifetime = .transient,
        _ factory: @escaping (Container, repeat each A) -> T
    ) {
        let key = makeKey(from: type)
        let service = Service(lifetime, factory)
        services[key] = service
    }

    /// Resolves a registered service, creating a new instance or returning an existing one based on its lifetime.
    ///
    /// - Parameters:
    ///   - type: The type of the service to resolve.
    ///   - arguments: Additional arguments required to create the service.
    /// - Throws:
    ///   - `DIError.serviceNotFound` if no service is registered for the specified type.
    /// - Returns: An instance of the requested service type.
    public func resolveThrowing<T, each A>(
        _ type: T.Type,
        arguments: repeat each A
    ) throws -> T {
        let key = makeKey(from: type)

        guard
            let service = services[key] as? Service<T, repeat each A>
        else {
            throw DIError.serviceNotFound
        }

        switch service.lifetime {
        case .transient:
            return service.factory(self, repeat each arguments)

        case .singleton:
            if let instance = singletonServices[key] {
                return instance as! T
            }
            else {
                let instance = service.factory(self, repeat each arguments)
                singletonServices[key] = instance
                return instance
            }

        case .weak:
            let key = NSString(string: key)

            if let instance = weakServices.object(forKey: key) {
                return instance as! T
            }
            else {
                let instance = service.factory(self, repeat each arguments) as AnyObject
                weakServices.setObject(instance, forKey: key)
                return instance as! T
            }
        }
    }

    /// Resolves a registered service, creating a new instance or returning an existing one based on its lifetime.
    ///
    /// This function wraps the `resolveThrowing` method and converts the
    /// throwing behavior into a non-throwing interface. If a service for
    /// the specified type is not found, it will terminate the program with
    /// a fatal error.
    ///
    /// - Parameters:
    ///   - type: The type of the service to resolve.
    ///   - arguments: Additional arguments required to create the service.
    /// - Returns: An instance of the requested service type.
    public func resolve<T, each A>(
        _ type: T.Type,
        arguments: repeat each A
    ) -> T {
        do {
            return try resolveThrowing(type, arguments: repeat each arguments)
        }
        catch {
            fatalError("[DI] Service for type \(type) not found!")
        }
    }

    /// Automatically registers a service using an initializer that requires additional arguments.
    ///
    /// - Parameters:
    ///   - type: The type of the service being registered.
    ///   - lifetime: The lifetime of the service (default is `.transient`).
    ///   - initializer: A closure that initializes the service using resolved dependencies.
    /// - Note: This method uses the `resolve` method to obtain dependencies.
    public func autoRegister<T, each D>(
        _ type: T.Type,
        lifetime: Lifetime = .transient,
        using initializer: @escaping (repeat each D) -> T
    ) {
       register(type, lifetime: lifetime) { r in
            initializer(repeat r.resolve((each D).self))
        }
    }

    /// Creates a unique key string for the specified type.
    ///
    /// - Parameter type: The type for which to create a key.
    /// - Returns: A unique string representing the type.
    private func makeKey<T>(from type: T.Type) -> String {
        return String(describing: type)
    }
}

