//
//  GeneralModelClass.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 29/03/2021.
//

import Combine
import Foundation


/// Represents general class in terms of communication with server
class GeneralModel {
    @Published
    var error: ModelError?
    
    var subscriber: Cancellable?
    
    /// Known errors
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
    
    /// Reloads data
    func reloadData() {
        _loadData()
    }
    
    /// Loads data
    func _loadData() {}
    
    /// Handles HTTP answer code
    /// - Parameter completion: represents complition code
    func handleEnd(completion: Subscribers.Completion<Error>) {
        defer { self.subscriber = nil }
        switch completion {
        case .finished:
            break
        case .failure(let error):
            self.error = .requestError(error)
        }
    }
    
    /// Handles HTTP answer code and assures end of waiting
    /// - Parameters:
    ///   - completion: represents complition code
    ///   - g: dispatch group
    func handleEnd(completion: Subscribers.Completion<Error>, g: DispatchGroup) {
        handleEnd(completion: completion)
        g.leave()
    }
}
