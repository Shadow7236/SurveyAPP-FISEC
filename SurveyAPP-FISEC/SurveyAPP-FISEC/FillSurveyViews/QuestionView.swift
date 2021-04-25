//
//  QuestionView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 23/03/2021.
//

import SwiftUI

struct QuestionView: View {
    @EnvironmentObject var answers: AnswersClass
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @StateObject
    var questionModel = QuestionModel()
    @State private var action: Int? = 0
    
    @State var questions: [Question]
    @Binding var index: Int
    @State var newStringAnswer: String = ""
    @Binding var shouldPopToRootView: Bool
    @State var errMsg = "Unexpected error."
    @State var an: FinalAnswer? = nil
    
    @State var nextActive = false
    @Binding var meActive: Bool
    
    @StateObject
    var answerModel = AnswerModel()
    var questionaireID: UUID
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
                    .font(.title)
                    .lineLimit(nil)
                if answers.answers.count <= index || (answers.answers.count == 0 && index == 0){
                    AnswerView(question: questions[index], newAnswer: newStringAnswer, index: index, questionaireID: questionaireID).onChange(of: an, perform: { value in
                        if let b = an {
                            answers.answers.append(b)
                        }
                    })
                } else {
                    AnswerView(question: questions[index], newAnswer: newStringAnswer, index: index, questionaireID: questionaireID).onChange(of: an, perform: { value in
                        if let b = an {
                            answers.answers[index] = b
                        }
                    })
                }
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
                            index -= 1
                            self.action = index
                            meActive = false
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
                        NavigationLink(destination: QuestionView(questions: questions, index: $index, shouldPopToRootView: self.$shouldPopToRootView,an: nil, meActive: $nextActive, questionaireID: questionaireID), isActive: $nextActive){
                            EmptyView()
                        }
                        Button(action: {
                            if index >= answers.answers.count {
                                showAlert = true
                            } else {
                                if !isAnswerCorrect(fansw: answers.answers[index]) {
                                    showAlert = true
                                } else {
                                    index += 1
                                    nextActive = true
                                    self.action = index
                                }
                            }
                        }){
                            Text("Next")
                                .font(.title3)
                        }.frame(width: 100, height: 50, alignment: .center)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                        .alert(isPresented: $showAlert, content: {
                            Alert(title: Text(errTitle), message: Text(errMsg))
                        })
                    }
                }
            } else {
                VStack {
                    Button(action: {self.shouldPopToRootView = false}){
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
    }
    
    func loadData() {
        let group = DispatchGroup()
        group.enter()
        questionModel.loadQuestion(id: questionaireID, g: group)
        group.notify(queue: DispatchQueue.main) {
            if let e = questionModel.error {
                errMsg = e.description
                showAlert = true
            }
            questions = questionModel.questions ?? []
        }
    }
    
    func sendData() -> Void {
        if !answers.answers.isEmpty && isAnswerCorrect(fansw: answers.answers[answers.answers.count-1]) {
            answerModel.answers = answers.answers
            let group = DispatchGroup()
            group.enter()
            answerModel.sendData(g: group)
            group.notify(queue: DispatchQueue.main) {
                if let e = answerModel.error {
                    errMsg = e.description
                    showAlert = true
                } else {
                    answers.answers = []
                    answerModel.answers = []
                    questionModel.questions = []
                    newStringAnswer = ""
                    an = nil
                    action = 0
                    meActive = false
                    shouldPopToRootView = false
                    self.mode.wrappedValue.dismiss()
                }
            }
        } else {
            showAlert = true
        }
    }
    
    func isAnswerCorrect(fansw: FinalAnswer) -> Bool {
        switch fansw.aType {
        case .Opened:
            if fansw.answer == "" {
                errMsg = "There is no answer."
                return false
            }
            break
        case .ClosedSelectOne,.ClosedSelectMultiple:
            if fansw.selected.isEmpty {
                errMsg = "No option selected."
                return false
            }
            break
        default:
            if fansw.selected.isEmpty{
                errMsg = "No option selected."
                return false
            }
            if fansw.selected.contains(fansw.options.count-1) && fansw.answer == "" {
                errMsg = "Open end option selected but not answered."
                return false
            }
        }
        return true
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        let a = Question(id: UUID(), belongsToQuestionaire: BelongsTo(id: UUID()), qText: "Question?", qType: .Opened, qOptions: "sadf", index: -1)
        QuestionView(questions: [a], index: .constant(0), shouldPopToRootView: .constant(false), meActive: .constant(true), questionaireID: UUID())
    }
}
