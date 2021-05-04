//
//  UserProfileLoadView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 28/03/2021.
//

import Defaults
import SwiftUI

/// View for loading user profile
struct UserProfileLoadView: View {
    @StateObject
    var userModel = UserModel()
    
    @Binding var redraw: Bool
    
    @State private var showingSheet = false
    @State private var showAlert = false
    @State var user: UserPublic? = nil
        
    @Default(.token) var tok
    @Default(.tokens) var tokens
    @Default(.userID) var userID
    
    var body: some View {
        NavigationView { 
            Group {
                if let u = user {
                    UserProfileView(user: u, redraw: $redraw)
                } else {
                    VStack(spacing: 10) {
                        ProgressView()
                        Text("Loading user data.")
                    }
                }
            }.navigationBarTitle(Text("Profile"), displayMode: .inline)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Request error"), message: Text(userModel.error?.description ?? "Unexpected error"), dismissButton: .default(Text("Ok")){userModel.error = nil})
            }.onAppear(perform: loadData)

        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    /// Load user info
    func loadData() {
        let group = DispatchGroup()
        group.enter()
        userModel.reloadData(g: group)
        group.notify(queue: DispatchQueue.main) {
            if let e = userModel.error {
                if e.description == "Unauthorized" {
                    tok = nil
                    userID = nil
                }
                showAlert = true
                user = nil
            } else {
                user = userModel.user
                tokens = userModel.user?.tokens ?? 0.0
            }
        }
    }
}





struct UserProfileLoadView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileLoadView(redraw: .constant(false))
    }
}
