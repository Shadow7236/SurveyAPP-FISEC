//
//  SurveyMainView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 22/03/2021.
//
import Combine
import SwiftUI


/// View for showing survey detail
struct SurveyMainView: View {
    var survey: PublicQuestionnaire
    @State private var questions: [Question]?
    @Binding var rootIsActive: Bool
    @Binding var id: UUID
    var body: some View {
        VStack {
            if survey.image == nil {
                Image("SurveyPlaceHolder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, alignment: .center)
            } else {
                if let a = UIImage(data: survey.image!) {
                    Image(uiImage: a)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 80, alignment: .center)
                } else {
                    Image("SurveyPlaceHolder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 80, alignment: .center)
                }
            }
            HStack {
                Text(survey.title)
                    .font(.title)
                    .lineLimit(nil)
            }
            Divider()
            VStack {
                HStack {
                    Text("Tags: ")
                    if survey.tags == [] {
                        Text("This survey has no tags")
                            .foregroundColor(.secondary)
                    } else {
                        ScrollView (.horizontal, showsIndicators: false) {
                            HStack { 
                                ForEach(survey.tags, id: \.id) { t in
                                    Text(t.name)
                                        .font(.caption)
                                        .frame(width: CGFloat((t.name.count)) * 8, height: 25, alignment: .center)
                                        .background(Color.gray)
                                        .cornerRadius(8)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    Spacer()
                }
                Divider()
                VStack {
                    HStack {
                        Text("Description:")
                            .frame(alignment: .leading)
                        Spacer()
                        Text("Reward: ")
                        Group {
                            Text(String(format: "%.2f", survey.tokens))
                            Image(systemName: "circlebadge.2.fill")
                        }.foregroundColor(.blue)
                    }
                    Group {
                        Text("\(survey.description)")
                            .lineLimit(nil)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .topLeading)
                            .padding(2)
                    }.border(Color.gray, width: 1)
                }
                Text("Number of questions: \(survey.nQuestions)")
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .topLeading)
            }
            Spacer()
            NavigationLink(destination: QuestionView(questions: questions ?? [], index: 0, shouldPopToRootView: self.$rootIsActive, meActive: .constant(true), questionnaireID: survey.id, id: $id)){
                    Text("Start survey")
                        .font(.title)
                        .font(.headline)
                }.isDetailLink(false)
                .frame(width: 200, height: 50, alignment: .center)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
                .font(.title)
                .padding()
            Spacer()
        }.navigationBarTitle(Text("Survey detail"), displayMode: .inline)
        .padding()
        
    }
}

struct SurveyMainView_Previews: PreviewProvider {
    static var previews: some View {
        let a = PublicQuestionnaire(id: UUID(), tags: [], title: "Title", description: "Description", closeAfterDate: "22.12.1222", nQuestions: 3, tokens: 200,  image: nil)
        NavigationView {
            SurveyMainView(survey: a, rootIsActive: .constant(false), id: .constant(UUID()))
        }
    }
}
