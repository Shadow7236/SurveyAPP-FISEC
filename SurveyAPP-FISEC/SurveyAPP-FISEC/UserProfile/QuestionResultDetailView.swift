//
//  QuestionResultDetailView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 27/03/2021.
//

import SwiftUI

struct QuestionResultDetailView: View {
    var result: QuestionResult
    
    @State var pieChartData = PieChartData(data: [])

    
    @State var dataItems = [DataItem]()
    
    var body: some View {
            VStack {
                Text(result.question)
                    .font(.title2)
                    .padding()
                getOptions()
            }
    }
    
    @ViewBuilder
    func getOptions() -> some View {
    
        switch result.qType {
        case .Opened:
            List{
                ForEach(result.stringAnswers,id: \.self) { r in
                    Text(r)
                }
            }
        case .ClosedSelectOne, .ClosedSelectMultiple: 
            ScrollView{
                VStack {
                    List{
                        ForEach(result.options.indices) {i in
                            HStack {
                                Image(systemName: "square.fill")
                                    .foregroundColor(pieChartData.data[i].data.color)
                                Text(result.options[i])
                                Spacer()
                                Text(String(format: "%.2f", result.optionsPercentage[i]) + " %")
                            }.font(.headline)
                        }
                    }.frame(height: 45 * CGFloat(result.options.count))
                    Text("Graph").font(.headline)
                    GeometryReader { geometry in
                        self.makePieChart(geometry, pieChartData: self.pieChartData.data)
                    }.frame(alignment: .top)
                    .padding()
                }.onAppear(perform: {
                    makeDataItems()
                    pieChartData = PieChartData(data: result.optionsPercentage, dataItems: dataItems)
                })
            }
        case .CombinedMultiple, .CombinedOne:
            ScrollView{
                    VStack {
                        List{
                            ForEach(result.options.indices) {i in
                                HStack {
                                    Image(systemName: "square.fill")
                                        .foregroundColor(pieChartData.data[i].data.color)
                                    Text(result.options[i])
                                    Spacer()
                                    Text(String(format: "%.2f", result.optionsPercentage[i]) + " %")
                                }.font(.headline)
                            }
                        }.frame(height: 45 * CGFloat(result.options.count))
                        Text("Graph").font(.headline)
                        VStack{
                            GeometryReader { geometry in
                                makePieChart(geometry, pieChartData: pieChartData.data)
                            }.frame(height: 350, alignment: .top)
                        }.padding()
                        HStack{
                            Text(result.options[result.options.count-1]).fontWeight(.bold)
                            Spacer()
                        }.padding()
                            ForEach(result.stringAnswers, id: \.self) { r in
                                Divider()
                                HStack {
                                    Text(r).padding()
                                    Spacer()
                                }
                            }
                    }.onAppear(perform: {
                        makeDataItems()
                        pieChartData = PieChartData(data: result.optionsPercentage, dataItems: dataItems)
                    })
            }
        }
    }
    
    
    func makePieChart(_ geometry: GeometryProxy, pieChartData: [SlideData]) -> some View {
            return ZStack {
                ForEach(0..<pieChartData.count, id: \.self) { index in
                    PieChartSlideView(geometry: geometry, slideData: pieChartData[index])
                }
            }
        }
    
    func makeDataItems() -> Void {
        for i in 0..<result.options.count {
            dataItems.append(DataItem(name: result.options[i], value: result.optionsPercentage[i]))
        }
    }
}

struct QuestionResultDetailView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionResultDetailView(result: QuestionResult(qID: UUID(), question: "Some question?", options: ["option 1", "option 2"], qType: .CombinedOne, stringAnswers: ["answer"], optionsPercentage: [50, 50]))
    }
}
