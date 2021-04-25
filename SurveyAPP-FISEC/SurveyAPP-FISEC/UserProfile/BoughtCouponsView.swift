//
//  BoughtCouponsView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 09/04/2021.
//

import Defaults
import SwiftUI

struct BoughtCouponsView: View {
    @StateObject
    var boughtCoupons = BoughtCouponsModel()
    
    @State var coupons = [BoughtCouponPublic]()
    
    @State private var showingAlert = false
    @State private var errorMsg = "Unexpected error"
    
    var body: some View {
        VStack {
            if coupons.isEmpty {
                if let _ = boughtCoupons.coupons {
                    PlaceHolderView(txt: "You don't own any coupons.")
                } else {
                    VStack {
                        ProgressView()
                        Text("Loading coupons.")
                        Spacer()
                    }.padding()
                }
            } else  {
                List {
                    ForEach(coupons.indices, id: \.self) {i in
                        BoughtCCardView(coupon: coupons[i])
                    }
                }
            }
        }.alert(isPresented: $showingAlert, content: {
            Alert(title: Text("Error"), message: Text(errorMsg), dismissButton: .default(Text("Ok")))
        })
        .onAppear(perform: {
            loadData()
        })
    }
    
    func loadData(){
        let group = DispatchGroup()
        group.enter()
        boughtCoupons.loadData(g: group)
        group.notify(queue: DispatchQueue.main) {
            if let e = boughtCoupons.error {
                errorMsg = e.description
                showingAlert = true
            } else if let bCM = boughtCoupons.coupons {
                coupons = bCM
            } else {
                errorMsg = "Unexpected error"
                showingAlert = true
            }
        }
    }
    
}

struct BoughtCouponsView_Previews: PreviewProvider {
    static var previews: some View {
        BoughtCouponsView()
    }
}




