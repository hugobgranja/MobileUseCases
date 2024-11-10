import SwiftUI

struct DialogView<Content: View>: View {
    @Environment(\.theme) private var theme
    let spacing: CGFloat
    let content: Content

    init(
        spacing: CGFloat = 0,
        @ViewBuilder content: () -> Content
    ) {
        self.spacing = spacing
        self.content = content()
    }

    var body: some View {
        VStack(spacing: spacing) {
            content
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: theme.cornerRadius)
                .fill(theme.dialogBackground)
                .shadow(radius: theme.shadowRadius)
        }
    }
}

#Preview {
    DialogView {
        Text("Error")
        Text("There was a problem")
        Button {
            
        } label: {
            Text("OK")
        }
    }
}
