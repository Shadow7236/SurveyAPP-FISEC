//
//  UserProfileView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 15/02/2021.
//

import SwiftUI

struct UserProfileView: View {
    var body: some View {
        NavigationView{
            VStack {
                Group {
                    HStack {
                        Text("Email:")
                            .font(.title2)
                        Text("radovan@klembara.pro")
                        Spacer()
                    }
                    Divider()
                    HStack {
                        Text("Name:")
                            .font(.title2)
                        Text("radovan")
                        Spacer()
                    }
                    Divider()
                    HStack {
                        Text("Surname:")
                            .font(.title2)
                        Text("Klembara")
                        Spacer()
                    }
                    Divider()
                    HStack {
                        Text("Tokens:")
                            .font(.title2)
                        Text("500")
                        Image(systemName: "circlebadge.2.fill")
                            .foregroundColor(.blue)
                        Spacer()
                    }
                    Divider()
                }
                NavigationLink(destination: Text("TEEXT")){
                    Text("My surveys")
                        .frame(width: 200, height: 50, alignment: .center)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .font(.title)
                        .padding(.top)
                }
                Button(action: {}) {
                    NavigationLink(destination: Text("LOGED OUT")){
                        Text("Log out")
                            .frame(width: 200, height: 50, alignment: .center)
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(10)
                            .font(.title)
                            .padding()
                    }
                }
                Spacer()
            }.navigationBarItems(leading: HStack {
                    Text("400")
                    Image(systemName: "circlebadge.2.fill")
            }.foregroundColor(.blue), trailing:
                NavigationLink(destination: Text("edit")){
                    Text("Edit")
                }
            )
            .navigationBarTitle(Text("Profile"), displayMode: .inline)
            .padding()
        }
    }
}


struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView().previewDevice("iPhone 11")
    }
}
