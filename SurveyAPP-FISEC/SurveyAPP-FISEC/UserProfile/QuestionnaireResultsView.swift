//
//  QuestionnaireResultsView.swift
//  SurveyAPP-FISEC
//

import Combine
import SwiftUI

/// View for showing survey results
struct QuestionnaireResultsView: View {
    @State var surveyID: UUID
    @State private var results = [QuestionResult]()
    
    @StateObject
    var myQModel = MyQuestionnairesModel()
    
    @StateObject
    var answerModel = ResultModel()
    
    @State var showingAlert = false
    @State var chooseAlert = 1
    @State var errMsg = "Unexpected error."
    @State var part = 0
    
    @State var showSheet = false
    @State var text = "results"
    @State var closed: Bool
    
    var body: some View { 
        VStack{
            if results.isEmpty {
                PlaceHolderView(txt: "There are no results yet.")
                    .navigationBarItems(trailing: Button(action: {
                        chooseAlert = 0
                        showingAlert = true
                    }){
                        Text("Close")
                            .foregroundColor(.red)
                    })
            } else {
                HStack{
                    Text("Respondents: \(part)")
                    Spacer()
                }.padding()
                List {
                    ForEach(results.indices, id: \.self) { i in
                        NavigationLink(destination: QuestionResultDetailView(result: QuestionResult(qID: UUID(), question: results[i].question, options: results[i].options, qType: results[i].qType, stringAnswers: results[i].stringAnswers, optionsPercentage: results[i].optionsPercentage))) {
                            Text(results[i].question)
                        }
                    }
                    Spacer()
                    if !closed {
                        Button(action: {
                            chooseAlert = 0
                            showingAlert = true
                        }){
                            Text("Close")
                                .foregroundColor(.red)
                                .fontWeight(.bold)
                        }
                    }
                }.navigationBarItems(
                    trailing: Button(action: {
                        /// Creted by Dawy
                        /// Taken from https://stackoverflow.com/a/54031361
                        /// [Edited by Radovan Klembara (2021)]
                        let export = prepareData(results: results, nRes: part)
                        
                        let fm = FileManager.default
                        let fileFolder = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
                        let fileURL = fileFolder.appendingPathComponent(
                            "results.json"
                        )
                        do {
                            try export.write(to: fileURL, atomically: true, encoding: .utf8)
                        } catch {
                            errMsg = "File " + fileURL.absoluteString + " can't be created."
                            showingAlert = true
                            return
                        }
                        /// Creted by Amir
                        /// Taken from https://stackoverflow.com/a/64962982
                        ///  [Edited by Radovan Klembara (2021)]
                        let shareActivity = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
                        shareActivity.completionWithItemsHandler = {
                            (type, completed, items, error) in
                            do {
                                try fm.removeItem(at: fileURL)
                                print("Temporary file was successfully deleted.")
                            } catch {
                                print("File " + fileURL.absoluteString + " can't be deleted.")
                            }
                        }
                        if let vc = UIApplication.shared.windows.first?.rootViewController{
                            shareActivity.popoverPresentationController?.sourceView = vc.view
                            shareActivity.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height, width: 0, height: 0)
                            shareActivity.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
                            vc.present(shareActivity, animated: true, completion: nil)
                        }
                        
                    }) {
                        Text("Export")
                    }
                )
            }
        }
        .onAppear(perform: loadData)
        .navigationTitle("Survey results")
        .alert(isPresented: $showingAlert, content: {
            switch chooseAlert {
            case 0:
                return Alert(title: Text("Close?"), message: Text("Do you really want to close this survey?"), primaryButton: .destructive(Text("Yes")) {
                    closeQuestionnaire()
                    
                }, secondaryButton: .default(Text("No")))
            case 2:
                return Alert(title: Text("Success"), message: Text("Successfully closed survey."), dismissButton: .default(Text("Ok")))
            default:
                return Alert(title: Text("Error"), message: Text(errMsg), dismissButton: .default(Text("Ok")){
                    myQModel.error = nil
                    answerModel.error = nil
                })
            }
        })
    }
    
    
    /// Closes survey
    func closeQuestionnaire() {
        let group = DispatchGroup()
        group.enter()
        myQModel.delete(g: group, delID: surveyID)
        group.notify(queue: DispatchQueue.main){
            if let e = myQModel.error {
                errMsg = e.description
                chooseAlert = 1
                showingAlert = true
            } else {
                chooseAlert = 2
                showingAlert = true
            }
        }
    }
    
    
    /// Get results
    func loadData() {
        if let _ = answerModel.results {
            // do nothing
        } else {
            let group = DispatchGroup()
            group.enter()
            answerModel.loadResults(id: surveyID, g: group)
            group.notify(queue: DispatchQueue.main) {
                if let err = answerModel.error {
                    chooseAlert = 1
                    errMsg = err.description
                    showingAlert = true
                }
                results = answerModel.results?.results ?? []
                part = answerModel.results?.nRespondents ?? 0
            }
        }
    }
}

struct QuestionnaireResultsView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionnaireResultsView(surveyID: UUID(), closed: false)
    }
}
