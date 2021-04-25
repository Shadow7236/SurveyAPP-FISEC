//
//  TagModel.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 08/04/2021.
//

import Combine
import Foundation



class TagModel: GeneralModel, ObservableObject {
    @Published
    var tags: [TagStruct]?
    
    override init() {}
    
    func loadAll(g: DispatchGroup) {
        let url = URL(string: _serverURL + "/tags" )!
        self.subscriber = URLSession.requestPublisher(url: url, resultAs: [TagStruct].self)
            .sink { [weak self] completion in
                self?.handleEnd(completion: completion, g: g)
            } receiveValue: { [weak self] q in
                self?.tags = q
            }
    }
    
    func loadSurveyTags(id: UUID, g: DispatchGroup) {
        let stringID = id.uuidString
        let url = URL(string: _serverURL + "/tags/" + stringID)!
        self.subscriber = URLSession.requestPublisher(url: url, resultAs: [TagStruct].self)
            .sink { [weak self] completion in
                self?.handleEnd(completion: completion, g: g)
            } receiveValue: { [weak self] q in
                self?.tags = q
            }
    }
    
}
