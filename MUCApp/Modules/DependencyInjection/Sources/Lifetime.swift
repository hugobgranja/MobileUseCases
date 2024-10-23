import Foundation

public enum Lifetime {
    case transient // A new instance is created every time
    case singleton // A single instance is created and reused for the lifetime of the container
    case weak // An instance is reused until it is no longer retained by anyone
}
