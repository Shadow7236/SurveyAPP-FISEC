//
//  QuestionModel.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 29/03/2021.
//

import Combine
import Foundation


/// Represents questions in terms of communication with server
class QuestionModel: GeneralModel, ObservableObject {
    @Published
    var questions: [Question]?
    
    override init() {}
    
    /// Loads questions
    /// - Parameters:
    ///   - id: survey identifier
    ///   - g: dispatch group
    func loadQuestion(id: UUID, g: DispatchGroup) {
        _loadData(id: id,  g: g)
    }
    
    /// Gets questions from server
    /// - Parameters:
    ///   - id: survey identifier
    ///   - g: dispatch group
    func _loadData(id: UUID, g:  DispatchGroup) {
        let stringID = id.uuidString
        let url = URL(string: _serverURL + "/questions/" + stringID)!
        self.subscriber = URLSession.requestPublisher(url: url, resultAs: [Question].self)
            .sink { [weak self] completion in
                self?.handleEnd(completion: completion, g: g)
            } receiveValue: { [weak self] q in
                self?.questions = q
            }
    }
    
}
