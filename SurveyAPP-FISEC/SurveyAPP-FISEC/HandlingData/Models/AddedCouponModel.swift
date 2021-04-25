//
//  AddedCouponModel.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 31/03/2021.
//

import Combine
import Foundation
import Defaults


class AddedCouponModel: GeneralModel, ObservableObject {
    @Published
    var coupons: [AddedCoupon]?
    
    @Published
    var newCoupon: AddedCoupon?
    
    func reloadData(g: DispatchGroup) {
        _loadData(g: g)
    }
    
    func delete(g: DispatchGroup, id: UUID)  {
        if let stringID = Defaults[.userID] {
            let url = URL(string: _serverURL + "/addedCoupons/" + id.uuidString + "/" + stringID)!
            self.subscriber = URLSession.requestPublisher(method: .delete, url: url)
                .sink { [weak self] completion in
                    self?.handleEnd(completion: completion, g: g)
                } receiveValue: { _ in }
        } else {
            error = .otherError("Internal error")
            g.leave()
        }
    }
    
    func loadMineData(g: DispatchGroup) {
        if let stringID = Defaults[.userID] {
            let url = URL(string: _serverURL + "/addedCoupons/" + stringID)!
            self.subscriber = URLSession.requestPublisher(url: url, resultAs: [AddedCoupon].self)
                .sink { [weak self] completion in
                    self?.handleEnd(completion: completion, g: g)
                } receiveValue: { [weak self] c in
                    self?.coupons = c
                }
        } else {
            error = .otherError("Internal error.")
            g.leave()
        }
    }
    
    func _loadData(g: DispatchGroup) {
        let url = URL(string: _serverURL + "/addedCoupons")!
        self.subscriber = URLSession.requestPublisher(url: url, resultAs: [AddedCoupon].self)
            .sink { [weak self] completion in
                self?.handleEnd(completion: completion, g: g)
            } receiveValue: { [weak self] c in
                self?.coupons = c
            }
    }
    
    func sendData(g: DispatchGroup) {
        let url = URL(string: _serverURL + "/addedCoupons")!
        if let coupon = newCoupon {
            self.subscriber = URLSession.requestPublisher(method: .post, url: url, body: coupon)
                .sink { [weak self] completion in
                    self?.handleEnd(completion: completion, g: g)
                } receiveValue: { [weak self] c in
                    self?.newCoupon = c
                }
        } else {
            error = .otherError("Internal error.")
            g.leave()
        }
    }
}
