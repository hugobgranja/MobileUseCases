import SwiftUI

public struct EmailFieldViewModifier: ViewModifier {
    public init() {}

    public func body(content: Content) -> some View {
        content
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .keyboardType(.emailAddress)
    }
}
