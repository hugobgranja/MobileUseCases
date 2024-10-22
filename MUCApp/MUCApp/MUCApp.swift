import SwiftUI
import SwiftData
import MUCAPI
import MUCImpl

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

    private var appCoordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: appCoordinator.$navPath.path) {
                appCoordinator.getInitialView()
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
