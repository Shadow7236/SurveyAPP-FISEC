//
//  UserProfileView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 15/02/2021.
//


import Defaults
import SwiftUI


/// View for showing user profile
struct UserProfileView: View {
    @State var user: UserPublic
    
    @State private var showingSheet = false
    
    @Binding var redraw: Bool
    
    @State var showAlert = false
    
    @Default(.token) var tok
    @Default(.userID) var userID
    
    @State var mail = ""
    
    var body: some View {
        VStack {
            List{
                HStack {
                    Text("Email:")
                    Text(mail)
                    Spacer()
                }
                Spacer()
                NavigationLink(destination: BoughtCouponsView()){
                    Text("Bought coupons")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                Spacer()
                NavigationLink(destination: MySurveysView()){
                    Text("Created surveys")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                NavigationLink(destination: AddedCouponsView()){
                    Text("Added coupons")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                Spacer()
                Button(action: {
                    showAlert = true
                }) {
                    HStack {
                        Text("Log out")
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }.alert(isPresented: $showAlert, content: {
                    Alert(title: Text("Log out?"), message: Text("Do you really want to log out?"), primaryButton: .destructive(Text("Yes")) {
                        tok = nil
                        userID = nil
                        redraw.toggle()
                    }, secondaryButton: .default(Text("No")))
                })
            }.onAppear(perform: {
                if mail == ""{
                    mail = user.mail
                }
            })
        }.navigationBarItems(leading:
            HStack {
                Text(String(format: "%.2f", Defaults[.tokens]))
                Image(systemName: "circlebadge.2.fill")
            }.foregroundColor(.blue), trailing:
            Button(action: {
                showingSheet = true
            }){
                Text("Edit")
            }.sheet(isPresented: $showingSheet) {
                EditProfileSheetView(user: user, m: $mail)
            }
        )
        .navigationBarTitle(Text("Profile"))
    }
    
}


struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView(user: UserPublic(mail: "radovan@klembara.pro", tokens: 20.2, id: UUID()),redraw: .constant(false))
            .previewDevice("iPhone 11")
    }
}
