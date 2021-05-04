//
//  QnairesModel.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 06/04/2021.
//

import Defaults
import Combine
import Foundation


/// Represents surveys in terms of communication with server
class QnairesModel: GeneralModel, ObservableObject {
    @Published
    var surveys: [PublicQuestionnaire]?
    
    /// Loads surveys
    /// - Parameter g: dispatch group
    func loadQuestionaire(g: DispatchGroup) {
        _loadData(g: g)
    }
    
    /// Sends request for loading available surveys
    /// - Parameter g: dispatch group
    func _loadData(g: DispatchGroup) {
        if let stringID = Defaults[.userID] {
            let url = URL(string: _serverURL + "/questionnaires/" + stringID)!
            self.subscriber = URLSession.requestPublisher(url: url, resultAs: [PublicQuestionnaire].self)
                .sink { [weak self] completion in
                    self?.handleEnd(completion: completion, g: g)
                } receiveValue: { [weak self] s in
                    self?.surveys = s
                }
        } else {
            self.error = .otherError("Internal error")
        }
    }
}
