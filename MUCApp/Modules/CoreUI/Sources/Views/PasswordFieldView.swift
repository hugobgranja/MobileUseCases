import SwiftUI

public struct PasswordFieldView: View {
    private let placeholder: String
    @Binding private var password: String
    @State private var isSecure: Bool = true
    
    
    private var secureToggleImage: String {
        isSecure ? "eye.slash.fill" : "eye.fill"
    }
    
    public init(_ placeholder: String, password: Binding<String>) {
        self.placeholder = placeholder
        self._password = password
    }
    
    public var body: some View {
        HStack {
            if isSecure {
                SecureField(placeholder, text: $password)
            } else {
                TextField(placeholder, text: $password)
            }
            
            Button(action: {
                isSecure.toggle()
            }) {
                Image(systemName: secureToggleImage)
            }
        }
    }
}

#Preview {
    @Previewable @State var password = ""
    PasswordFieldView("Password", password: $password)
        .padding()
}
