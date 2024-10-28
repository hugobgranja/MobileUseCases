import SwiftUI

public struct FormFieldViewModifier: ViewModifier {
    public init() {}
    
    public func body(content: Content) -> some View {
        content
            .frame(height: 20)
            .padding()
            .background(Color(.white).opacity(0.2))
            .cornerRadius(10)
    }
}

#Preview {
    @Previewable @State var email = ""
    TextField("Email", text: $email)
        .modifier(FormFieldViewModifier())
}
