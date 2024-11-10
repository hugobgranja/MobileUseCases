import SwiftUI

public struct FormFieldViewModifier: ViewModifier {
    @Environment(\.theme) private var theme

    public init() {}
    
    public func body(content: Content) -> some View {
        content
            .frame(height: 20)
            .padding()
            .background(theme.formFieldBackground)
            .cornerRadius(theme.cornerRadius)
    }
}

#Preview {
    @Previewable @State var email = ""
    TextField("Email", text: $email)
        .modifier(FormFieldViewModifier())
}
