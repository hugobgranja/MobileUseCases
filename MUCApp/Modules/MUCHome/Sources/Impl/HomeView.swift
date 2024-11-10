import CoreUI
import MUCHomeAPI
import MUCHomeMocks
import SwiftUI

public struct HomeView: View {
    private let navDelegate: HomeNavDelegate

    public init(navDelegate: HomeNavDelegate) {
        self.navDelegate = navDelegate
    }

    public var body: some View {
        Text("Home")

        MUCButtonView("Go to detail") {
            navDelegate.onDetail()
        }
    }
}

#Preview {
    HomeView(navDelegate: HomeNavDelegateMock())
}
