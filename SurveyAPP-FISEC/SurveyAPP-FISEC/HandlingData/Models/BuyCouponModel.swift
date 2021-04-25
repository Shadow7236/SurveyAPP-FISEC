//
//  BuyCouponModel.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 01/04/2021.
//

import Combine
import Foundation


class BuyCouponModel: GeneralModel, ObservableObject {
    @Published
    var coupon: BuyCoupon?
    
    
    func sendData(g: DispatchGroup) {
        let url = URL(string: _serverURL + "/addedCoupons/buyCoupon")!
        if let c = coupon {
            self.subscriber = URLSession.requestPublisher(method: .post, url: url, body: c)
                .sink { [weak self] completion in
                    self?.handleEnd(completion: completion, g: g)
                } receiveValue: { _ in }
            
        } else { // TODO everywhere
            error = .otherError("Unexpected error")
            g.leave()
        }
    }
}
