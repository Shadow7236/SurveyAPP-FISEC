//
//  EditProfileSheetView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 27/03/2021.
//

import SwiftUI

struct EditProfileSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject
    var userModel = UserModel()
    
    @State var user: UserPublic
    
    @Binding var m: String
    @State var email: String = ""
    @State var name: String = ""
    @State var surname: String = ""
    
    @State var showAlert = false
    @State var errorMsg = "Unexpected error"
    
    var body: some View {
        VStack {
            HStack{
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                }
                Spacer()
                Button(action: {
                    if email != "" {
                        saveChanges()
                        presentationMode.wrappedValue.dismiss() 
                    } else {
                        showAlert = true
                        errorMsg = "Email has to be set"
                    }
                }) {
                    Text("Save")
                }
                .alert(isPresented: $showAlert, content: {
                    Alert(title: Text("Error"), message: Text(errorMsg), dismissButton: .default(Text("Ok")){
                        userModel.error = nil
                    })
                })
            }.padding()
            List {
                HStack {
                    Text("Email:")
                        .font(.title2)
                    TextField(user.mail, text: $email)
                    Spacer()
                }
            }
            Spacer()
        }
    }
    
    
    
    func saveChanges() {
        if email != "" {
            user.mail = email
        }
        userModel.user = user
        let group = DispatchGroup()
        group.enter()
        userModel.sendData(g: group)
        group.notify(queue: DispatchQueue.main){
            if let e = userModel.error {
                errorMsg = e.description
                showAlert = true
            } else {
                if let u = userModel.user {
                    user = u
                    self.m = u.mail
                }
            }
        }
    }
}

struct EditProfileSheetView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileSheetView(user: UserPublic(mail: "Radovan@klembara.pro", tokens: 20.2, id: UUID()), m: .constant(""))
    }
}
