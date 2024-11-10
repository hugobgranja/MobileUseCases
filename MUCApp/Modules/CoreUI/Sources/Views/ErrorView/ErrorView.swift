import SwiftUI

struct ErrorView: View {
    @Environment(\.theme) private var theme
    @Binding var state: ErrorState

    var body: some View {
        Group {
            if case .visible(
                let title,
                let errorMessage,
                let buttonTitle
            ) = state {
                ZStack {
                    theme.dimBackground
                        .edgesIgnoringSafeArea(.all)

                    DialogView(spacing: 24) {
                        Text(title)
                            .font(.headline)
                            .foregroundStyle(Color(.systemRed))

                        Text(errorMessage)
                            .font(.body)
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.center)

                        MUCButtonView(buttonTitle) {
                            state = .invisible
                        }
                        .padding(.top, 2)
                    }
                    .padding(40)
                }
            }
        }
        .transition(.opacity)
        .animation(.easeInOut, value: state)
    }
}

#Preview {
    @Previewable @State var errorState = ErrorState.visible(
        title: "Error",
        message: "Please try again later.",
        buttonTitle: "OK"
    )
    ErrorView(state: $errorState)
}
