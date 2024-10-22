import MUCAPI
import MUCMocks
import SwiftUI

public struct HomeView: View {
    private let navDelegate: HomeNavDelegate

    public init(navDelegate: HomeNavDelegate) {
        self.navDelegate = navDelegate
    }

    public var body: some View {
        Text("Home")

        Button(action: {
            navDelegate.onDetail()
        }) {
            PrimaryButtonView("Go to detail")
        }
    }
}

#Preview {
    HomeView(navDelegate: HomeNavDelegateMock())
}
