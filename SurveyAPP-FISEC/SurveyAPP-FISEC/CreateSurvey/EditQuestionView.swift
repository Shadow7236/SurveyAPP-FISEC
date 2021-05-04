//
//  EditQuestionView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 19/04/2021.
//

import SwiftUI

/// View for editing question
struct EditQuestionView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var answers: DataSource

    @Binding var question: QuestionIndexStruct
    @State var source: Question
    
    @State var questionText: String
    @State private var openEndAnswer = ""
    @State var selection: QuestionTypes
    @State var optionName = ""
    @State var showAlert = false
    @State var alertMsg = "Unexpected error"
    
    @State var index: Int
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
                    TextField(source.qText, text: $questionText)
                }
            }
            Section {
                Text("Answers:")
                getCreateAnswerView()
            }
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text("Error"), message: Text(alertMsg), dismissButton: .default(Text("Ok")))
            })
        }.onAppear(perform: {
            createOptionElements()
        })
        .navigationTitle("Edit question")
        .navigationBarItems(trailing:
                                Button(action: {
                                    if saveQuestion() {
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
            var data = ""
            switch selection {
            case .Opened:
                data = try String(data: JSONEncoder().encode(DatabaseOpenedQuestion(def: openEndAnswer, answer: "")), encoding: .utf8) ?? ""
                break
            case .ClosedSelectMultiple:
                if answers.textArray.count < 2 {
                    alertMsg = "There have to be at least 2 options"
                    showAlert = true
                    return false
                }
                data = try String(data: JSONEncoder().encode(DatabaseClosedSelectMultipleQuestion(options: answers.textArray, selected: [0])), encoding: .utf8) ?? ""
                break
            case .ClosedSelectOne:
                if answers.textArray.count < 2 {
                    alertMsg = "There have to be at least 2 options"
                    showAlert = true
                    return false
                }
                data = try String(data: JSONEncoder().encode(DatabaseClosedSelectOneQuestion(options: answers.textArray, selected: 0)), encoding: .utf8) ?? ""
                break
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
                data = try String(data: JSONEncoder().encode(DatabaseCombinedSelectOneQuestion(def: openEndAnswer, options: answers.textArray, selected: 0, otherOptionName: optionName, answer: "")), encoding: .utf8) ?? ""
                break
            case .CombinedMultiple:
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
                data = try String(data: JSONEncoder().encode(DatabaseCombinedSelectMultipleQuestion(def: openEndAnswer, options: answers.textArray, selected: [0], otherOptionName: optionName, answer: "")), encoding: .utf8) ?? ""
                break
            }
            if data != "" {
                question = QuestionIndexStruct(question: Question(id: source.id, belongsToQuestionaire: source.belongsToQuestionaire, qText: questionText, qType: selection, qOptions:  data, index: source.index), index: index)
                return true
            } else {
                alertMsg = "Unexpected error"
                showAlert = true
                return false
            }
            
        } catch {
            alertMsg = "Unexpected error"
            showAlert = true
        }
        return false
    }
    
    @State var optionElements = [(Int, String)]()
    
    /// Encodes question speciality
    func createOptionElements()  {
        if optionElements.isEmpty {
            do {
                switch selection {
                case .ClosedSelectOne:
                    if let data = source.qOptions.data(using: .utf8) {
                        let tmp = try JSONDecoder().decode(DatabaseClosedSelectOneQuestion.self, from: data)
                        answers.textArray = tmp.options
                    } else {
                        answers.textArray = []
                    }
                case .ClosedSelectMultiple:
                    if let data = source.qOptions.data(using: .utf8) {
                        let tmp = try JSONDecoder().decode(DatabaseClosedSelectMultipleQuestion.self, from: data)
                        answers.textArray = tmp.options
                    } else {
                        answers.textArray = []
                    }
                case .Opened:
                    if let data = source.qOptions.data(using: .utf8) {
                        let tmp = try JSONDecoder().decode(DatabaseOpenedQuestion.self, from: data)
                        openEndAnswer = tmp.def
                    } else {
                        answers.textArray = []
                    }
                case .CombinedOne:
                    if let data = source.qOptions.data(using: .utf8) {
                        let tmp = try JSONDecoder().decode(DatabaseCombinedSelectOneQuestion.self, from: data)
                        answers.textArray = tmp.options
                        openEndAnswer = tmp.def
                        optionName = tmp.otherOptionName
                    } else {
                        answers.textArray = []
                    }
                case .CombinedMultiple:
                    if let data = source.qOptions.data(using: .utf8) {
                        let tmp = try JSONDecoder().decode(DatabaseCombinedSelectMultipleQuestion.self, from: data)
                        answers.textArray = tmp.options
                        openEndAnswer = tmp.def
                        optionName = tmp.otherOptionName
                    } else {
                        answers.textArray = []
                    }
                }
            }
            catch {
                answers.textArray = []
            }
            optionElements = Array(zip(0..., answers.textArray))
        }
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
                            Button(action: {
                                print(index, text)
                                answers.textArray.remove(at: index)
                                optionElements = Array(zip(0..., answers.textArray))
                            }){
                                Image(systemName: "xmark")
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
                    optionElements = Array(zip(0..., answers.textArray))
                }) {
                    Text("Add answer")
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
                            Button(action: {
                                print(index, text)
                                answers.textArray.remove(at: index)
                                optionElements = Array(zip(0..., answers.textArray))
                            }){
                                Image(systemName: "xmark")
                            }
                        }
                    }
                } else {
                    VStack {
                        Text("There are no options yet")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
                VStack {
                    TextField("Open option name", text: self.$optionName)
                    TextField("Placeholder...", text: self.$openEndAnswer)
                }
                Button(action:{
                    self.answers.textArray.append("")
                    optionElements = Array(zip(0..., answers.textArray))
                }) {
                    Text("Add answer")
                }
            }
        case .Opened:
            TextField("Enter your placeholder", text: self.$openEndAnswer)
        }
    }
}


struct EditQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        EditQuestionView(question: .constant(QuestionIndexStruct(question :Question(id: UUID(), belongsToQuestionaire: BelongsTo(id: UUID()), qText: "adsad", qType: .ClosedSelectOne, qOptions: "asdf", index: -1), index: 20)), source: Question(id: UUID(), belongsToQuestionaire: BelongsTo(id: UUID()), qText: "adsad", qType: .ClosedSelectOne, qOptions: "asdf", index: -1), questionText: "asdf", selection: .ClosedSelectOne, index: 20)
    }
}

