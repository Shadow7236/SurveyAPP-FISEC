//
//  ShopView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 19/02/2021.
//

import SwiftUI

struct ShopView: View {
    var body: some View {
        NavigationView{
            List {
                CouponBuyView()
                CouponBuyView()
                CouponBuyView()
                CouponBuyView()
                CouponBuyView()
                CouponBuyView()
                CouponBuyView()
            }.navigationBarTitle(Text("Shop"), displayMode: .inline)
            .navigationBarItems(leading: HStack {
                Text("400")
                Image(systemName: "circlebadge.2.fill")
            }.foregroundColor(.blue), trailing:
                NavigationLink(destination: Text("adding")) {
                    HStack {
                        Text("Add")
                        Image(systemName: "plus")
                    }.foregroundColor(.blue)
                })
        }
    }
}

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView()
    }
}
