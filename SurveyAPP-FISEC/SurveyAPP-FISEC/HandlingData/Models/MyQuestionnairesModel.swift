//
//  MyQuestionnairesModel.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 30/03/2021.
//

import Defaults
import Combine
import Foundation


/// Represents users surveys in terms of communication with server
class MyQuestionnairesModel: GeneralModel, ObservableObject {
    @Published
    var surveys: [QuestionnairePrivate]?
    
    /// Loads users surveys
    /// - Parameters:
    ///   - id: survey identifier
    ///   - g: dispatch group
    func loadQuestionnaires(id: UUID, g: DispatchGroup) {
        _loadData(id: id, g: g)
    }
    
    /// Loads users surveys
    /// - Parameters:
    ///   - id: user identifier
    ///   - g: dispatch group
    func _loadData(id: UUID, g: DispatchGroup) {
        let stringID = id.uuidString
        let url = URL(string: _serverURL + "/questionnaires/mySurveys/" + stringID)!
        self.subscriber = URLSession.requestPublisher(url: url, resultAs: [QuestionnairePrivate].self)
            .sink { [weak self] completion in
                self?.handleEnd(completion: completion, g: g)
            } receiveValue: { [weak self] s in
                self?.surveys = s
            }
    }
    
    /// Closes survey
    /// - Parameters:
    ///   - g: dispatch group
    ///   - delID: survey identifier
    func delete(g: DispatchGroup, delID: UUID) {
        let url = URL(string: _serverURL + "/questionnaires/" + delID.uuidString)!
        if let uuidString = Defaults[.userID] {
            if let id = UUID(uuidString: uuidString) {
                let b = BelongsTo(id: id)
                self.subscriber = URLSession.requestPublisher(method: .delete, url: url, body: b)
                    .sink { [weak self] completion in
                        self?.handleEnd(completion: completion, g: g)
                    } receiveValue: { _ in }
            }
        }
    }
}
