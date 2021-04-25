//
//  ResultModel.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 30/03/2021.
//

import Combine
import Foundation




class ResultModel: GeneralModel, ObservableObject {
    @Published
    var results: Results?
    
    func loadResults(id: UUID, g: DispatchGroup) {
        _loadResults(id: id, g: g)
    }
    
    func _loadResults(id: UUID, g: DispatchGroup) {
        let stringID = id.uuidString
        let url = URL(string: _serverURL + "/results/" + stringID)!
        self.subscriber = URLSession.requestPublisher(url: url, resultAs: Results.self)
            .sink { [weak self] completion in
                self?.handleEnd(completion: completion, g: g)
            } receiveValue: { [weak self] s in
                self?.results = s
            }
    }
}
