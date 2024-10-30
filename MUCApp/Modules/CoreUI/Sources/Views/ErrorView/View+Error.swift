import SwiftUI

public extension View {
    func overlayError(_ state: Binding<ErrorState>) -> some View {
        overlay(ErrorView(state: state))
    }
}
