//
//  MainView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 01/04/2021.
//

import Combine
import SwiftUI


struct MainView: View {
    @Binding var redraw: Bool
    
    var body: some View {
        TabView {
            BrowseNewSurveysView().tabItem { Label("Home", systemImage: "house") } // TODO timestamp?
            UserProfileLoadView(redraw: $redraw).tabItem { Label("Profile", systemImage: "person.fill")}
            ShopView().tabItem { Label("Shop", systemImage: "bag.fill") }
            CreateSurveyView().tabItem { Label("Create", systemImage: "plus")}
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(redraw: .constant(false)).previewDevice("iPhone 11")
    }
}
