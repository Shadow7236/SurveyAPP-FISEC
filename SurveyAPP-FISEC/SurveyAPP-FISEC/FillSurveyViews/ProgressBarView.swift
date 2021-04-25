//
//  ProgressBarView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 23/03/2021.
//

import SwiftUI

struct ProgressBarView: View {
    var count: Double
    var current: Double
    
    var body: some View {
        ProgressView("", value: current, total: count)
    }
}

struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarView(count: 10, current: 5)
    }
}
