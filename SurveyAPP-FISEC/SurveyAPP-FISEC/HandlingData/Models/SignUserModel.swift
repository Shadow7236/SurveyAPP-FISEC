//
//  SignUserModel.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 01/04/2021.
//

import Combine
import Foundation

/// Represents user in terms of sign up/log in communication with server
class SignUserModel: GeneralModel, ObservableObject {
    @Published
    var user: UserSignup?
    
    var result: NewSession?
    
    @Published
    var publicUser: UserPublic?
    
    /// Signs up user
    /// - Parameter g: dispatch group
    func sendData(g: DispatchGroup) {
        let url = URL(string: _serverURL + "/users/signup")!
        self.subscriber = URLSession.requestPublisher(method: .post, url: url, body: user, resultAs: NewSession.self)
            .sink { [weak self] completion in
                self?.handleEnd(completion: completion, g: g)
            } receiveValue: { [weak self] u in
                self?.result = u
            }
    }
    
    /// Logs in user
    /// - Parameter g: dispatch group
    func logIn(g: DispatchGroup) {
        let url = URL(string: _serverURL + "/users/login")!
        self.subscriber = URLSession.requestPublisher(method: .post, url: url, body: user, resultAs: NewSession.self)
            .sink { [weak self] completion in
                defer { self?.subscriber = nil }
                switch completion {
                case .finished:
                    g.leave()
                    break
                case .failure(let error):
                    self?.error = .requestError(error)
                    g.leave()
                }
            } receiveValue: { [weak self] u in
                self?.result = u
            }
    }
}
