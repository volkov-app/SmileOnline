//
//  SmileOnlineApp.swift
//  Shared
//
//  Created by Алексей Волков on 17.02.2021.
//

import SwiftUI

@main
struct SmileOnlineApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
