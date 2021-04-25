//
//  AnswerView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 23/03/2021.
//

import Defaults
import SwiftUI

struct AnswerView: View {
    @EnvironmentObject var answers: AnswersClass
    
    var question: Question
    @State var newAnswer: String = ""
    
    @State var options: [String] = []
    
    @State var selectedOptions: [Int] = []
    
    var index: Int
    var questionaireID: UUID
    
    @State var isSpecialSel = false
    @State var nAnswer: String = ""
    @State var def: String = ""
    @State var specialOptionName: String = ""
    @State var selectedOption: Int = -1
    
    var body: some View {
        getView()
    }
    
    // todo change anyView
    @ViewBuilder
    func getView() -> some View {
        if let usrID = Defaults[.userID] {
            switch question.qType {
            case .Opened:
                OpenedQuestionView(encodedOption: question.qOptions, index: index, newA: $newAnswer).onChange(of: newAnswer, perform: { value in
                    if answers.answers.count <= index {
                        answers.answers.append(FinalAnswer(userID: usrID, aType: question.qType, answer: value, selected: [-2], question: question.qText, questionaire: questionaireID, index: index, options: []))
                    } else {
                        answers.answers[index] = FinalAnswer(userID: usrID, aType: question.qType, answer: value, selected: [-2], question: question.qText, questionaire: questionaireID, index: index, options: [])
                    }
                })
            case .ClosedSelectOne:
                ClosedSelectOneQuestionView(encodedOption: question.qOptions, index: index, selectedObject: $selectedOption, options: $options).onChange(of: selectedOption, perform: { value in
                    if answers.answers.count <= index {
                        answers.answers.append(FinalAnswer(userID: usrID, aType: question.qType, answer: nAnswer, selected: [value], question: question.qText, questionaire: questionaireID, index: index, options: options))
                    } else {
                        answers.answers[index] = FinalAnswer(userID: usrID, aType: question.qType, answer: nAnswer, selected: [value], question: question.qText, questionaire: questionaireID, index: index, options: options)
                    }
                })
            case .ClosedSelectMultiple:
                ClosedSelectMultipleView(encodedOption: question.qOptions, index: index, options: $options, selectedOptions: $selectedOptions).onChange(of: selectedOptions, perform: { value in
                    if answers.answers.count <= index {
                        answers.answers.append(FinalAnswer(userID: usrID, aType: question.qType, answer: nAnswer, selected: value, question: question.qText, questionaire: questionaireID, index: index, options: options))
                    } else {
                        answers.answers[index] = FinalAnswer(userID: usrID, aType: question.qType, answer: nAnswer, selected: value, question: question.qText, questionaire: questionaireID, index: index, options: options)
                    }
                })
            case .CombinedOne:
                CombinedSelectOneView(encodedOption: question.qOptions, index: index, isSpecialSelected: $isSpecialSel, selectedObject: $selectedOption, options: $options, newA: $nAnswer, defaultVal: $def, specialOptionName: $specialOptionName)
                    .onChange(of: selectedOption, perform: { value in
                    var opts = options
                    opts.append(specialOptionName)
                    if answers.answers.count <= index {
                        answers.answers = answers.answers + [FinalAnswer(userID: usrID, aType: question.qType, answer: nAnswer, selected: [value], question: question.qText, questionaire: questionaireID, index: index, options: opts)]
                    } else {
                        answers.answers[index] = FinalAnswer(userID: usrID, aType: question.qType, answer: nAnswer, selected: [value], question: question.qText, questionaire: questionaireID, index: index, options: opts)
                    }
                }).onChange(of: nAnswer, perform: { value in
                    var opts = options
                    opts.append(specialOptionName)
                    print(isSpecialSel)
                    print(nAnswer)
                    if !isSpecialSel {
                        nAnswer = ""
                    }
                    if answers.answers.count <= index {
                        answers.answers.append(FinalAnswer(userID: usrID, aType: question.qType, answer: nAnswer, selected: [selectedOption], question: question.qText, questionaire: questionaireID, index: index, options: opts))
                    } else {
                        answers.answers[index] = FinalAnswer(userID: usrID, aType: question.qType, answer: nAnswer, selected: [selectedOption], question: question.qText, questionaire: questionaireID, index: index, options: opts)
                    }
                })
            case .CombinedMultiple:
                CombinedSelectMultipleView(encodedOption: question.qOptions, index: index, isSpecialSelected: $isSpecialSel, selectedObjects: $selectedOptions, options: $options, newA: $nAnswer, defaultVal: $def, specialOptionName: $specialOptionName).onChange(of: selectedOptions, perform: { value in
                    var opts = options
                    if !isSpecialSel {
                        nAnswer = ""
                    }
                    opts.append(specialOptionName)
                    if answers.answers.count <= index {
                        answers.answers.append(FinalAnswer(userID: usrID, aType: question.qType, answer: nAnswer, selected: value, question: question.qText, questionaire: questionaireID, index: index, options: opts))
                    } else {
                        answers.answers[index] = FinalAnswer(userID: usrID, aType: question.qType, answer: nAnswer, selected: value, question: question.qText, questionaire: questionaireID, index: index, options: opts)
                    }
                }).onChange(of: nAnswer, perform: { value in
                    var opts = options
                    opts.append(specialOptionName)
                    if answers.answers.count <= index {
                        answers.answers.append(FinalAnswer(userID: usrID, aType: question.qType, answer: nAnswer, selected: selectedOptions, question: question.qText, questionaire: questionaireID, index: index, options: opts))
                    } else {
                        answers.answers[index] = FinalAnswer(userID: usrID, aType: question.qType, answer: nAnswer, selected: selectedOptions, question: question.qText, questionaire: questionaireID, index: index, options: opts)
                    }
                })
            }
        } else {
            PlaceHolderView(txt: "There are no options.")
        }
    }
    
    
    
    
}

struct AnswerView_Previews: PreviewProvider {
    static var previews: some View {
        AnswerView(question: Question(id: UUID(), belongsToQuestionaire: BelongsTo(id: UUID()), qText: "", qType: .Opened, qOptions: "{\ndefault: \"sadf\"\n}", index: -1), newAnswer: "", index: 0, questionaireID: UUID())
    }
}
