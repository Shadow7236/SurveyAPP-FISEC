//
//  CouponBuyView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 19/02/2021.
//

import SwiftUI

struct CouponBuyView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Name")
                    .font(.title)
                Spacer()
            }
            HStack {
                Text("Price:")
                Group {
                    Text("330")
                    Image(systemName: "circlebadge.2.fill")
                }.font(.title2)
                .foregroundColor(.blue)
                Spacer()
                Button(action: {}){
                    Text("Buy")
                        .frame(width: 50, height: 30, alignment: .center)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.headline)
                }.buttonStyle(BorderlessButtonStyle())
            }
        }.padding()
    }
}

struct CouponBuyView_Previews: PreviewProvider {
    static var previews: some View {
        CouponBuyView()
    }
}
