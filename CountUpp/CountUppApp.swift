//
//  CountUppApp.swift
//  CountUpp
//
//  Created by Hubert Andrzejewski on 10/12/2020.
//

import SwiftUI

@main
struct CountUppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
