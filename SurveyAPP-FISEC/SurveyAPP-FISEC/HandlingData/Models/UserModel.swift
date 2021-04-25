//
//  UserModel.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 29/03/2021.
//
import Defaults
import Combine
import Foundation


class UserModel: GeneralModel, ObservableObject {
    @Published
    var user: UserPublic?
    
    
    func reloadData(g: DispatchGroup) {
        _loadData(g: g)
    }
    
    func _loadData(g: DispatchGroup) {
        let url = URL(string: _serverURL + "/users/authUser/" + (Defaults[.userID] ?? ""))!
        self.subscriber = URLSession.requestPublisher(url: url, resultAs: UserPublic.self)
            .sink { [weak self] completion in
                self?.handleEnd(completion: completion, g: g)
            } receiveValue: { [weak self] user in
                self?.user = user
            }
    }
    
    func sendData(g: DispatchGroup) {
        let url = URL(string: _serverURL + "/users/authUser/" + (Defaults[.userID] ?? ""))!
        self.subscriber = URLSession.requestPublisher(method: .post, url: url, body: user)
            .sink { [weak self] completion in
                defer { self?.subscriber = nil }
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.error = .requestError(error)
                }
                g.leave()
            } receiveValue: { [weak self] user in
                self?.user = user
            }
    }
}
