//
//  BrowseNewSurveysView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 01/04/2021.
//

import Defaults
import Combine
import SwiftUI


/// View for browsing surveys
struct BrowseNewSurveysView: View {
    @State private var questionnaires = [PublicQuestionnaire]()
    @State private var isActive = [Bool]()
    @State private var showAlert = false
    @State private var errMsg = "Unknown error. Please try again later."
    @State private var showSheet = false
    
    @State var tags = [TagStruct]()
    @State var newTags = [TagStruct]()
    
    @Default(.token) var tok
    @Default(.userID) var userID
    
    @StateObject
    var questionnairesModel = QnairesModel()
    @State var redraw = false
    @State var id = UUID()
    
    var allQuestionnaires: [(UUID, Int)] {
        zip(self.questionnaires, 0...).map { ($0.id, $1) }
    }
    
    var body: some View {
        NavigationView{
            Group {
                if questionnaires.isEmpty {
                    PlaceHolderView(txt: "There are no surveys left")
                } else {
                    List {
                        ForEach(allQuestionnaires, id: \.0) { (_, i) in
                            if haveSame(qTags: questionnaires[i].tags) {
                                NavigationLink(
                                    destination: SurveyMainView(survey: questionnaires[i], rootIsActive: self.$isActive[i], id: $id), isActive: self.$isActive[i]) {
                                    MainPageSurveyPreview(questionnaire: questionnaires[i])
                                }.isDetailLink(false)
                                .onChange(of: id, perform: { value in
                                    if questionnaires[i].id == value {
                                        questionnaires.remove(at: i)
                                    }
                                })
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
                questionnaires = []
                loadData()
            }).sheet(isPresented: $showSheet, content: {
                AddTagView(tags: $tags, newTags: $newTags)
            })
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Error"), message: Text(errMsg), dismissButton: .default(Text("Ok")){
                questionnairesModel.error = nil
            })
        })
    }
    
    /// Checs if any of survey tags is included in searched tags
    /// - Parameter qTags: survey tags
    /// - Returns: True if any of tags in survey is searched
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
    
    /// Loads surveys
    func loadData() {
        let group = DispatchGroup()
        group.enter()
        questionnairesModel.loadQuestionnaire(g: group)
        group.notify(queue: DispatchQueue.main) {
            if let e = questionnairesModel.error {
                if e.description == "Unauthorized" {
                    tok = nil
                    userID = nil
                }
                errMsg = e.description
                showAlert = true
            } else {
                for _ in questionnairesModel.surveys ?? [] {
                    isActive.append(false)
                }
                questionnaires = questionnairesModel.surveys ?? []
            }
        }
        
    }
}

struct BrowseNewSurveysView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseNewSurveysView().previewDevice("iPhone 11")
    }
}



