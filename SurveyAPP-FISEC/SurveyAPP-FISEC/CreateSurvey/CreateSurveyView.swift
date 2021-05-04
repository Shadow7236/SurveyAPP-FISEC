//
//  CreateSurveyView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 17/02/2021.
//

import Defaults
import Combine
import SwiftUI


/// View for creating survey
struct CreateSurveyView: View {
    @StateObject
    var questionnaireModel = QuestionnaireModel()
    
    @Default(.userID) var userID
    
    @State private var name = ""
    @State private var description = ""
    
    @State private var showingSheet = false
    @State var tags = [TagStruct]()
    @State var notUsed = [TagStruct]()
    @State var questions = [Question]()
    @StateObject var answers = DataSource()
    
    @State var chooseAlert = 0
    
    @State var isActive: Bool = false
    
    @State var questionnaireID = UUID()
    
    @State private var showingAlert = false
    @State var bindQuestion = QuestionIndexStruct(question: Question(id: UUID(), belongsToQuestionnaire: BelongsTo(id: UUID()), qText: "", qType: .Opened, qOptions: "", index: -1), index: -1)
    @State private var errorMsg = "Unexpected error"
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("Name:")
                        TextField("Enter name of survey", text: $name)
                    }
                    VStack {
                        HStack {
                            Text("Tags: ")
                            Spacer()
                            Button(action: {showingSheet.toggle()}){
                                HStack {
                                    Text("Add")
                                    Image(systemName: "plus")
                                        .padding(3)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(3.0)
                                }
                            }.buttonStyle(BorderlessButtonStyle())
                            .sheet(isPresented: $showingSheet) {
                                AddTagView(tags: $notUsed, newTags: $tags)
                            }
                        }
                        TagView(tags: $tags, selectedFrom: $notUsed)
                    }
                    VStack {
                        HStack {
                            Text("Description:")
                            Spacer()
                        }
                        TextEditor(text: $description)
                    }
                    Text("Number of questions: \(questions.count)")
                }
                Section {
                    NavigationLink(destination: CreateQuestionView(questions: $questions, questionnaireID: questionnaireID), isActive: self.$isActive){
                        Text("Add question")
                    }.isDetailLink(false)
                    .frame(alignment: .center)
                    .foregroundColor(.blue)
                }
                Section {
                    List {
                        ForEach(questions.indices, id: \.self) { i in
                            NavigationLink(destination: EditQuestionView(question: $bindQuestion, source: questions[i], questionText: questions[i].qText, selection: questions[i].qType, index: i)){
                                QuestionPreviewView(question: questions[i])
                            }
                        }.onDelete(perform: { indexSet in
                            questions.remove(atOffsets: indexSet)
                            for i in 0..<questions.count {
                                questions[i].index = i
                            }
                        })
                    }.onChange(of: bindQuestion, perform: { value in
                        questions[value.index] = value.question
                    })
                }
                Section {
                    Button(action: {
                        saveAndSend()
                    }) {
                        Text("Save and open survey")
                            .font(.headline)
                    }
                }
                Section {
                    Button(action: {
                        showingAlert = true
                        chooseAlert = 0
                    }) {
                        Text("Reset")
                            .font(.headline)
                            .foregroundColor(.red)
                            .frame(alignment: .center)
                    }
                }.alert(isPresented: $showingAlert) {
                    if chooseAlert == 0 {
                        return Alert(title: Text("Reset?"), message: Text("Do you really want to reset survey"), primaryButton: .destructive(Text("Yes")) {
                            self.questions = []
                            self.tags = []
                            self.description = ""
                            self.name = ""
                            self.questionnaireModel.survey = nil
                            self.questionnaireID = UUID()
                        }, secondaryButton: .default(Text("No")))
                    } else if chooseAlert == 2{
                        return Alert(title: Text("Success"), message: Text(errorMsg), dismissButton: .default(Text("Ok")){
                            questionnaireModel.error = nil
                        })
                    } else{
                        return Alert(title: Text("Error"), message: Text(errorMsg), dismissButton: .default(Text("Ok")){
                            questionnaireModel.error = nil
                        })
                    }
                }
            }.navigationBarItems(leading: HStack {
                Text(String(format:  "%.2f", Defaults[.tokens]))
                Image(systemName: "circlebadge.2.fill")
            }.foregroundColor(.blue))
            .navigationBarTitle("Create survey", displayMode: .inline)
            Spacer()
        }.environmentObject(answers)
    }
    
    /// Sends request to server to create survey
    func saveAndSend() {
        if let id = userID {
            if let idd = UUID(uuidString: id) {
                questionnaireModel.newSurvey = CreateSurvey(questionnaire: Questionnaire(id: questionnaireID, createdBy: BelongsTo(id: idd), title: name, description: description, closeAfterDate: "22.12.3000", nQuestions: questions.count, nRespondents: 0, tokens: computeTokens(), tags: tags, img: nil), questions: questions)
                if let s = questionnaireModel.newSurvey{
                    if controlSurvey(questionnaire: s) {
                        let group = DispatchGroup()
                        group.enter()
                        questionnaireModel.sendData(g: group)
                        group.notify(queue: DispatchQueue.main){
                            if let e = questionnaireModel.error {
                                self.errorMsg = e.description
                                self.chooseAlert = 1
                                self.showingAlert = true
                            } else {
                                self.tags = []
                                self.description = ""
                                self.name = ""
                                self.errorMsg = "Successfully created"
                                self.chooseAlert = 2
                                self.questionnaireID = UUID()
                                self.showingAlert = true
                                self.tags = []
                                self.notUsed = []
                                self.questions = []
                            }
                        }
                    }
                } else {
                    errorMsg = "Unexpected error"
                    chooseAlert = 1
                    self.showingAlert = true
                }
            } else {
                errorMsg = "Unexpected error"
                chooseAlert = 1
                self.showingAlert = true
            }
        } else {
            errorMsg = "Unexpected error"
            chooseAlert = 1
            self.showingAlert = true
        }
    }
    
    /// Controls survey
    /// - Parameter questionnaire: controlled survey
    /// - Returns: true if survey is correct
    func controlSurvey(questionnaire: CreateSurvey) -> Bool {
        if questionnaire.questionnaire.title == "" {
            errorMsg = "Title has to be set"
            chooseAlert = 1
            self.showingAlert = true
            return false
        }
        if questionnaire.questionnaire.nQuestions <= 0 {
            errorMsg = "There has to be at least one question"
            chooseAlert = 1
            self.showingAlert = true
            return false
        }
        return true
    }
    
    /// Computes survey reward
    /// - Returns: reward in tokens
    func computeTokens() -> Double {
        var sum = 0
        for i in 0..<questions.count {
            switch questions[i].qType {
            case .Opened:
                sum += 10
                break
            case .ClosedSelectMultiple:
                sum+=2
                break
            case .ClosedSelectOne:
                sum+=1
                break
            case .CombinedOne:
                sum+=4
                break
            case .CombinedMultiple:
                sum+=5
                break
            }
        }
        return Double(sum)
    }
    
}

struct CreateSurveyView_Previews: PreviewProvider {
    static var previews: some View {
        CreateSurveyView().previewDevice("iPhone 12")
    }
}
