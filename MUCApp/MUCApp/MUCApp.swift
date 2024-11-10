import SwiftUI
import SwiftData
import CoreUI

@main
struct MUCApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    private let container = AppContainer()
    private let theme: Theme
    private let appCoordinator: AppCoordinator

    init() {
        appCoordinator = container.resolve(AppCoordinator.self)
        theme = container.resolve(Theme.self)
    }

    var body: some Scene {
        WindowGroup {
            appCoordinator.getInitialView()
                .environment(\.theme, theme)
        }
        .modelContainer(sharedModelContainer)
    }
}
