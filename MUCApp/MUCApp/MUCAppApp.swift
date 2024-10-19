//
//  MUCAppApp.swift
//  MUCApp
//
//  Created by hg on 30/09/2024.
//

import SwiftUI
import SwiftData
import MUCAPI
import MUCImpl
import SecureStorageImpl

@main
struct MUCAppApp: App {
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
    
    private let loginViewModel: LoginViewModel
    
    init() {
        let baseClient = MUCBaseClient(
            urlRequester: URLSession.shared,
            encoder: JSONEncoder(),
            decoder: JSONDecoder()
        )
        
        let keychain = KeychainImpl()
        
        let secureStorage = AsyncSecureStorageImpl(
            secureDataStorage: SecureDataStorageImpl(keychain: keychain),
            encoder: JSONEncoder(),
            decoder: JSONDecoder(),
            queue: DispatchQueue.global()
        )
        
        let authRepository = AuthRepositoryImpl(
            endpoints: DevEndpoints(),
            client: baseClient,
            storage: secureStorage
        )
        
        self.loginViewModel = LoginViewModel(authRepository: authRepository)
    }

    var body: some Scene {
        WindowGroup {
            LoginView(viewModel: loginViewModel)
        }
        .modelContainer(sharedModelContainer)
    }
}

extension URLSession: @retroactive URLRequester {}
