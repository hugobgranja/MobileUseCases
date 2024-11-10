import SwiftUI

public protocol Theme: Sendable {
    // MARK: Dimensions
    var cornerRadius: CGFloat { get }
    var shadowRadius: CGFloat { get }

    // MARK: Colors
    var textPrimary: Color { get }
    var textSecondary: Color { get }
    var textError: Color { get }

    var logoPrimary: Color { get }
    var logoSecondary: Color { get }

    var iconPrimary: Color { get }

    var buttonBackgroundPrimary: Color { get }
    var buttonTextPrimary: Color { get }

    var formFieldBackground: Color { get }
    var formFieldText: Color { get }

    var dialogBackground: Color { get }

    var dimBackground: Color { get }

    // MARK: Gradients
    var appBackgroundGradientDark: [Color] { get }
    var appBackgroundGradientLight: [Color] { get }
}

public extension Theme {
    static func makeColor(light: UIColor, dark: UIColor) -> Color {
        Color(UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return dark
            }
            else {
                return light
            }
        })
    }
}
