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
    @State private var currentView: String = "home"
    @State private var generatedRecipe: RecipeModel? = nil

    var body: some Scene {
        WindowGroup {
            if currentView == "home" {
                HomeView(currentView: $currentView)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else if currentView == "input" {
                InputView(currentView: $currentView, generatedRecipe: $generatedRecipe)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else if currentView == "result" {
                if let recipe = generatedRecipe {
                    ResultView(recipe: recipe, currentView: $currentView)
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                } else {
                    HomeView(currentView: $currentView)
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                }
            } else if currentView == "settings" {
                SettingsView(currentView: $currentView)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
