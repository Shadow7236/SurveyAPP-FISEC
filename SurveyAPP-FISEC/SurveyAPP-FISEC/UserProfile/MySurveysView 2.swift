//
//  MySurveysView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 27/03/2021.
//

import Defaults
import Combine
import SwiftUI

/// View for showing users surveys
struct MySurveysView: View {
    @Default(.userID) var userID
    
    @StateObject
    var myQModel = MyQuestionnairesModel()
    
    @State private var activated = [QuestionnairePrivate]()
    @State private var deactivated = [QuestionnairePrivate]()
    
    
    @State var showingAlert = false
    @State var indexSet: IndexSet? = nil
    @State private var errMsg = "Unexpected error."
    
    var body: some View {
        VStack {
            if activated.isEmpty && deactivated.isEmpty {
                if myQModel.error != nil {
                    PlaceHolderView(txt: "There are no surveys")
                } else {
                    if let r = myQModel.surveys {
                        if r.isEmpty {
                            PlaceHolderView(txt: "There are no surveys")
                        } else {
                            VStack(spacing: 10) {
                                ProgressView()
                                Text("Loading surveys.")
                            }
                        }
                    } else {
                        VStack(spacing: 10) {
                            ProgressView()
                            Text("Loading surveys.")
                        }
                    }
                }
            } else {
                List {
                    Text("Active surveys:")
                        .fontWeight(.bold)
                    if activated.isEmpty {
                        Text("There are no active surveys")
                    } else {
                        ForEach(activated.indices, id: \.self) { i in
                            NavigationLink(destination: QuestionnaireResultsView(surveyID: activated[i].id, closed: false)) {
                                MainPageSurveyPreview(questionnaire: PublicQuestionnaire(id: activated[i].id, tags: activated[i].tags, title: activated[i].title, description: activated[i].description, closeAfterDate: activated[i].closeAfterDate, nQuestions: activated[i].nQuestions, tokens: activated[i].tokens, image: activated[i].img))
                            }
                        }
                    }
                    Text("Closed surveys:")
                        .fontWeight(.bold)
                    if deactivated.isEmpty {
                        Text("There are no closed surveys")
                    } else {
                        ForEach(deactivated.indices, id: \.self) { i in
                            NavigationLink(destination: QuestionnaireResultsView(surveyID: deactivated[i].id, closed: true)) {
                                MainPageSurveyPreview(questionnaire: PublicQuestionnaire(id: deactivated[i].id, tags: deactivated[i].tags, title: deactivated[i].title, description: deactivated[i].description, closeAfterDate: deactivated[i].closeAfterDate, nQuestions: deactivated[i].nQuestions, tokens: deactivated[i].tokens, image: deactivated[i].img))
                            }
                        }
                    }
                }
            }
        }.onAppear(perform: loadData)
        .navigationTitle("My surveys")
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text("Error"), message: Text(errMsg), dismissButton: .default(Text("Ok")){myQModel.error = nil})
        })
    }
    
    
    
    /// Loads users surveys
    func loadData() {
        if let iid = userID {
            if let id = UUID(uuidString: iid){
                let group = DispatchGroup()
                group.enter()
                myQModel.loadQuestionnaires(id: id, g: group)
                group.notify(queue: DispatchQueue.main) {
                    if let e = myQModel.error {
                        errMsg = e.description
                        showingAlert = true
                    }
                    if let s = myQModel.surveys {
                        deactivated = []
                        activated = []
                        for item in s {
                            if item.deactiv {
                                deactivated.append(item)
                            } else {
                                activated.append(item)
                            }
                        }
                    } else {
                        errMsg = "Unexpected error."
                        showingAlert = true
                    }
                }
            }
        }
    }
}

struct MySurveysView_Previews: PreviewProvider {
    static var previews: some View {
        MySurveysView()
    }
}
