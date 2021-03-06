//
//  AddCouponSheetView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 26/03/2021.
//

import Defaults
import SwiftUI

/// View for adding coupon
struct AddCouponSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Default(.userID) var usrID
    
    @StateObject
    var couponModel = AddedCouponModel()
    
    @State var name = String()
    @State var couponURL = String()
    @State var value = String()
    
    @State var showAlert = false
    @State var alertMsg = "Unexpected error"
    @State var error = String()
    @State var tokVal = 0.0
    @State var aToken: String = ""
    @State var chooseAlert = 1
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                }
                Spacer()
                Button(action: {
                    saveAndSend()
                }) {
                    Text("Save")
                }.alert(isPresented: $showAlert, content: {
                    if chooseAlert == 1 {
                        return Alert(title: Text("Error:"), message: Text(alertMsg), dismissButton: .default(Text("Ok")){
                            couponModel.error = nil
                        })
                    } else {
                        return Alert(title: Text("Success:"), message: Text("Coupon successfully added."), dismissButton: .default(Text("Ok")){
                            couponModel.error = nil
                            presentationMode.wrappedValue.dismiss()
                        })
                    }
                })
            }.padding()
            Form {
                Section {
                    HStack {
                        Text("*Title: ")
                        TextField("Enter coupon title", text: $name)
                    }
                    HStack {
                        Text("*URL: ")
                        TextField("Enter URL of coupon server", text: $couponURL)
                    }
                    VStack {
                        HStack{
                            Text("Authorization header: ")
                            Spacer()
                        }
                        TextField("Enter authorization header value", text: $aToken)
                    }
                    HStack {
                        Text("*Value: ")
                        TextField("Enter coupon value in €", text: $value).onChange(of: value, perform: { value in
                            tokVal = countValue()
                        })
                    }
                    HStack {
                        Text("Value in tokens: ")
                        Text(String(format: "%.2f", tokVal))
                    }
                    HStack{
                        Text("* field is required")
                            .font(.caption)
                    }
                }
            }
            
            Spacer()
            
        }
        
    }
    
    /// Counts token value of coupon
    /// - Returns: coupon value in tokens
    func countValue() -> Double {
        let v = Double(value) ?? 0
        return v * 40
    }
    
    /// Sends request for creating new coupon to server
    func saveAndSend() {
        if tokVal == 0 {
            showAlert = true
            alertMsg = "Coupon value has to be given."
        } else {
            if name.isEmpty {
                showAlert = true
                alertMsg = "Coupon name has to be given."
                return
            }
            if couponURL.isEmpty {
                showAlert = true
                alertMsg = "Coupon URL has to be given."
                return
            }
            if let userID = UUID(uuidString: usrID ?? "") {
                let coupon = AddedCoupon(id: UUID(), addedBy: BelongsTo(id:  userID), fromServer: couponURL, value: tokVal, name: name, token: aToken ==  "" ? nil : aToken)
                couponModel.newCoupon = coupon
                let group = DispatchGroup()
                group.enter()
                couponModel.sendData(g: group)
                group.notify(queue: DispatchQueue.main) {
                    if let e = couponModel.error {
                        showAlert = true
                        alertMsg = e.description
                    } else {
                        showAlert = true
                        chooseAlert = 0
                    }
                }
            } else {
                showAlert = true
                alertMsg = "Something went wrong"
            }
            
        }
        
    }
}

struct AddCouponSheetView_Previews: PreviewProvider {
    static var previews: some View {
        AddCouponSheetView()
    }
}
