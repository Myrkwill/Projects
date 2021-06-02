//
//  DrawingApp.swift
//  Drawing
//
//  Created by Mark Nagibin on 02.06.2021.
//

import SwiftUI

@main
struct DrawingApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
