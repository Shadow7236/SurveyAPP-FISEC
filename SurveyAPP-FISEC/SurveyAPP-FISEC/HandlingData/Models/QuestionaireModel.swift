//
//  QuestionaireModel.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 29/03/2021.
//

import Combine
import Foundation


class QuestionaireModel: GeneralModel, ObservableObject {
    @Published
    var survey: Questionaire?
    
    @Published
    var s: PublicQuestionaire?
    
    var newSurvey: CreateSurvey?
    
    func loadQuestionaire(id: UUID) {
        _loadData(id: id)
    }
    
    func _loadData(id: UUID) {
        let stringID = id.uuidString
        let url = URL(string: _serverURL + "/questionnaires/detail/" + stringID)!
        self.subscriber = URLSession.requestPublisher(url: url, resultAs: Questionaire.self)
            .sink { [weak self] completion in
                self?.handleEnd(completion: completion)
            } receiveValue: { [weak self] s in
                self?.survey = s
            }
    }
    
    func sendData(g: DispatchGroup) {
        if let _ = newSurvey  {
            _sendData(g: g)
        } else {
            self.error = .requestError(error!)
        }
    }
    
    private func _sendData(g: DispatchGroup){
        let url = URL(string: _serverURL + "/questionnaires")!
        self.subscriber = URLSession.requestPublisher(method: .post, url: url, body: newSurvey, resultAs: PublicQuestionaire.self)
            .sink { [weak self] completion in
                self?.handleEnd(completion: completion, g: g)
            } receiveValue: { s in
                self.s = s
            }
    }
}
