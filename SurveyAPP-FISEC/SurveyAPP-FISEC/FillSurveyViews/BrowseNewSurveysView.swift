//
//  BrowseNewSurveysView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 01/04/2021.
//

import Defaults
import Combine
import SwiftUI


class AnswersClass: ObservableObject {
    @Published var answers: [FinalAnswer] = []
}


struct BrowseNewSurveysView: View {
    @State private var questionaires = [PublicQuestionaire]()
    @State private var isActive = [Bool]()
    @State private var showAlert = false
    @State private var errMsg = "Unknown error. Please try again later."
    @State private var showSheet = false
    
    @State var tags = [TagStruct]()
    @State var newTags = [TagStruct]()
    
    @Default(.token) var tok
    @Default(.userID) var userID
    
    @StateObject
    var questionairesModel = QnairesModel()
    
    @StateObject
    var answers = AnswersClass()
    
    var body: some View {
        // TODO Reload
        NavigationView{
            Group {
                if questionaires.isEmpty {
                    PlaceHolderView(txt: "There are no surveys left")
                } else {
                    List {
                        ForEach(questionaires.indices, id: \.self) { i in
                            if haveSame(qTags: questionaires[i].tags) {
                                NavigationLink(
                                    destination: SurveyMainView(survey: questionaires[i], rootIsActive: self.$isActive[i]), isActive: self.$isActive[i]){
                                    MainPageSurveyPreview(questionaire: questionaires[i])
                                }.isDetailLink(false)
                            }
                        }
                    }.listStyle(PlainListStyle())
                    
                }
            }.navigationBarTitle(Text("Surveys"), displayMode: .inline)
            .navigationBarItems(leading: HStack {
                Text(String(format: "%.2f", Defaults[.tokens]))
                Image(systemName: "circlebadge.2.fill")
            }.foregroundColor(.blue), trailing:
                Button(action: {
                    showSheet = true
                }){
                    HStack {
                        Text("Filter")
                        Image(systemName: "line.horizontal.3.decrease")
                    }.foregroundColor(.blue)
                })
        }.onAppear(perform: {
                answers.answers = []
                questionaires = []
                loadData()
            }).sheet(isPresented: $showSheet, content: {
                AddTagView(tags: $tags, newTags: $newTags)
            })
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Error"), message: Text(errMsg), dismissButton: .default(Text("Ok")){
                questionairesModel.error = nil
            })
        })
        .environmentObject(answers)
    }
    
    func haveSame(qTags: [TagStruct]) -> Bool {
        if newTags.isEmpty {
            return true
        }
        for y in newTags {
            for z in qTags {
                if y == z {
                    return true
                }
            }
        }
        return false
    }
    
    func loadData() {
        let group = DispatchGroup()
        group.enter()
        questionairesModel.loadQuestionaire(g: group)
        group.notify(queue: DispatchQueue.main) {
            if let e = questionairesModel.error {
                if e.description == "Unauthorized" {
                    tok = nil
                    userID = nil
                }
                errMsg = e.description
                showAlert = true
            } else {
                for _ in questionairesModel.surveys ?? [] {
                    isActive.append(false)
                }
                questionaires = questionairesModel.surveys ?? []
            }
        }
        
    }
}

struct BrowseNewSurveysView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseNewSurveysView().previewDevice("iPhone 11")
    }
}



