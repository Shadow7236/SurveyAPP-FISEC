//
//  OpenedQuestionView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 23/03/2021.
//

import SwiftUI

/// View of opened question
struct OpenedQuestionView: View {
    @ObservedObject
    var tmpAnswer: TemporaryAnswerClass

    var encodedOption: String
    var index: Int
    @State var noAnswerYet: FinalAnswer
    
    @State var placeholder: String? = nil
    
    @State var defined: String = ""

    
    var body: some View {
        if let _ = placeholder {
            VStack {
                MultiLineTF(txt: $defined, placeholder: placeholder ?? "Type your answer.")
                    .onChange(of: defined, perform: { value in
                    if let _ = tmpAnswer.tmpAnswer {
                        if value != "" {
                            tmpAnswer.tmpAnswer?.answer = value
                        }
                    }
                })
                .border(Color.black)
                .padding(.leading)
                .padding(.trailing)
            }
        } else {
            VStack {
                ProgressView()
                PlaceHolderView(txt: "Loading question")
            }.onAppear(perform: {
                createOption(encoded: encodedOption)
            })
        }
    }
    
    
    
    /// Decodes question
    /// - Parameter encoded: encoded question specialization
    func createOption(encoded: String) {
        do {
            let a = try JSONDecoder().decode(DatabaseOpenedQuestion.self, from: encoded.data(using: .utf8)!)
            if index < tmpAnswer.answers.count {
                tmpAnswer.tmpAnswer = tmpAnswer.answers[index]
            } else {
                tmpAnswer.tmpAnswer = noAnswerYet
            }
            defined = tmpAnswer.tmpAnswer?.answer ?? a.def
            placeholder = a.def
        } catch {
            placeholder = ""
        }
        
    }
}

struct OpenedQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        OpenedQuestionView(tmpAnswer: TemporaryAnswerClass(), encodedOption: "{\ndefaultAnswer: \"asdf\"\n}", index: 0, noAnswerYet: FinalAnswer(userID: "", aType: .Opened, answer: "", selected: [], question: "", questionnaire: UUID(), index: 2, options: []))
    }
}
