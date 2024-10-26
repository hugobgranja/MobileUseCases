import Foundation

/// An enumeration representing the lifetime of a registered service.
///
/// Transient: A new instance is created every time.
///
/// Singleton: A single instance is created and shared for the lifetime of the container.
///
/// Weak: An instance is shared until it is no longer retained by any consumer.
public enum Lifetime {
    case transient
    case singleton
    case weak
}
