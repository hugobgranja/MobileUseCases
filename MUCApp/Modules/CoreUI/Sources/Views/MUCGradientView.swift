import SwiftUI

public struct MUCGradientView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.theme) private var theme

    public init() {}

    public var body: some View {
        if colorScheme == .dark {
            MeshGradient(
                width: 2, height: 2, points: [
                    [0, 0], [1, 0],
                    [0, 1], [1, 1]
                ],
                colors: theme.appBackgroundGradientDark
            )
            .edgesIgnoringSafeArea(.all)
        }
        else {
            MeshGradient(
                width: 2, height: 2, points: [
                    [0, 0], [1, 0],
                    [0, 1], [1, 1]
                ],
                colors: theme.appBackgroundGradientLight
            )
            .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    MUCGradientView()
}
