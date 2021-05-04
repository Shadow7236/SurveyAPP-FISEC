//
//  CouponBuyView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 19/02/2021.
//
import Defaults
import SwiftUI

/// View for buying coupon
struct CouponBuyView: View {
    @StateObject
    var buyCouponModel = BuyCouponModel()
    
    @State var coupon: AddedCoupon
    @Default(.userID) var usrID
    @Default(.tokens) var tokens
    
    @State private var showingAlert = false
    @State private var chooseAlert = 0
    @State private var erromMsg = "Unexpected error"
    
    
    var body: some View {
        VStack {
            HStack {
                Text(coupon.name)
                    .font(.title)
                Spacer()
            }
            HStack {
                VStack {
                    HStack {
                        Text("Price:")
                        Group {
                            Text(String(format:  "%.2f", coupon.value))
                            Image(systemName: "circlebadge.2.fill")
                        }.font(.title2)
                        .foregroundColor(.blue)
                        Spacer()
                    }
                    HStack {
                        Text("Value: ")
                        Text(String(format: "%.2f", coupon.value / 40)) 
                        Text("€")
                        Spacer()
                    }
                }
                Spacer()
                Button(action: {
                    chooseAlert = 0
                    showingAlert = true
                }){
                    Text("Buy")
                        .frame(width: 50, height: 30, alignment: .center)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.headline)
                }.buttonStyle(BorderlessButtonStyle())
            }.alert(isPresented: $showingAlert) {
                switch chooseAlert {
                case 0:
                    if tokens >= coupon.value {
                        return Alert(title: Text("Buy coupon?"), message: Text("Do you really want to buy a coupon?"), primaryButton: .destructive(Text("Yes")) {
                            sendData()
                        }, secondaryButton: .default(Text("No")))
                    } else {
                        return Alert(title: Text("Error:"), message: Text("You don't have enough tokens."), dismissButton: .default(Text("Ok")))
                    }
                case 2:
                    return Alert(title: Text("Success"), message: Text("You have successfully bought coupon. You can find it in your profile."), dismissButton: .default(Text("Ok")))
                default:
                    return Alert(title: Text("Error"), message: Text(erromMsg), dismissButton: .default(Text("Ok")){
                        buyCouponModel.error = nil
                    })
                }
                
                
            }.padding()
        }
    }
    
    
    
    /// <#Description#>
    /// - Returns: <#description#>
    func sendData() -> Void {
        if let id = usrID {
            if let userID = UUID(uuidString: id) {
                buyCouponModel.coupon = BuyCoupon(userID: userID, couponID: coupon.id)
                let group = DispatchGroup()
                group.enter()
                buyCouponModel.sendData(g: group)
                group.notify(queue: DispatchQueue.main){
                    if let e = buyCouponModel.error {
                        if e.description == "Misdirected" {
                            erromMsg = "Sorry this coupon is invalid. We apologise for the inconvience."
                            chooseAlert = 1
                            showingAlert = true
                        }
                        erromMsg = e.description
                        chooseAlert = 1
                        showingAlert = true
                    } else {
                        chooseAlert = 2
                        showingAlert = true
                        tokens -= coupon.value
                    }
                }
                return
            }
        }
        chooseAlert = 1
        showingAlert = true
    }
}

struct CouponBuyView_Previews: PreviewProvider {
    static var previews: some View {
        CouponBuyView(coupon: AddedCoupon(id: UUID(), addedBy: BelongsTo(id: UUID()), fromServer: _serverURL + "/test", value: 300, name: "Name"))
    }
}
