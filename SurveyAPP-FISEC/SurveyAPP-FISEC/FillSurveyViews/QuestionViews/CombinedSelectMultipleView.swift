//
//  CombinedSelectMultipleView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 26/03/2021.
//

import SwiftUI

/// View of combined select miltiple question
struct CombinedSelectMultipleView: View {
    @ObservedObject
    var tmpAnswer: TemporaryAnswerClass
    
    var encodedOption: String
    var index: Int
    @State var noAnswerYet: FinalAnswer
    
    @State var placeholder: String = ""
    @State var defined: String = ""
    @State var optionName = ""
    @State var showOther = false
    
    var body: some View {
        if let a = tmpAnswer.tmpAnswer {
            List {
                ForEach(a.options.indices, id: \.self) { i in
                    if i != a.options.count-1 {
                        Button(action: {
                            if a.selected.contains(i) {
                                if let ind = tmpAnswer.tmpAnswer?.selected.firstIndex(of: i){
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
                            }
                        }
                    } else {
                        Button(action: {
                            if a.selected.contains(i) {
                                if let index = tmpAnswer.tmpAnswer?.selected.firstIndex(of: i){
                                    tmpAnswer.tmpAnswer?.selected.remove(at: index)
                                }
                            } else {
                                tmpAnswer.tmpAnswer?.selected.append(i)
                            }
                        }){
                            VStack {
                                HStack {
                                    if a.selected.contains(i) {
                                        Image(systemName: "checkmark.rectangle.fill")
                                            .foregroundColor(.blue)
                                    } else {
                                        Image(systemName: "square")
                                            .foregroundColor(.blue)
                                    }
                                    Text(optionName)
                                    Spacer()
                                }
                                if a.selected.contains(i) {
                                    TextField(placeholder, text: $defined).onChange(of: defined, perform: { value in
                                        tmpAnswer.tmpAnswer?.answer = value
                                    })
                                }
                            }
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
            let a = try JSONDecoder().decode(DatabaseCombinedSelectMultipleQuestion.self, from: encodedOption.data(using: .utf8)!)
            if index < tmpAnswer.answers.count {
                tmpAnswer.tmpAnswer = tmpAnswer.answers[index]
                defined = tmpAnswer.answers[index].answer
            } else {
                tmpAnswer.tmpAnswer = noAnswerYet
                tmpAnswer.tmpAnswer?.selected = []
                tmpAnswer.tmpAnswer?.options = a.options
                defined = tmpAnswer.tmpAnswer?.answer ?? a.def
                tmpAnswer.tmpAnswer?.options.append(a.otherOptionName)
            }
            optionName = a.otherOptionName
            placeholder = a.def
        } catch {
            tmpAnswer.tmpAnswer = noAnswerYet
            tmpAnswer.tmpAnswer?.selected = []
            placeholder = ""
        }
    }
}

struct CombinedSelectMultipleView_Previews: PreviewProvider {
    static var previews: some View {
        CombinedSelectMultipleView(tmpAnswer: TemporaryAnswerClass(), encodedOption: "encoded coptions", index: 0, noAnswerYet: FinalAnswer(userID: "", aType: .CombinedMultiple, answer: "", selected: [], question: "", questionnaire: UUID(), index: 0, options: []))
    }
}
