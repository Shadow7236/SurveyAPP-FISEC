//
//  QuestionPreviewView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 18/02/2021.
//

import SwiftUI

struct QuestionPreviewView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Question").font(.title)
                Spacer()
            }
            HStack {
                Text("Type")
                Spacer()
                Text("Options: 10")
            }
        }.padding()
    }
}

struct QuestionPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionPreviewView().previewDevice("iPhone 11")
    }
}
