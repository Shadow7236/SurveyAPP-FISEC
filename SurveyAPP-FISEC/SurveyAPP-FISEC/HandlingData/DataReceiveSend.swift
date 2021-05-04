//
//  DataReceiveSend.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 16/03/2021.
//

import Foundation

/// Server urls
let _serverURL = "https://fisec.herokuapp.com"
//let _serverURL = "http://127.0.0.1:8080"

/// Known HTTP error codes
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

/// Error for JSON encoding decoding
enum DataError: Error {
    case jsonError(String)
}

/// Represents tag
struct TagStruct: Codable, Equatable {
    var id: String
    var name: String
}

/// Represents users answer to question
struct FinalAnswer: Codable, Equatable {
    var userID: String
    var aType: QuestionTypes
    var answer: String
    var selected: [Int]
    var question: String
    var questionnaire: UUID
    var index: Int
    var options: [String]
}


/// Private representation of survey
struct QuestionnairePrivate: Codable {
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


/// Struct for creating survey
struct CreateSurvey: Codable {
    var questionnaire: Questionnaire
    var questions: [Question]
}

/// Public representation of survey
struct PublicQuestionnaire: Codable, Identifiable {
    let id: UUID
    var tags: [TagStruct]
    var title: String
    var description: String
    var closeAfterDate: String
    var nQuestions: Int
    var tokens: Double
    var image: Data?
}

/// Represents added coupon
struct AddedCoupon: Codable, Identifiable {
    var id: UUID
    var addedBy: BelongsTo
    var fromServer: String
    var value: Double
    var name: String
    var token: String?
}

/// Struct holding index of question and question
struct QuestionIndexStruct: Equatable {
    /// Checks if two questions are same
    /// - Parameters:
    ///   - lhs: question on the left
    ///   - rhs: question on the left
    /// - Returns: true if questions are same
    static func == (lhs: QuestionIndexStruct, rhs: QuestionIndexStruct) -> Bool {
        if lhs.index == rhs.index {
            if lhs.question.id == rhs.question.id && lhs.question.belongsToQuestionnaire.id == rhs.question.belongsToQuestionnaire.id && lhs.question.qOptions == rhs.question.qOptions && lhs.question.qText == rhs.question.qText && lhs.question.qType == rhs.question.qType{
                return true
            }
        }
        return false
    }
    
    var question: Question
    var index: Int
}

/// Public representation of bought coupon
struct BoughtCouponPublic: Codable {
    var id: String
    var activated: Bool
    var used: Bool
    var name: String
    var value: Double
    var code: String?
}

/// Represents question
struct Question: Codable {
    var id: UUID
    var belongsToQuestionnaire: BelongsTo
    var qText: String
    var qType: QuestionTypes
    var qOptions: String
    var index: Int
}


/// Struct for user sign up
struct UserSignup: Codable {
    var username: String
    let password: String
}


/// Represents user
struct User: Codable {
    var id: UUID
    var email: String
    var name: String
    var surname: String
    var tokens: Double
    var tags: [String]? 
}


/// Struct for byuing coupon
struct BuyCoupon: Codable {
    var userID: UUID
    var couponID: UUID
}

/// Represents result of survey
struct Results: Codable {
    var nRespondents: Int
    var results: [QuestionResult]
}

/// Represents result of question
struct QuestionResult: Codable {
    var qID: UUID
    var question: String
    var options: [String]
    var qType: QuestionTypes
    var stringAnswers: [String]
    var optionsPercentage: [Double]
}

/// Struct for exporting question results
struct ExportResults: Codable {
    var question: String
    var options: [String]?
    var qType: QuestionTypes
    var stringAnswers: [String]?
    var optionsPercentage: [Double]?
}

/// Struct for exporting survey results
struct ExportResult: Codable {
    var numberOfRespondents: Int
    var results: [ExportResults]
}


/// Struct for encoding string
struct StringStruct: Codable {
    var val: String
}

/// Represents relation
struct BelongsTo: Codable {
    var id: UUID
}

/// Represents public part of questionnaire
struct Questionnaire: Codable {
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
