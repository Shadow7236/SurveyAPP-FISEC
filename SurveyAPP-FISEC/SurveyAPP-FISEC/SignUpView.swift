//
//  SignUpView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 01/04/2021.
//
import Defaults
import SwiftUI

/// View for signing up
struct SignUpView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State private var email = ""
    @State private var password1 = ""
    @State private var password2 = ""
    
    @State private var showAlert = false
    @State private var chooseAlert = 0
    @State var errorMsg = "Unexpected error"
    
    @StateObject
    var userModel = SignUserModel()
    
    var body: some View {
        VStack {
            Text("FISEC App")
                .font(.title)
                .fontWeight(.bold)
                .shadow(radius: 13)
                .padding(.top)
            Spacer()
            VStack{
                TextField("Email", text: self.$email)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20.0)
                    .shadow(radius: 10)
                SecureField("Password", text: self.$password1)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20.0)
                    .shadow(radius: 10)
                SecureField("Repeat password", text: self.$password2)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20.0)
                    .shadow(radius: 10)
            }.padding([.leading, .trailing], 27.5)
            .padding(.bottom)
            Button(action: signUp){
                Text("Sign Up")
                    .font(.headline)
                    .frame(width: 150)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(20.0)
            }.alert(isPresented: $showAlert, content: {
                switch chooseAlert {
                case 0:
                return Alert(title: Text("Error:"), message: Text(errorMsg), dismissButton: .default(Text("Ok")){
                    userModel.error = nil
                })
                case 2:
                    return Alert(title: Text("Success:"), message: Text("You have been registered"), dismissButton: .default(Text("Ok")){
                        userModel.error = nil
                    })
                default:
                    return Alert(title: Text("Error:"), message: Text(errorMsg), dismissButton: .default(Text("Ok")){
                        userModel.error = nil
                    })
                }
            })
            Spacer()
        }
    }
    
    /// Sends sign up credentials to server and logs in user
    func signUp() {
        if password1 != password2 {
            errorMsg = "Passwords are not same."
            chooseAlert = 0
            showAlert = true
        } else {
            if password1.count < 6 {
                errorMsg = "Password is less than minimum of 6 characters."
                chooseAlert = 0
                showAlert = true
            } else {
                if isValidEmail(str: email.lowercased()) {
                    userModel.user = UserSignup(username: email.lowercased(), password: password1)
                    let g = DispatchGroup()
                    g.enter()
                    userModel.sendData(g: g) 
                    g.notify(queue: DispatchQueue.main) {
                        if let e = userModel.error {
                            errorMsg = e.description
                            chooseAlert = 1
                            showAlert = true
                        } else {
                            if let a = userModel.result{
                                Defaults[.token] = a.token
                                Defaults[.userID] = a.user.id.uuidString
                                Defaults[.tokens] = a.user.tokens
                            }
                            chooseAlert = 2
                            showAlert = true
                            self.mode.wrappedValue.dismiss()
                        }
                    }
                }else {
                    errorMsg = "Invalid email."
                    chooseAlert = 0
                    showAlert = true
                }
                
            }
        }
    }
}



struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignUpView()
        }
    }
}
