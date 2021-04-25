//
//  QuestionStruct.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 23/03/2021.
//

import Foundation

enum QuestionTypes: String, Codable, CaseIterable { 
    case ClosedSelectOne = "Select one"
    case ClosedSelectMultiple = "Select multiple"
    case Opened = "Opened"
    case CombinedOne = "Combined select one"
    case CombinedMultiple = "Combined select multiple"
}

struct DatabaseOpenedQuestion: Codable {
    var def: String
    var answer: String
}

struct DatabaseClosedSelectOneQuestion: Codable {
    var options: [String]
    var selected: Int
}

struct DatabaseClosedSelectMultipleQuestion: Codable {
    var options: [String]
    var selected: [Int]
}

struct DatabaseCombinedSelectOneQuestion: Codable {
    var def: String
    var options: [String]
    var selected: Int
    var otherOptionName: String
    var answer: String
}

struct DatabaseCombinedSelectMultipleQuestion: Codable {
    var def: String
    var options: [String]
    var selected: [Int]
    var otherOptionName: String
    var answer: String
}

