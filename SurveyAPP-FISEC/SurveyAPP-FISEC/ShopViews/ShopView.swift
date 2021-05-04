//
//  ShopView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 19/02/2021.
//

import Defaults
import Combine
import SwiftUI

/// View for showing shop
struct ShopView: View {
    @StateObject
    var couponModel = AddedCouponModel()
    
    @State var coupons = [AddedCoupon]()
    @State private var showingSheet = false
    @State var showAlert = false
    @State var msg = "Unexpected error."
    
    @Default(.token) var tok
    @Default(.userID) var userID
    
    var body: some View {
        NavigationView{
            VStack {
                if coupons.count == 0 {
                    PlaceHolderView(txt: "There are no coupons")
                } else {
                        List {
                            ForEach(coupons.indices, id: \.self) { i in
                                CouponBuyView(coupon: coupons[i])
                            }
                        }
                        
                }
            }
            .navigationBarItems(leading:
                                    HStack {
                                        Text(String(format: "%.2f", Defaults[.tokens]))
                    Image(systemName: "circlebadge.2.fill")
                }
            .foregroundColor(.blue), trailing:
                Button(action: {
                        showingSheet = true
                }){
                    HStack {
                        Text("Add")
                        Image(systemName: "plus")
                    }.foregroundColor(.blue)
                }.sheet(isPresented: $showingSheet) {
                    AddCouponSheetView()
                }
            )
            .navigationBarTitle(Text("Shop"), displayMode: .inline)
        }
        .onAppear(perform: loadData)
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    //TODO alert err
    /// Loads chop content
    func loadData() {
        let group = DispatchGroup()
        group.enter()
        couponModel.reloadData(g: group)
        group.notify(queue: DispatchQueue.main) {
            if let e = couponModel.error {
                if e.description == "Unauthorized" {
                    tok = nil
                    userID = nil
                } else {
                    showAlert = true
                    msg = e.description
                }
            } else {
                msg = "Unexpected error."
            }
            coupons = couponModel.coupons ?? []
        }
    }
}

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView()
    }
}
