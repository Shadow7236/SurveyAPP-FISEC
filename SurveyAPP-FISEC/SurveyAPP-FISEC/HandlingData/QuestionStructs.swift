//
//  QuestionStruct.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 23/03/2021.
//

import Foundation

/// Represents question types
enum QuestionTypes: String, Codable, CaseIterable { 
    case ClosedSelectOne = "Select one"
    case ClosedSelectMultiple = "Select multiple"
    case Opened = "Opened"
    case CombinedOne = "Combined select one"
    case CombinedMultiple = "Combined select multiple"
}

/// Represents opened question
struct DatabaseOpenedQuestion: Codable {
    var def: String
    var answer: String
}

/// Represents closed select one question
struct DatabaseClosedSelectOneQuestion: Codable {
    var options: [String]
    var selected: Int
}

/// Represents closed select multiple question
struct DatabaseClosedSelectMultipleQuestion: Codable {
    var options: [String]
    var selected: [Int]
}

/// Represents combined select one question
struct DatabaseCombinedSelectOneQuestion: Codable {
    var def: String
    var options: [String]
    var selected: Int
    var otherOptionName: String
    var answer: String
}

/// Represents combined select multiple question
struct DatabaseCombinedSelectMultipleQuestion: Codable {
    var def: String
    var options: [String]
    var selected: [Int]
    var otherOptionName: String
    var answer: String
}

