//
//  BoughtCouponsModel.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 09/04/2021.
//

import Defaults
import Combine
import Foundation


class BoughtCouponsModel: GeneralModel, ObservableObject {
    @Published
    var coupons: [BoughtCouponPublic]?
    
    
    func loadData(g: DispatchGroup) {
        if let id = Defaults[.userID] {
            let url = URL(string: _serverURL + "/boughtCoupons/" + id)!
            self.subscriber = URLSession.requestPublisher(method: .get, url: url, resultAs: [BoughtCouponPublic].self)
                    .sink { [weak self] completion in
                        self?.handleEnd(completion: completion, g: g)
                    } receiveValue: { c in
                        self.coupons = c
                    }
        } else {
            error = .otherError("Unexpected error.")
            g.leave()
        }
        
    }
}
