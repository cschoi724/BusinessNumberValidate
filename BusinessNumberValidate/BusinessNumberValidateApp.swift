//
//  BusinessNumberValidateApp.swift
//  BusinessNumberValidate
//
//  Created by SCC-PC on 2024/12/04.
//

import SwiftUI

@main
struct BusinessNumberValidateApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}