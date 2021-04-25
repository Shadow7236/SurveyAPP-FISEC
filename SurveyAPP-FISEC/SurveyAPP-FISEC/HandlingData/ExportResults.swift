//
//  ExportResults.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 20/04/2021.
//

import Foundation

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}



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
