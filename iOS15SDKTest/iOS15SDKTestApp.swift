//
//  iOS15SDKTestApp.swift
//  iOS15SDKTest
//
//  Created by Руслан Кукса on 10.06.2021.
//

import SwiftUI

@main
struct iOS15SDKTestApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
