//
//  PlaceHolderView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 09/04/2021.
//

import SwiftUI

/// Placeholder view
struct PlaceHolderView: View {
    var txt: String
    
    var body: some View {
        VStack{
            Text(txt)
                .font(.title3)
                .foregroundColor(.secondary)
                .padding()
            Spacer()
        }
    }
}

struct PlaceHolderView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceHolderView(txt: "placeholder")
    }
}
