//
//  MainView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 10/02/2021.
//

import SwiftUI

struct MainView: View {
    
    
    var body: some View {
        NavigationView{
            List {
                MainPageSurveyPreview()
                MainPageSurveyPreview()
                MainPageSurveyPreview()
                MainPageSurveyPreview()
                MainPageSurveyPreview()
                MainPageSurveyPreview()
                MainPageSurveyPreview()
                MainPageSurveyPreview()
                MainPageSurveyPreview()
                MainPageSurveyPreview()
            }.listStyle(PlainListStyle())
            .navigationBarTitle(Text("Surveys"), displayMode: .inline)
            .navigationBarItems(leading: HStack {
                Text("400")
                Image(systemName: "circlebadge.2.fill")
            }.foregroundColor(.blue), trailing: HStack {
                Text("Filter")
                Image(systemName: "line.horizontal.3.decrease")
            }.foregroundColor(.blue))
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().previewDevice("iPhone 11")
    }
}
