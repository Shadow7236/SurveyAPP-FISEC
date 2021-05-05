//
//  ClosedSelectOneQuestionView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 24/03/2021.
//

import SwiftUI

/// View of closed select one question
struct ClosedSelectOneQuestionView: View {
    @ObservedObject
    var tmpAnswer: TemporaryAnswerClass
    
    var encodedOption: String
    var index: Int
    @State var noAnswerYet: FinalAnswer
    
    var body: some View {
        if let a = tmpAnswer.tmpAnswer {
            List {
                ForEach(a.options.indices, id: \.self) { i in
                    Button(action: {
                        if i == a.selected[0] {
                            tmpAnswer.tmpAnswer?.selected = [-1]
                        } else {
                            tmpAnswer.tmpAnswer?.selected = [i]
                        }
                    }) {
                        HStack {
                            if i == a.selected[0] {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            } else {
                                Image(systemName: "circle")
                                    .foregroundColor(.blue)
                            }
                            Text(a.options[i])
                        }
                    }
                }
            }
        } else {
            VStack {
                ProgressView()
                PlaceHolderView(txt: "Loading question")
            }.onAppear(perform: {
                createOption()
            })
        }
    }
    
    
    /// Decodes question
    func createOption() {
        do {
            let a = try JSONDecoder().decode(DatabaseClosedSelectOneQuestion.self, from: encodedOption.data(using: .utf8)!)
            if index < tmpAnswer.answers.count {
                tmpAnswer.tmpAnswer = tmpAnswer.answers[index]
            } else {
                tmpAnswer.tmpAnswer = noAnswerYet
                tmpAnswer.tmpAnswer?.selected = [-1]
                tmpAnswer.tmpAnswer?.options = a.options
            }
        } catch {
            tmpAnswer.tmpAnswer = noAnswerYet
            tmpAnswer.tmpAnswer?.selected = [-1]
        }
    }
}

struct ClosedSelectOneQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        ClosedSelectOneQuestionView(tmpAnswer: TemporaryAnswerClass() ,encodedOption: "{ \n options: [\"asdf\",\n \"haha\"], \n selected: 0 \n }", index: 0, noAnswerYet: FinalAnswer(userID: "", aType: .ClosedSelectOne, answer: "", selected: [-1], question: "", questionnaire: UUID(), index: 2, options: []))
    }
}
