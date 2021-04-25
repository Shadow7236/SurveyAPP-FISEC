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

struct UserPublic: Codable {
    var mail: String
    var tokens: Double
    let id: UUID
}

struct NewSession: Codable {
  let token: String
  let user: UserPublic
}
