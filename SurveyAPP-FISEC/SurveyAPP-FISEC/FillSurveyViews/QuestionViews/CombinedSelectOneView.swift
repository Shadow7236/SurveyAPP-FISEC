//
//  CombinedSelectOneView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 26/03/2021.
//

import SwiftUI

class IsSpecialSelectedModel: ObservableObject {
    @Published
    var isSpecialSelected = false
}

struct CombinedSelectOneView: View {
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
                                tmpAnswer.tmpAnswer?.selected = []
                            } else {
                                tmpAnswer.tmpAnswer?.selected = [i]
                            }
                        }) {
                            HStack {
                                if a.selected.contains(i) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundColor(.blue)
                                }
                                Text(a.options[i])
                            }
                        }
                    } else {
                        Button(action: {
                            if a.selected.contains(i) {
                                    tmpAnswer.tmpAnswer?.selected = []
                            } else {
                                tmpAnswer.tmpAnswer?.selected = [i]
                            }
                        }){
                            VStack {
                                HStack {
                                    if a.selected.contains(i) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.blue)
                                    } else {
                                        Image(systemName: "circle")
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
    
    
    func createOption() {
        do {
            let a = try JSONDecoder().decode(DatabaseCombinedSelectOneQuestion.self, from: encodedOption.data(using: .utf8)!)
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
            tmpAnswer.tmpAnswer?.selected = [   ]
            placeholder = ""
        }
    }
}




struct CombinedSelectOneView_Previews: PreviewProvider {
    static var previews: some View {
        CombinedSelectOneView(tmpAnswer: TemporaryAnswerClass(  ), encodedOption: "", index: 0, noAnswerYet: FinalAnswer(userID: "", aType: .CombinedOne, answer: "", selected: [-1], question: "", questionaire: UUID(), index: 0, options: []))
    }
}
