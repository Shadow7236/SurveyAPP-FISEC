//
//  LogInView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 01/04/2021.
//

import Defaults
import SwiftUI

/// View for loging in
struct LogInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var errMsg = "Unexpected error."
    
    @Default(.userID) var userID
    @Default(.token) var token
    
    @StateObject
    var userModel = SignUserModel()
    
    var body: some View {
        NavigationView{
            VStack {
                Text("FISEC App")
                    .font(.title)
                    .fontWeight(.bold)
                    .shadow(radius: 13)
                    .padding(.top)
                Spacer()
                VStack{
                    HStack{
                        TextField("Email", text: self.$email)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20.0)
                            .shadow(radius: 10)
                        
                    }
                    SecureField("Password", text: self.$password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20.0)
                        .shadow(radius: 10)
                }.padding([.leading, .trailing], 27.5)
                .padding(.bottom)
                Button(action: logIn){
                    Text("Sign In")
                        .font(.headline)
                        .frame(width: 150)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(20.0)
                }.alert(isPresented: $showAlert, content: {
                    switch errMsg {
                    case "Not found", "Unauthorized":
                        return Alert(
                            title:
                                Text("Error:"),
                            message:
                                Text("Wrong email or password"), dismissButton: .default(Text("Ok")){
                                    userModel.error = nil
                                })
                    default:
                        return Alert(
                            title:
                                Text("Error:"),
                            message:
                                Text(errMsg), dismissButton: .default(Text("Ok")){
                                    userModel.error = nil
                                })
                    }
                })
                Spacer()
                HStack {
                    Text("Doesn't have an account yet?")
                        .font(.caption)
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign Up")
                            .font(.caption)
                            .fontWeight(.bold)
                    }
                }
            }
        }
    }
    
    /// Sends log in credentials to server and logs in user to application
    func logIn() {
        userModel.user = UserSignup(username: email, password: password)
        let group = DispatchGroup()
        group.enter()
        userModel.logIn(g: group)
        group.notify(queue: DispatchQueue.main) {
            if let e = userModel.error {
                errMsg = e.description
                showAlert = true
            } else {
                if let a = userModel.result{
                    Defaults[.userID] = a.user.id.uuidString
                    Defaults[.tokens] = a.user.tokens
                    Defaults[.token] = a.token
                    errMsg = "Unexpected error."
                } else {
                    errMsg = "Unexpected error."
                    showAlert = true
                }
            }
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
