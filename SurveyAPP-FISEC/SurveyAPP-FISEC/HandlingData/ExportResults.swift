//
//  ExportResults.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 20/04/2021.
//

import Foundation



/// Prepares survey results for exporting
/// - Parameter results: survey results
/// - Returns: encoded results
func prepareData(results: [QuestionResult]) -> String {
    var rs = [ExportResult]()
    for item in results {
        switch item.qType {
        case .ClosedSelectMultiple, .ClosedSelectOne:
            rs.append(ExportResult(question: item.question, options: item.options, qType: item.qType, stringAnswers: nil, optionsPercentage: item.optionsPercentage))
            break
        case .Opened:
            rs.append(ExportResult(question: item.question, options: nil, qType: item.qType, stringAnswers: item.stringAnswers, optionsPercentage: nil))
            break
        default:
            rs.append(ExportResult(question: item.question, options: item.options, qType: item.qType, stringAnswers: item.stringAnswers, optionsPercentage: item.optionsPercentage))
            break
        }
    }
    let json = try? JSONEncoder().encode(rs)
    if let j = json {
        return String(data: j, encoding: .utf8) ?? ""
    }
    return ""
}
