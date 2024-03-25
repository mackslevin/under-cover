//
//  UndercoverApp.swift
//  Undercover
//
//  Created by Mack Slevin on 3/21/24.
//

import SwiftUI
import SwiftData

@main
struct UndercoverApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UCCategory.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @State private var appleMusicController = AppleMusicController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appleMusicController)
        }
        .modelContainer(sharedModelContainer)
    }
}
