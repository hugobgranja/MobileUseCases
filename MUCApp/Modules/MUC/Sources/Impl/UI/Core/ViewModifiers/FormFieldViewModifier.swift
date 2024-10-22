import SwiftUI

struct FormFieldViewModifier: ViewModifier {
    func body(content: Content) -> some View {
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
