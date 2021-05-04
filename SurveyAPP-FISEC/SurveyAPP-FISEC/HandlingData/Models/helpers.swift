//
//  helpers.swift
//  SurveyAPP-FISEC
//
//  Taken from https://stackoverflow.com/a/26503188
//

import Foundation

/// Validates email
/// - Parameter str: represents email
/// - Returns: true if email is valid
func isValidEmail(str: String) -> Bool {
    let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
    return regex.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.count)) != nil
}
