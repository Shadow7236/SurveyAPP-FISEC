//
//  MainPageSurveyPreview.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 14/02/2021.
//

import SwiftUI

struct MainPageSurveyPreview: View {
    var body: some View {
        HStack {
            Image("SurveyPlaceHolder")
                .resizable()
                .scaledToFit()
// TODO Absolute sizes
                .frame(width: 100, height: 80, alignment: .center)
            VStack {
                HStack {
                    Text("Name")
                        .font(.title)
                    Spacer()
                    VStack {
                        HStack{
                            Text("300")
                            Image(systemName: "circlebadge.2.fill")
                        }
                            .font(.footnote)
                            .foregroundColor(.blue)
                        Spacer()
                    }.frame(width: 60, height: 40, alignment: .trailing)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
// TODO check length of tags name
                    Text("Tag1")
                        .font(.caption)
                        .frame(width: 4 * 10, height: 25, alignment: .center)
                        .background(Color.gray)
                        .cornerRadius(8)
                    Text("Tag2")
                        .font(.caption)
                        .frame(width: 4 * 10, height: 25, alignment: .center)
                        .background(Color.gray)
                        .cornerRadius(8)
                    Text("Tag3")
                        .font(.caption)
                        .frame(width: 4 * 10, height: 25, alignment: .center)
                        .background(Color.gray)
                        .cornerRadius(8)
                    Text("Tag4")
                        .font(.caption)
                        .frame(width: 4 * 10, height: 25, alignment: .center)
                        .background(Color.gray)
                        .cornerRadius(8)
                }.foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            Image(systemName: "chevron.forward")
                .frame(width: 50, height: 80, alignment: .center)
        }
        .frame(height: 80, alignment: .center)
    }
}

struct MainPageSurveyPreview_Previews: PreviewProvider {
    static var previews: some View {
        MainPageSurveyPreview().previewDevice("iPhone 11")
    }
}
