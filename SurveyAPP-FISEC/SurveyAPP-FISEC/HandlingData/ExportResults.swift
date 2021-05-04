//
//  ExportResults.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 20/04/2021.
//

import Foundation



/// Prepares survey results for exporting
/// - Parameters:
///   - results: survey results
///   - nRes: number of respondents
/// - Returns: encoded results
func prepareData(results: [QuestionResult], nRes: Int) -> String {
    var rs = [ExportResults]()
    for item in results {
        switch item.qType {
        case .ClosedSelectMultiple, .ClosedSelectOne:
            rs.append(ExportResults(question: item.question, options: item.options, qType: item.qType, stringAnswers: nil, optionsPercentage: item.optionsPercentage))
            break
        case .Opened:
            rs.append(ExportResults(question: item.question, options: nil, qType: item.qType, stringAnswers: item.stringAnswers, optionsPercentage: nil))
            break
        default:
            rs.append(ExportResults(question: item.question, options: item.options, qType: item.qType, stringAnswers: item.stringAnswers, optionsPercentage: item.optionsPercentage))
            break
        }
    }
    let result = ExportResult(numberOfRespondents: nRes, results: rs)
    let json = try? JSONEncoder().encode(result)
    if let j = json {
        return String(data: j, encoding: .utf8) ?? ""
    }
    return ""
}
