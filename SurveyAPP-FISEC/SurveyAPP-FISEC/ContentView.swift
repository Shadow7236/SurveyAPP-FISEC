//
//  ContentView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 08/02/2021.
//

import SwiftUI
import Defaults

struct ContentView: View {
    @Default(.token) var tok
    @Default(.userID) var userID
    
    @State var register: Bool = false
    
    @State var usrID: String? = nil
    @State var token: String? = nil
    
    @State var redraw: Bool = false
    
    var body: some View {
        if tok != nil {
            MainView(redraw: $redraw).onAppear(perform: {
                print(tok ?? "No token") // TODO DELETE
            })
        } else {
            LogInView()
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice("iPhone 11")
    }
}
