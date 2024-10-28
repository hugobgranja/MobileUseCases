import SwiftUI

public struct AppLogoView: View {
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
            .foregroundStyle(.black, .blue)
    }
}

#Preview {
    AppLogoView(width: 150, height: 150)
}
