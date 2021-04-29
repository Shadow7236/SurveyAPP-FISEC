//
//  TmpAnswerClass.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 29/04/2021.
//

import Foundation

class TemporaryAnswerClass: ObservableObject {
    @Published
    var tmpAnswer: FinalAnswer? = nil
    
    var answers: [FinalAnswer] = []
    
    func nilIt() {
        self.tmpAnswer = nil
    }
    
    func addAnswer(index: Int, check: Bool = true) -> (Bool, String) {
        if let b = tmpAnswer {
            if check {
                let checked = isAnswerCorrect(fansw: b)
                if checked.0 {
                    if answers.count > index {
                        answers[index] = b
                    } else {
                        answers.append(b)
                    }
                    nilIt()
                    return (true, "")
                } else {
                    return checked
                }
            } else {
                if answers.count > index {
                    answers[index] = b
                } else {
                    answers.append(b)
                }
                nilIt()
                return (true, "")
            }
        }
        return (false, "There is no answer.")
    }
    
    func isAnswerCorrect(fansw: FinalAnswer) -> (Bool, String) {
        switch fansw.aType {
        case .Opened:
            if fansw.answer == "" {
                return (false, "There is no answer.")
            }
            break
        case .ClosedSelectOne,.ClosedSelectMultiple:
            if fansw.selected.isEmpty {
                return (false, "No option selected.")
            }
            break
        default:
            if fansw.selected.isEmpty{
                return (false, "No option selected.")
            } 
            if fansw.selected.contains(fansw.options.count-1) && fansw.answer == "" {
                return (false, "Open end option selected but not answered.")
                
            }
        }
        return (true, "")
    }
    
}

