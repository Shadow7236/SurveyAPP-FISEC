//
//  QuestionView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 23/03/2021.
//

import SwiftUI

/// View for showing question
struct QuestionView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @StateObject
    var tmpAnswer = TemporaryAnswerClass()
    
    @StateObject
    var questionModel = QuestionModel()
    @State private var action: Int? = 0
    
    @State var questions: [Question]
    @State var index: Int
    @State var newStringAnswer: String = ""
    @Binding var shouldPopToRootView: Bool
    @State var errMsg = "Unexpected error."
    
    @State var nextActive = false
    @Binding var meActive: Bool
    
    @StateObject
    var answerModel = AnswerModel()
    var questionnaireID: UUID
    @State var showAlert: Bool = false
    @State var errTitle = "Error:"
    var body: some View {
        VStack {
            if index < questions.count {
                HStack {
                    Text("Progress").font(.caption)
                    Spacer()
                }.padding(.top)
                .padding(.leading)
                ProgressBarView(count: Double(questions.count), current: Double(index)).padding(.leading)
                    .padding(.trailing)
                    .padding(.bottom)
                Text(questions[index].qText)
                    .font(.title2)
                    .lineLimit(nil)
                    .padding(.leading)
                    .padding(.trailing)
                AnswerView(tmpAnswer: tmpAnswer, question: questions[index], newAnswer: newStringAnswer, index: index, questionnaireID: questionnaireID)
            } else {
                VStack{
                    ProgressView()
                    Text("Loading")
                    Spacer()
                }
            }
            if questions.count != 0 {
                HStack {
                    if index != 0 {
                        Button(action: {
                            let check = tmpAnswer.addAnswer(index: index, check: false)
                            if !check.0 {
                                showAlert = true
                                errMsg = check.1
                            } else {
                                index -= 1
                                self.action = index
                            }
                        }){
                            Text("Previous")
                                .font(.title3)
                                .frame(width: 100, height: 50, alignment: .center)
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .padding()
                        }
                    }
                    if index == questions.count - 1  {
                        Button(action: sendData){
                            Text("Complete")
                                .font(.title3)
                                .frame(width: 100, height: 50, alignment: .center)
                                .foregroundColor(.white)
                                .background(Color.green)
                                .cornerRadius(10)
                                .padding()
                        }
                    } else {
                        Button(action: {
                            let check = tmpAnswer.addAnswer(index: index)
                            if !check.0 {
                                showAlert = true
                                errMsg = check.1
                            } else {
                                index += 1
                                nextActive = true
                                self.action = index
                            }
                        }){
                            Text("Next")
                                .font(.title3)
                        }.frame(width: 100, height: 50, alignment: .center)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                    }
                }
            } else {
                VStack {
                    Button(action: {
                        meActive = false
                        self.shouldPopToRootView = false
                        self.mode.wrappedValue.dismiss()
                    }){
                        Text("Back to main page")
                            .font(.title3)
                            .frame(width: 200, height: 50, alignment: .center)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding()
                    }
                }
            }
            Spacer()
        }.onAppear(perform: {
            loadData()
            action = 0
        })
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text(errTitle), message: Text(errMsg))
        })
    }
    
    /// Loads question
    func loadData() {
        let group = DispatchGroup()
        group.enter()
        questionModel.loadQuestion(id: questionnaireID, g: group)
        group.notify(queue: DispatchQueue.main) {
            if let e = questionModel.error {
                errMsg = e.description
                showAlert = true
            }
            questions = questionModel.questions ?? []
        }
    }
    
    
    
    
    /// Sends answers to server
    func sendData()  {
        let check = tmpAnswer.addAnswer(index: index)
        if check.0 {
            if !tmpAnswer.answers.isEmpty {
                answerModel.answers = tmpAnswer.answers
                let group = DispatchGroup()
                group.enter()
                answerModel.sendData(g: group)
                group.notify(queue: DispatchQueue.main) {
                    if let e = answerModel.error {
                        errMsg = e.description
                        showAlert = true
                    } else {
                        tmpAnswer.answers = []
                        tmpAnswer.tmpAnswer = nil
                        answerModel.answers = []
                        questionModel.questions = []
                        newStringAnswer = ""
                        action = 0
                        meActive = false
                        shouldPopToRootView = false
                        self.mode.wrappedValue.dismiss()
                    }
                }
            } else {
                showAlert = true
            }
        } else {
            errMsg = check.1
            showAlert = true
        }
    }
    
    
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        let a = Question(id: UUID(), belongsToQuestionnaire: BelongsTo(id: UUID()), qText: "Question?", qType: .Opened, qOptions: "sadf", index: -1)
        QuestionView(questions: [a], index: 0, shouldPopToRootView: .constant(false), meActive: .constant(true), questionnaireID: UUID())
    }
}
