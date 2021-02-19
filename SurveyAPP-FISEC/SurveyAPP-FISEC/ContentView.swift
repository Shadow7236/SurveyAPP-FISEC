//
//  ContentView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 08/02/2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    

    var body: some View {
        TabView {
            MainView().tabItem { Label("Home", systemImage: "house") }
            UserProfileView().tabItem { Label("Profile", systemImage: "person.fill")}
            ShopView().tabItem { Label("Shop", systemImage: "bag.fill") }
            CreateSurveyView().tabItem { Label("Create", systemImage: "plus") }
        }
    }

    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).previewDevice("iPhone 11")
    }
}
