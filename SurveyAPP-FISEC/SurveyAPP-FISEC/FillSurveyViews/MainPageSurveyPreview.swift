//
//  MainPageSurveyPreview.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 14/02/2021.
//

import SwiftUI

struct MainPageSurveyPreview: View {
    @State var questionaire: PublicQuestionaire
    
    var body: some View {
        HStack {
            if questionaire.image == nil {
                Image("SurveyPlaceHolder")
                    .resizable()
                    .scaledToFit()
                    // TODO Absolute sizes
                    .frame(width: 100, height: 80, alignment: .center)
            } else {
                // todo real image
                Image("SurveyPlaceHolder")
                    .resizable()
                    .scaledToFit()
                    // TODO Absolute sizes
                    .frame(width: 100, height: 80, alignment: .center)
            }
            VStack {
                HStack {
                    Text(questionaire.title)
                        .font(.title)
                    Spacer()
                    VStack {
                        HStack{
                            Text(String(format:  "%.2f", questionaire.tokens)) 
                            Image(systemName: "circlebadge.2.fill")
                        }
                        .font(.footnote)
                        .foregroundColor(.blue)
                        Spacer()
                    }.frame(width: 60, height: 40, alignment: .trailing)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    if questionaire.tags.isEmpty {
                        Text("No tags added yet")
                            .foregroundColor(.secondary)
                            .frame(height: 25, alignment: .leading)
                            .font(.caption)
                        Spacer()
                    } else {
                        ScrollView (.horizontal, showsIndicators: false) {
                            HStack { 
                                ForEach(questionaire.tags, id: \.id) { t in
                                    Text(t.name)
                                        .font(.caption)
                                        .frame(width: CGFloat((t.name.count)) * 7, height: 25, alignment: .center)
                                        .background(Color.gray)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                }.foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(height: 80, alignment: .center)
    }
}

struct MainPageSurveyPreview_Previews: PreviewProvider {
    static var previews: some View {        
        let questionaire = PublicQuestionaire(id: UUID(), tags: [], title: "Title", description: "Description", closeAfterDate: "22.12.1222", nQuestions: 3, tokens: 200,  image: nil)
        MainPageSurveyPreview(questionaire: questionaire).previewDevice("iPhone 11")
    }
}

