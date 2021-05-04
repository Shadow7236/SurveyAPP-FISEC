//
//  AnswerView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 23/03/2021.
//

import Defaults
import SwiftUI

/// View for answering
struct AnswerView: View {
    @ObservedObject
    var tmpAnswer: TemporaryAnswerClass
    
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
    
    
    /// Creates view depending on question type
    /// - Returns: view
    @ViewBuilder
    func getView() -> some View {
        if let usrID = Defaults[.userID] {
            let noAnswerYet = FinalAnswer(userID: usrID, aType: question.qType, answer: "", selected: [], question: question.qText, questionaire: question.belongsToQuestionaire.id, index: question.index, options: [])
            switch question.qType {
            case .Opened:
                OpenedQuestionView(tmpAnswer: tmpAnswer, encodedOption: question.qOptions, index: index, noAnswerYet: noAnswerYet)
            case .ClosedSelectOne:
                ClosedSelectOneQuestionView(tmpAnswer: tmpAnswer, encodedOption: question.qOptions, index: index, noAnswerYet: noAnswerYet)
            case .ClosedSelectMultiple:
                ClosedSelectMultipleView(tmpAnswer: tmpAnswer, encodedOption: question.qOptions, index: index, noAnswerYet: noAnswerYet)
            case .CombinedOne:
                CombinedSelectOneView(tmpAnswer: tmpAnswer, encodedOption: question.qOptions, index: index, noAnswerYet: noAnswerYet)
            case .CombinedMultiple:
                CombinedSelectMultipleView(tmpAnswer: tmpAnswer, encodedOption: question.qOptions, index: index, noAnswerYet: noAnswerYet)
            }
        } else {
            PlaceHolderView(txt: "There are no options.")
        }
    }
    
    
    
    
}

struct AnswerView_Previews: PreviewProvider {
    static var previews: some View {
        AnswerView(tmpAnswer: TemporaryAnswerClass(), question: Question(id: UUID(), belongsToQuestionaire: BelongsTo(id: UUID()), qText: "", qType: .Opened, qOptions: "{\ndefault: \"sadf\"\n}", index: -1), newAnswer: "", index: 0, questionaireID: UUID())
    }
}
