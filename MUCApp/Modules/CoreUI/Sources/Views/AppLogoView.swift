import SwiftUI

public struct AppLogoView: View {
    @Environment(\.theme) private var theme
    private let width: CGFloat
    private let height: CGFloat

    public init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }

    public var body: some View {
        Image(systemName: "music.note.list")
            .resizable()
            .scaledToFit()
            .frame(width: width, height: height)
            .foregroundStyle(theme.logoPrimary, theme.logoSecondary)
    }
}

#Preview {
    AppLogoView(width: 150, height: 150)
}
