import MUCAPI
import MUCImpl
import SwiftUI

@MainActor
final class HomeCoordinator {
    enum Destination: Hashable {
        case detail
    }
    
    private var path: ObservableNavigationPath

    init(
        path: ObservableNavigationPath,
        destination: Destination? = nil
    ) {
        self.path = path

        if let destination {
            self.path.append(destination)
        }
    }

    func getInitialView() -> some View {
        return HomeView(navDelegate: self)
            .navigationDestination(
                for: Destination.self,
                destination: destinationView(for:)
            )
    }

    private func destinationView(for destination: Destination) -> some View {
        switch destination {
        case .detail:
            return HomeDetailView()
        }
    }

    private func go(to destination: Destination) {
        path.append(destination)
    }

    func handleDeeplink(to destination: Destination) {

    }
}

extension HomeCoordinator: HomeNavDelegate {
    public func onDetail() {
        go(to: .detail)
    }
}
