// Note: Sending a protocol that only exposes the
// resolve method as a factory argument crashes the compiler

import Foundation

public final class Container {
    private var services: [String: Any] = [:]
    private var singletonServices: [String: Any] = [:]
    private let weakServices: NSMapTable<NSString, AnyObject> = {
        NSMapTable(
            keyOptions: .copyIn,
            valueOptions: .weakMemory
        )
    }()

    public init() {}

    public func register<T, each A>(
        _ type: T.Type,
        lifetime: Lifetime = .transient,
        _ factory: @escaping (Container, repeat each A) -> T
    ) {
        let key = makeKey(from: type)
        let service = Service(lifetime, factory)
        services[key] = service
    }

    public func resolve<T, each A>(
        _ type: T.Type,
        arguments: repeat each A
    ) -> T {
        let key = makeKey(from: type)

        guard
            let service = services[key] as? Service<T, repeat each A>
        else {
            fatalError("[DI] Dependency for type \(type) not found!")
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

    public func autoRegister<T, each D>(
        _ type: T.Type,
        lifetime: Lifetime = .transient,
        using initializer: @escaping (repeat each D) -> T
    ) {
       register(type, lifetime: lifetime) { r in
            initializer(repeat r.resolve((each D).self))
        }
    }

    private func makeKey<T>(from type: T.Type) -> String {
        return String(describing: type)
    }
}

