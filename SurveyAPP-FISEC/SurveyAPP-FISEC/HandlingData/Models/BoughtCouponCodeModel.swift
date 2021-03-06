//
//  BoughtCouponCodeModel.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 09/04/2021.
//

import Combine
import Foundation


/// Represents bought coupon in terms of communication with server
class BoughtCouponCodeModel: GeneralModel, ObservableObject {
    @Published
    var code: String?
    
    /// Activates coupon and gets discount code
    /// - Parameters:
    ///   - g: dispatch group
    ///   - id: coupon identifier
    func loadData(g: DispatchGroup, id: UUID) {
        let url = URL(string: _serverURL + "/boughtCoupons/activate/" + id.uuidString)!
        self.subscriber = URLSession.requestPublisher(method: .get, url: url, resultAs: StringStruct.self)
                .sink { [weak self] completion in
                    self?.handleEnd(completion: completion, g: g)
                } receiveValue: { c in
                    self.code = c.val
                }
    }
}
