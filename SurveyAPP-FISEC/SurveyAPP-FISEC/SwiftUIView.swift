//
//  SwiftUIView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 24/04/2021.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        VStack {
            Text("This is VStack:")
            VStack {
                Text("1")
                Text("2")
                Text("3")
                Text("4").foregroundColor(.blue)
            }
        }.font(.title)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
