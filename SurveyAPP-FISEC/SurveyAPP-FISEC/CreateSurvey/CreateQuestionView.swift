//
//  CreateQuestionView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 17/02/2021.
//

import SwiftUI

/// Represents list of text answers
class DataSource: ObservableObject {
    @Published var textArray = [""] {
        willSet {
            self.objectWillChange.send()
        }
    }
}

/// View for creating question
struct CreateQuestionView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var answers: DataSource
    
    @Binding var questions: [Question]
    
    var questionnaireID: UUID
    
    @State private var questionText = ""
    @State private var newAnswer = ""
    @State private var openEndAnswer = ""
    @State var selection: QuestionTypes = .Opened
    @State var optionName = ""
    @State var showAlert = false
    @State var alertMsg = "Unexpected error"
    
    var body: some View {
        Form {
            Section {
                VStack {
                    Text("Select question type:")
                    Picker("type", selection: $selection) {
                        ForEach(QuestionTypes.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }.pickerStyle(WheelPickerStyle())
                }
            }
            Section {
                HStack {
                    Text("Question:")
                    TextField("Enter question", text: $questionText)
                }
            }
            Section {
                Text("Answers:")
                getCreateAnswerView()
            }
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text("Error"), message: Text(alertMsg), dismissButton: .default(Text("Ok")))
            })
        }
        .navigationTitle("Create question")
        .navigationBarItems(
            trailing:
                Button(action: {
                    if saveQuestion() {
                        self.answers.textArray = []
                        self.mode.wrappedValue.dismiss()
                    }
                }){
                    Text("Save")
                })
    }
    
    /// Saves question
    /// - Returns: if question could be saved
    func saveQuestion() -> Bool{
        if questionText == "" {
            alertMsg = "There is no question"
            showAlert = true
            return false
        }
        do {
            switch selection {
            case .Opened:
                try questions.append(Question(id: UUID(), belongsToQuestionnaire: BelongsTo(id: questionnaireID), qText: questionText, qType: selection, qOptions:  String(data: JSONEncoder().encode(DatabaseOpenedQuestion(def: openEndAnswer, answer: "")), encoding: .utf8) ?? "", index: questions.count))
                return true
            case .ClosedSelectMultiple:
                if answers.textArray.count < 2 {
                    alertMsg = "There have to be at least 2 options"
                    showAlert = true
                    return false
                }
                for item in answers.textArray {
                    if item == "" {
                        alertMsg = "There can't be empty option"
                        showAlert = true
                        return false
                    }
                }
                try questions.append(Question(id: UUID(), belongsToQuestionnaire: BelongsTo(id:questionnaireID), qText: questionText, qType: selection, qOptions:  String(data: JSONEncoder().encode(DatabaseClosedSelectMultipleQuestion(options: answers.textArray, selected: [0])), encoding: .utf8) ?? "", index: questions.count))
                return true
            case .ClosedSelectOne:
                if answers.textArray.count < 2 {
                    alertMsg = "There have to be at least 2 options"
                    showAlert = true
                    return false
                }
                for item in answers.textArray {
                    if item == "" {
                        alertMsg = "There can't be empty option"
                        showAlert = true
                        return false
                    }
                }
                try questions.append(Question(id: UUID(), belongsToQuestionnaire: BelongsTo(id: questionnaireID), qText: questionText, qType: selection, qOptions:  String(data: JSONEncoder().encode(DatabaseClosedSelectOneQuestion(options: answers.textArray, selected: 0)), encoding: .utf8) ?? "", index: questions.count))
                return true
            case .CombinedOne:
                if optionName == "" {
                    alertMsg = "Option name can't be empty"
                    showAlert = true
                    return false
                }
                if answers.textArray.count < 1 {
                    alertMsg = "There have to be at least 2 options"
                    showAlert = true
                    return false
                }
                for item in answers.textArray {
                    if item == "" {
                        alertMsg = "There can't be empty option"
                        showAlert = true
                        return false
                    }
                }
                try questions.append(Question(id: UUID(), belongsToQuestionnaire: BelongsTo(id: questionnaireID), qText: questionText, qType: selection, qOptions:  String(data: JSONEncoder().encode(DatabaseCombinedSelectOneQuestion(def: openEndAnswer, options: answers.textArray, selected: 0, otherOptionName: optionName, answer: "")), encoding: .utf8) ?? "", index: questions.count))
                return true
            case .CombinedMultiple:
                if optionName == "" {
                    alertMsg = "Open option name can't be empty"
                    showAlert = true
                    return false
                }
                if answers.textArray.count < 1 {
                    alertMsg = "There have to be at least 2 options"
                    showAlert = true
                    return false
                }
                for item in answers.textArray {
                    if item == "" {
                        alertMsg = "There can't be empty option"
                        showAlert = true
                        return false
                    }
                }
                try questions.append(Question(id: UUID(), belongsToQuestionnaire: BelongsTo(id: questionnaireID), qText: questionText, qType: selection, qOptions:  String(data: JSONEncoder().encode(DatabaseCombinedSelectMultipleQuestion(def: openEndAnswer, options: answers.textArray, selected: [0], otherOptionName: optionName, answer: "")), encoding: .utf8) ?? "", index: questions.count))
                return true
            }
        } catch {
            alertMsg = "Unexpected error"
            showAlert = true
        }
        return false
    }
    
    var optionElements: [(Int, String)] {
        Array(zip(0..., answers.textArray))
    }
    
    /// View based on question type
    /// - Returns: specialized question view
    @ViewBuilder
    func getCreateAnswerView() -> some View {
        switch selection {
        case .ClosedSelectOne, .ClosedSelectMultiple:
            List {
                if !optionElements.isEmpty {
                    ForEach(optionElements, id: \.0) { (index, text) in
                        let a = $answers.textArray[index]
                        HStack {
                            TextField("Option", text: a)
                            Spacer()
                            if answers.textArray.count > 1{
                                Button(action: {
                                    print(index, text)
                                    answers.textArray.remove(at: index)
                                }){
                                    Image(systemName: "xmark")
                                }
                            }
                        }
                    }
                } else {
                    Text("There are no options yet")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Button(action:{
                    self.answers.textArray.append("")
                }) {
                    Text("Add option")
                }
            }
        case .CombinedOne, .CombinedMultiple:
            List {
                if !optionElements.isEmpty {
                    ForEach(optionElements, id: \.0) { (index, text) in
                        let a = $answers.textArray[index]
                        HStack {
                            TextField("Option", text: a)
                            Spacer()
                            if answers.textArray.count > 1{
                                Button(action: {
                                    answers.textArray.remove(at: index)
                                }){
                                    Image(systemName: "xmark")
                                }
                            }
                        }
                    }
                } else {
                    Text("There are no options yet")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                VStack {
                    TextField("Open option name", text: self.$optionName)
                    TextField("Placeholder...", text: self.$openEndAnswer)
                }
                Button(action:{
                    self.answers.textArray.append("")
                }) {
                    Text("Add option")
                }
            }
        case .Opened:
            TextField("Enter your placeholder", text: self.$openEndAnswer)
        }
    }
}

struct CreateQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateQuestionView(questions: .constant([]), questionnaireID: UUID()).previewDevice("iPhone 11")
        }
    }
}
