//
//  SurveyAPP_FISECApp.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 08/02/2021.
//

import SwiftUI

@main
struct SurveyAPP_FISECApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(\.colorScheme, .light)
        }
    }
}
