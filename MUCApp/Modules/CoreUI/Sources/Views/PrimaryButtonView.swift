import SwiftUI

public struct PrimaryButtonView: View {
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
                .foregroundColor(.white)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.black))
                .cornerRadius(10)
        }
    }
}

#Preview {
    PrimaryButtonView("Text") {}
}
