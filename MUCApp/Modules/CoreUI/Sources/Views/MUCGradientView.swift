import SwiftUI

public struct MUCGradientView: View {
    @Environment(\.colorScheme) var colorScheme

    public init() {}

    public var body: some View {
        if colorScheme == .dark {
            MeshGradient(
                width: 2, height: 2, points: [
                    [0, 0], [1, 0],
                    [0, 1], [1, 1]
                ],
                colors: [
                    .blue, .indigo,
                    .black, .teal
                ]
            )
            .edgesIgnoringSafeArea(.all)
        }
        else {
            MeshGradient(
                width: 2, height: 2, points: [
                    [0, 0], [1, 0],
                    [0, 1], [1, 1]
                ],
                colors: [
                    .blue, .cyan,
                    .white, .mint
                ]
            )
            .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    MUCGradientView()
}
