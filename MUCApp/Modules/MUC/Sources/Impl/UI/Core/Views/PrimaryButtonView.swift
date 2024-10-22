import SwiftUI

public struct PrimaryButtonView: View {
    private let text: String
    
    public init(_ text: String) {
        self.text = text
    }
    
    public var body: some View {
        Text(text)
            .foregroundColor(.white)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.black))
            .cornerRadius(10)
    }
}

#Preview {
    PrimaryButtonView("Text")
}
