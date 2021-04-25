//
//  GeneralModelClass.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 29/03/2021.
//

import Combine
import Foundation


class GeneralModel {
    @Published
    var error: ModelError?
    
    var subscriber: Cancellable?
    
    enum ModelError: Error, Identifiable, CustomStringConvertible {
        case requestError(Error)
        case otherError(String)
        
        var description: String {
            switch self {
            case let .requestError(error):
                return "\(error.localizedDescription)"
            case let .otherError(error):
                return "\(error)"
            }
        }
        
        var id: String {
            description
        }
    }
    
    init() {
        _loadData()
    }
    
    func reloadData() {
        _loadData()
    }
    
    func _loadData() {}
    
    func handleEnd(completion: Subscribers.Completion<Error>) {
        defer { self.subscriber = nil }
        switch completion {
        case .finished:
            break
        case .failure(let error):
            self.error = .requestError(error)
        }
    }
    
    func handleEnd(completion: Subscribers.Completion<Error>, g: DispatchGroup) {
        handleEnd(completion: completion)
        g.leave()
    }
}
