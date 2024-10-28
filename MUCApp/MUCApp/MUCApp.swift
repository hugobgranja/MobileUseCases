import SwiftUI
import SwiftData

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

    private let container: AppContainer
    private let appCoordinator: AppCoordinator

    init() {
        self.container = AppContainer()
        container.assemble()
        appCoordinator = container.resolve(AppCoordinator.self)
    }

    var body: some Scene {
        WindowGroup {
            appCoordinator.getInitialView()
        }
        .modelContainer(sharedModelContainer)
    }
}
