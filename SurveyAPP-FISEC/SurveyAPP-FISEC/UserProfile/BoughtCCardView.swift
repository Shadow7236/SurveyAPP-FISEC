//
//  BoughtCCardView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 09/04/2021.
//

import SwiftUI

/// View for showing one bought coupon
struct BoughtCCardView: View {
    @StateObject
    var codeModel = BoughtCouponCodeModel()
    
    @State private var showingAlert = false
    @State private var chooseAlert = 0
    @State private var errorMsg = "Unexpected error"
    @State var code: String = ""
    @State var disable = false
    
    @State var coupon: BoughtCouponPublic
    
    var body: some View {
        VStack {
            VStack{
            HStack {
                Text(coupon.name)
                    .font(.title)
                Spacer()
            }
            HStack {
                HStack {
                    Text("Value: ")
                    Text(String(format: "%.2f", coupon.value))
                    Text("€")
                    Spacer()
                }
                Spacer()
                Button(action: {
                    chooseAlert = 0
                    showingAlert = true
                }){
                    if disable {
                        Text("Activated")
                            .frame(width: 100, height: 30, alignment: .center)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .font(.headline)
                    } else {
                        Text("Activate")
                            .frame(width: 100, height: 30, alignment: .center)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .font(.headline)
                    }
                }.buttonStyle(BorderlessButtonStyle())
                .disabled(disable)
            }
            }.padding()
            .alert(isPresented: $showingAlert) {
                switch chooseAlert {
                case 0:
                    return Alert(title: Text("Activate?"), message: Text("Do you really want to activate coupon? Coupon will be active only 10 minutes."), primaryButton: .destructive(Text("Yes")) {
                        sendData()
                    }, secondaryButton: .default(Text("No")))
                    
                default:
                    return Alert(title: Text("Error"), message: Text(errorMsg), dismissButton: .default(Text("Ok")){
                        codeModel.error = nil
                    })
                }
            }
            if code != "" {
                VStack {
                    HStack{
                        Text("Coupon code: ")
                            .fontWeight(.bold)
                        Spacer()
                    }
                    HStack{
                        Text(code)
                        Button(action: {
                            UIPasteboard.general.string = self.code
                        }, label: {
                            Image(systemName: "doc.on.doc")
                                .foregroundColor(.blue)
                        })
                    }
                }.padding()
            }
        }
        .background(Color.gray.opacity(0.2))
        .onAppear(perform: {
            if coupon.activated {
                if let c = coupon.code {
                    code = c
                    disable = true
                } else {
                    disable = false
                }
            }
        })
    }
    
    /// Activates coupon and gets code
    func sendData() {
        if let id = UUID(uuidString: coupon.id) {
            let group = DispatchGroup()
            group.enter()
            codeModel.loadData(g: group, id: id)
            group.notify(queue: DispatchQueue.main){
                if let e = codeModel.error {
                    errorMsg = e.description
                    chooseAlert = 1
                    showingAlert = true
                } else {
                    if let c = codeModel.code {
                        code = c
                        disable = true
                    } else {
                        errorMsg = "Unexpected error."
                        chooseAlert = 1
                        showingAlert = true
                    }
                }
            }
        } else {
            errorMsg = "Unexpected error."
            chooseAlert = 1
            showingAlert = true
        }
        
    }
}

struct BoughtCCardView_Previews: PreviewProvider {
    static var previews: some View {
        BoughtCCardView(coupon: BoughtCouponPublic(id: "", activated: false, used: false, name: "Coupon name", value: 300))
    }
}
