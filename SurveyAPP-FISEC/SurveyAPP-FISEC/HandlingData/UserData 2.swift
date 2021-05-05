//
//  UserData.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 01/04/2021.
//

import Defaults
import Foundation

extension Defaults.Keys {
    static let userID = Key<String?>("userID")
    static let token = Key<String?>("token")
    static let tokens = Key<Double>("tokens", default: 0.0)
}

/// Public representation of user
struct UserPublic: Codable {
    var mail: String
    var tokens: Double
    let id: UUID
}

/// Represents HTTP answer of sign up/log in
struct NewSession: Codable {
  let token: String
  let user: UserPublic
}
