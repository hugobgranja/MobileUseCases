import SwiftUI

public struct MUCButtonView: View {
    @Environment(\.theme) private var theme
    private let text: String
    private let action: () -> Void

    public init(
        _ text: String,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Text(text)
                .foregroundStyle(theme.buttonTextPrimary)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(theme.buttonBackgroundPrimary)
                .cornerRadius(theme.cornerRadius)
        }
    }
}

#Preview {
    MUCButtonView("Text") {}
}
