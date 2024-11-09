import SwiftUI

struct ErrorView: View {
    @Binding var state: ErrorState

    var body: some View {
        Group {
            if case .visible(let title, let errorMessage, let buttonTitle) = state {
                ZStack {
                    Color.black.opacity(0.6)
                        .edgesIgnoringSafeArea(.all)

                    VStack(spacing: 24) {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(Color(.systemRed))

                        Text(errorMessage)
                            .font(.body)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)

                        PrimaryButtonView(buttonTitle) {
                            state = .invisible
                        }
                        .padding(.top, 2)
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .shadow(radius: 10)
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
