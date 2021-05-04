//
//  AnswerModel.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 29/03/2021.
//
import Combine
import Foundation

/// Represents user answers to survey in terms of communication with server
class AnswerModel: GeneralModel, ObservableObject {
    @Published
    var answers: [FinalAnswer]?
    
    /// Sends answers
    /// - Parameter g: dispatch group
    func sendData(g: DispatchGroup) {
        if let _ = answers  {
            _sendData(g: g)
        } else {
            self.error = .otherError("There is no answer in model.")
            g.leave()
        }
    }
    
    /// Sends answers to server 
    /// - Parameter g: dispatch group
    private func _sendData(g: DispatchGroup){
        let url = URL(string: _serverURL + "/answers")!
        self.subscriber = URLSession.requestPublisher(method: .post, url: url, body: answers)
            .sink { [weak self] completion in
                self?.handleEnd(completion: completion, g: g)
            } receiveValue: {_ in }
    }
}
