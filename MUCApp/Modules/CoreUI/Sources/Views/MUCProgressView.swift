import SwiftUI

public struct MUCProgressView: View {
    private var isLoading: Bool

    public init(isLoading: Bool) {
        self.isLoading = isLoading
    }

    public var body: some View {
        if isLoading {
            ProgressView()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray6))
                        .frame(width: 100, height: 100)
                        .shadow(radius: 5)
                }
        }
    }
}

#Preview {
    MUCProgressView(isLoading: true)
}
