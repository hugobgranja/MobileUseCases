import SwiftUI

public struct MUCProgressView: View {
    private var isLoading: Bool

    public init(isLoading: Bool) {
        self.isLoading = isLoading
    }

    public var body: some View {
        if isLoading {
            DialogView {
                ProgressView()
                    .padding()
            }
        }
    }
}

#Preview {
    MUCProgressView(isLoading: true)
}
