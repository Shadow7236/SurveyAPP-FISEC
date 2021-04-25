//
//  AnswerModel.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 29/03/2021.
//
import Combine
import Foundation

class AnswerModel: GeneralModel, ObservableObject {
    @Published
    var answers: [FinalAnswer]?
    
    func sendData(g: DispatchGroup) {
        if let _ = answers  {
            _sendData(g: g)
        } else {
            self.error = .otherError("There is no answer in model.")
        }
    }
    
    private func _sendData(g: DispatchGroup){
        let url = URL(string: _serverURL + "/answers")!
        self.subscriber = URLSession.requestPublisher(method: .post, url: url, body: answers)
            .sink { [weak self] completion in
                self?.handleEnd(completion: completion, g: g)
            } receiveValue: {_ in }
    }
}
