//
//  DataReceiveSend.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 16/03/2021.
//

import Foundation

let _serverURL = "https://fisec.herokuapp.com"
//let _serverURL = "http://127.0.0.1:8080"

enum HTTPError: String, LocalizedError {
    case statusCode
    case notFound
    case unauthorized
    case conflict
    case misdirected
    
    public var errorDescription: String? {
        switch self {
        case .statusCode:
            return "Unexpected error"
        case .notFound:
            return "Not found"
        case .unauthorized:
            return "Unauthorized"
        case .conflict:
            return "Email already taken"
        case .misdirected:
            return "Misdirected"
        }
    }
}

enum DataError: Error {
    case jsonError(String)
}

struct TagStruct: Codable, Equatable {
    var id: String
    var name: String
}

struct BelongsTo: Codable {
    var id: UUID
}


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

struct Questionaire: Codable {
    var id: UUID
    var createdBy: BelongsTo
    var title: String
    var description: String
    var closeAfterDate: String
    var nQuestions: Int
    var nRespondents: Int
    var tokens: Double
    var tags: [TagStruct]
    var img: Data?
}

struct QuestionairePrivate: Codable {
    var id: UUID
    var title: String
    var description: String
    var closeAfterDate: String
    var nQuestions: Int
    var nRespondents: Int
    var tokens: Double
    var tags: [TagStruct]
    var img: Data?
    var deactiv: Bool
}


struct CreateSurvey: Codable {
    var questionaire: Questionaire
    var questions: [Question]
}

struct PublicQuestionaire: Codable{
    let id: UUID
    var tags: [TagStruct]
    var title: String
    var description: String
    var closeAfterDate: String
    var nQuestions: Int
    var tokens: Double
    var image: Data?
}

struct AddedCoupon: Codable {
    var id: UUID
    var addedBy: BelongsTo
    var fromServer: String
    var value: Double
    var name: String
    var token: String?
}

struct Answer: Codable {
    var id: UUID
    var belogsTo: BelongsTo
    var aType: QuestionTypes
    var aValue: String
}

struct QuestionIndexStruct: Equatable {
    static func == (lhs: QuestionIndexStruct, rhs: QuestionIndexStruct) -> Bool {
        if lhs.index == rhs.index {
            if lhs.question.id == rhs.question.id && lhs.question.belongsToQuestionaire.id == rhs.question.belongsToQuestionaire.id && lhs.question.qOptions == rhs.question.qOptions && lhs.question.qText == rhs.question.qText && lhs.question.qType == rhs.question.qType{
                return true
            }
        }
        return false
    }
    
    var question: Question
    var index: Int
}

struct BoughtCouponPublic: Codable {
    var id: String
    var activated: Bool
    var used: Bool
    var name: String
    var value: Double
    var code: String?
}

struct Question: Codable {
    var id: UUID
    var belongsToQuestionaire: BelongsTo
    var qText: String
    var qType: QuestionTypes
    var qOptions: String
    var index: Int
}


struct UserSignup: Codable {
    var username: String
    let password: String
}


struct User: Codable {
    var id: UUID
    var email: String
    var name: String
    var surname: String
    var tokens: Double
    var tags: [String]? 
}


struct BuyCoupon: Codable {
    var userID: UUID
    var couponID: UUID
}

struct Results: Codable {
    var nRespondents: Int
    var results: [QuestionResult]
}

struct QuestionResult: Codable {
    var qID: UUID
    var question: String
    var options: [String]
    var qType: QuestionTypes
    var stringAnswers: [String]
    var optionsPercentage: [Double]
}

struct ExportResult: Codable {
    var question: String
    var options: [String]?
    var qType: QuestionTypes
    var stringAnswers: [String]?
    var optionsPercentage: [Double]?
}
