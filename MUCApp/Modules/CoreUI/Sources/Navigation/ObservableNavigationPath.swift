import SwiftUI

@MainActor
@Observable
public final class ObservableNavigationPath {
    public var path = NavigationPath()
    
    public init() {}

    public func append<V>(_ value: V) where V: Hashable {
        path.append(value)
    }
}
