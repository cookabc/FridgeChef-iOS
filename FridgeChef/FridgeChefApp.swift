//
//  FridgeChefApp.swift
//  FridgeChef
//
//  Created by 宋许刚 on 2026/3/18.
//

import SwiftUI
import CoreData

@main
struct FridgeChefApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
