//
//  UserModel.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 29/03/2021.
//
import Defaults
import Combine
import Foundation


/// Represents user in terms of communication with server
class UserModel: GeneralModel, ObservableObject {
    @Published
    var user: UserPublic?
    
    
    /// Reloads data
    /// - Parameter g: dispatch group
    func reloadData(g: DispatchGroup) {
        _loadData(g: g)
    }
    
    /// Loads user data
    /// - Parameter g: dispatch group
    func _loadData(g: DispatchGroup) {
        let url = URL(string: _serverURL + "/users/authUser/" + (Defaults[.userID] ?? ""))!
        self.subscriber = URLSession.requestPublisher(url: url, resultAs: UserPublic.self)
            .sink { [weak self] completion in
                self?.handleEnd(completion: completion, g: g)
            } receiveValue: { [weak self] user in
                self?.user = user
            }
    }
    
    /// Sends user data
    /// - Parameter g: dispatch group
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
