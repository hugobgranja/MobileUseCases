import SwiftUI

public final class ThemeImpl: Theme {
    // MARK: Dimensions
    public let cornerRadius: CGFloat = 10
    public let shadowRadius: CGFloat = 5

    // MARK: Colors
    public let textPrimary = Color.primary
    public let textSecondary = Color.secondary
    public let textError = Color(.systemRed)

    public let logoPrimary = Color.black
    public let logoSecondary = Color.blue

    public let iconPrimary = Color.blue

    public let buttonBackgroundPrimary = Color.black
    public let buttonTextPrimary = Color.white

    public let formFieldBackground = Color.white.opacity(0.2)
    public let formFieldText = Color.secondary

    public let dialogBackground = Color(.systemGray6)
    public let dimBackground = Color.black.opacity(0.6)

    // MARK: Gradients
    public let appBackgroundGradientDark: [Color] = [.blue, .indigo,.black, .teal]
    public let appBackgroundGradientLight: [Color] = [.blue, .cyan, .white, .mint]

    public init() {}
}

public struct ThemeKey: EnvironmentKey {
    public static let defaultValue: Theme = ThemeImpl()
}

public extension EnvironmentValues {
    var theme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}
