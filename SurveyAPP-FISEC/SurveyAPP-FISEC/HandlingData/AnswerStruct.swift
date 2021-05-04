//
//  AnswerStruct.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 23/03/2021.
//

import Foundation

struct FinalAnswer: Codable, Equatable {
    var userID: String
    var aType: QuestionTypes
    var answer: String
    var selected: [Int]
    var question: String
    var questionaire: UUID
    var index: Int
    var options: [String]
}
