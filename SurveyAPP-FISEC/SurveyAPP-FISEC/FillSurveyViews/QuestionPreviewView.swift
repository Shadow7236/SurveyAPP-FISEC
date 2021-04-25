//
//  QuestionPreviewView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 18/02/2021.
//

import SwiftUI

struct QuestionPreviewView: View {
    var question: Question?
    
    var body: some View {
        VStack {
            HStack {
                Text(question?.qText ?? "").font(.title3)
                Spacer()
            }
            HStack {
                Text(question?.qType.rawValue ?? "")
                Spacer()
            }
        }.padding()
    }
}

struct QuestionPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionPreviewView(question: nil).previewDevice("iPhone 11")
    }
}
