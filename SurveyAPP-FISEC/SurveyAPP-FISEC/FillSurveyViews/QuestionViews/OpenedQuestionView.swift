//
//  OpenedQuestionView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 23/03/2021.
//

import SwiftUI

struct OpenedQuestionView: View {
    @EnvironmentObject var answers: AnswersClass
    var encodedOption: String
    var index: Int
    @Binding var newA: String
    
    @State var placeholder: String = ""
    
    @State var defined: String = ""
    
    var body: some View {
        TextEditor(text: $placeholder).onChange(of: placeholder, perform: { value in
            if value != "" && value != defined {
                newA = value
            }
        }).onAppear(perform: {
            createOption(encoded: encodedOption)
        }).onTapGesture {
            if placeholder == defined {
                placeholder = ""
            }
        }
        .border(Color.black)
        .padding()
    }
    
    
    
    func createOption(encoded: String) {
        if index >= answers.answers.count {
            do {
                let a = try JSONDecoder().decode(DatabaseOpenedQuestion.self, from: encoded.data(using: .utf8)!)
                defined = a.def
                placeholder = a.def
            } catch {
                placeholder = ""
            }
        } else {
            placeholder = answers.answers[index].answer
        }
    }
}

struct OpenedQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        OpenedQuestionView(encodedOption: "{\ndefaultAnswer: \"asdf\"\n}", index: 0, newA: .constant(""))
    }
}
