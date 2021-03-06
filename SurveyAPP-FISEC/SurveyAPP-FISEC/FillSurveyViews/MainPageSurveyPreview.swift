//
//  MainPageSurveyPreview.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 14/02/2021.
//

import SwiftUI

/// View for showing survey preview
struct MainPageSurveyPreview: View {
    @State var questionnaire: PublicQuestionnaire
    
    var body: some View {
        HStack {
            if questionnaire.image == nil {
                Image("SurveyPlaceHolder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 80, alignment: .center)
            } else {
                // todo real image
                Image("SurveyPlaceHolder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 80, alignment: .center)
            }
            VStack {
                HStack {
                    Text(questionnaire.title)
                        .font(.title2)
                    Spacer()
                    VStack {
                        HStack{
                            Text(String(format:  "%.2f", questionnaire.tokens))
                            Image(systemName: "circlebadge.2.fill")
                        }
                        .font(.footnote)
                        .foregroundColor(.blue)
                        Spacer()
                    }.frame(width: 60, height: 40, alignment: .trailing)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    if !questionnaire.tags.isEmpty {
                        ScrollView (.horizontal, showsIndicators: false) {
                            HStack { 
                                ForEach(questionnaire.tags, id: \.id) { t in
                                    Text(t.name)
                                        .font(.caption)
                                        .frame(width: CGFloat((t.name.count)) * 9, height: 25, alignment: .center)
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
        let questionnaire = PublicQuestionnaire(id: UUID(), tags: [], title: "Title", description: "Description", closeAfterDate: "22.12.1222", nQuestions: 3, tokens: 200,  image: nil)
        MainPageSurveyPreview(questionnaire: questionnaire).previewDevice("iPhone 11")
    }
}

