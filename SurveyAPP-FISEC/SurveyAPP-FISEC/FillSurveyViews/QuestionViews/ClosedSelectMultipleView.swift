//
//  ClosedSelectMultipleView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 26/03/2021.
//

import SwiftUI

/// View of closed select multiple question
struct ClosedSelectMultipleView: View {
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
                        if a.selected.contains(i) {
                            if let ind = a.selected.firstIndex(of: i) {
                                tmpAnswer.tmpAnswer?.selected.remove(at: ind)
                            }
                        } else {
                            tmpAnswer.tmpAnswer?.selected.append(i)
                            tmpAnswer.tmpAnswer?.selected.sort()
                        }
                    }) {
                        HStack {
                            if a.selected.contains(i) {
                                Image(systemName: "checkmark.rectangle.fill")
                                    .foregroundColor(.blue)
                            } else {
                                Image(systemName: "square")
                                    .foregroundColor(.blue)
                            }
                            Text(a.options[i])
                            Spacer()
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
            let a = try JSONDecoder().decode(DatabaseClosedSelectMultipleQuestion.self, from: encodedOption.data(using: .utf8)!)
            if index < tmpAnswer.answers.count {
                tmpAnswer.tmpAnswer = tmpAnswer.answers[index]
            } else {
                tmpAnswer.tmpAnswer = noAnswerYet
                tmpAnswer.tmpAnswer?.selected = []
                tmpAnswer.tmpAnswer?.options = a.options
            }
        } catch {
            tmpAnswer.tmpAnswer = noAnswerYet
            tmpAnswer.tmpAnswer?.selected = []
        }
    }
}

struct ClosedSelectMultipleView_Previews: PreviewProvider {
    static var previews: some View {
        ClosedSelectMultipleView(tmpAnswer: TemporaryAnswerClass(), encodedOption: "{ \n options: [\"asdf\",\n \"haha\"], \n selected: 0 \n }", index: 0, noAnswerYet: FinalAnswer(userID: "", aType: .ClosedSelectMultiple, answer: "", selected: [-1], question: "", questionnaire: UUID(), index: 0, options: []))
    }
}
