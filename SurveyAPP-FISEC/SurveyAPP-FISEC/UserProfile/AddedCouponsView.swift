//
//  AddedCouponsView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 20/04/2021.
//

import SwiftUI

struct AddedCouponsView: View {
    @StateObject
    var addedCoupons = AddedCouponModel()
    
    @State var coupons = [AddedCoupon]()
    
    @State private var showingAlert = false
    @State private var errorMsg = "Unexpected error"
    
    var body: some View {
        VStack {
            if coupons.isEmpty {
                if let _ = addedCoupons.coupons {
                    PlaceHolderView(txt: "You haven't added any coupons.")
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
                        AddedCCardView(coupon: coupons[i])
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
        addedCoupons.loadMineData(g: group)
        group.notify(queue: DispatchQueue.main) {
            if let e = addedCoupons.error {
                errorMsg = e.description
                showingAlert = true
            } else if let aCM = addedCoupons.coupons {
                coupons = aCM
            } else {
                errorMsg = "Unexpected error"
                showingAlert = true
            }
        }
    }
}

struct AddedCouponsView_Previews: PreviewProvider {
    static var previews: some View {
        AddedCouponsView()
    }
}
