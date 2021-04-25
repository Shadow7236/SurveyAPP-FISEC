//
//  PieChartSlideView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 27/03/2021.
//
//https://blog.nextzy.me/create-a-simple-pie-chart-with-swiftui-e39d75b4a740
import SwiftUI

struct PieChartSlideView: View {
    var geometry: GeometryProxy
        var slideData: SlideData
        
        var path: Path {
            let chartSize = geometry.size.width
            let radius = chartSize / 2
            let centerX = radius
            let centerY = radius
            
            var path = Path()
            path.move(to: CGPoint(x: centerX, y: centerY))
            path.addArc(center: CGPoint(x: centerX, y: centerY),
                        radius: radius,
                        startAngle: slideData.startAngle,
                        endAngle: slideData.endAngle,
                        clockwise: false)
            return path
        }
        
        public var body: some View {
            path.fill(slideData.data.color)
                .overlay(path.stroke(Color.white, lineWidth: 1))
        }
}

struct PieChartSlideView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            PieChartSlideView(geometry: geometry, slideData: SlideData())
        }
    }
}
