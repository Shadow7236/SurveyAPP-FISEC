//
//  AddedCCardView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 20/04/2021.
//

import SwiftUI

/// View for showing one coupon
struct AddedCCardView: View {
    @StateObject
    var addedModel = AddedCouponModel()
    
    @State private var showingAlert = false
    @State private var chooseAlert = 0
    @State private var errorMsg = "Unexpected error"
    @State var code: String = ""
    
    @State var coupon: AddedCoupon
    
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
                            Text("Delete")
                                .frame(width: 100, height: 30, alignment: .center)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .font(.headline)
                        
                    }.buttonStyle(BorderlessButtonStyle())
                }
            }.padding()
            .alert(isPresented: $showingAlert) {
                switch chooseAlert {
                case 0:
                    return Alert(title: Text("Delete?"), message: Text("Do you really want to delete coupon?"), primaryButton: .destructive(Text("Yes")) {
                        sendData()
                    }, secondaryButton: .default(Text("No")))
                case 2:
                    return Alert(title: Text("Success"), message: Text("Coupon has been successfully deleted"), dismissButton: .default(Text("Ok")))
                default:
                    return Alert(title: Text("Error"), message: Text(errorMsg), dismissButton: .default(Text("Ok")){
                        addedModel.error = nil
                    })
                }
            }
        }
        .background(Color.gray.opacity(0.2))
    }
    
    /// Deletes added coupon
    func sendData() {
        let group = DispatchGroup()
        group.enter()
        addedModel.delete(g: group, id: coupon.id)
        group.notify(queue: DispatchQueue.main){
            if let e = addedModel.error {
                errorMsg = e.description
                chooseAlert = 1
                showingAlert = true
            } else {
                chooseAlert = 2
                showingAlert = true
            }
        }
    }
}

struct AddedCCardView_Previews: PreviewProvider {
    static var previews: some View {
        AddedCCardView(coupon: AddedCoupon(id: UUID(), addedBy: BelongsTo(id: UUID()), fromServer: "", value: 202, name: ""))
    }
}
