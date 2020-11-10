//
//  FitnessAppApp.swift
//  FitnessApp
//
//  Created by Ural Ozden on 10.11.2020.
//

import SwiftUI

@main
struct FitnessAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
