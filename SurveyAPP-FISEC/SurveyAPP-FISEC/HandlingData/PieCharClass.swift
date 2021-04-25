//
//  PieCharClass.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 27/03/2021.
//

// https://blog.nextzy.me/create-a-simple-pie-chart-with-swiftui-e39d75b4a740

import Foundation
import SwiftUI

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

class DataItem {
    var name: String! = ""
    var value: Double = 0.0
    var color: Color! = .blue
    
    init(name: String, value: Double, color: Color? = nil) {
        self.name = name
        self.value = value
        if let color = color {
            self.color = color
        } else {
            self.color = Color.random
        }
    }
}

class SlideData: Identifiable, ObservableObject {
    let id: UUID = UUID()
    var data: DataItem!
    var annotation: String! = ""
    var startAngle: Angle! = .degrees(0)
    var endAngle: Angle! = .degrees(0)
    var percentage: String! = ""
}

class PieChartData: ObservableObject {
    @Published private(set) var data: [SlideData] = []
    
    init(data: [Double], dataItems: [DataItem]) {
        var currentAngle: Double = -90
        var slides: [SlideData] = []
        let total = data.reduce(0.0, +)
        
        for index in 0..<data.count {
            let slide = SlideData()
            if index < dataItems.count {
                slide.data = dataItems[index]
                
                let percentage = data[index] / total * 100
                slide.percentage = String(format: "%.1f", percentage)
                
                slide.startAngle = .degrees(currentAngle)
                let angle = data[index] * 360 / total
                currentAngle += angle
                slide.endAngle = .degrees(currentAngle)
                
                slides.append(slide)
            }
        }
        self.data = slides
    }
    
    init(data: [SlideData]) {
        self.data = data
    }
}
