//
//  CreateQuestionView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 17/02/2021.
//

import SwiftUI

struct CreateQuestionView: View {
    @State private var selectedStrength = "Mild"
    let strengths = ["Mild", "Medium", "Mature"]
    
    @State private var question = ""
    
    @State private var answers = ["1", "2", "3"]
    @State private var newAnswer = ""
    
    var body: some View {
        Form {
            Section {
                VStack {
                    Text("Select type:")
                    Picker("Strength", selection: $selectedStrength) {
                        ForEach(strengths, id: \.self) {
                            Text($0)
                        }
                    }.pickerStyle(WheelPickerStyle())
                }
            }
            Section {
                HStack {
                    Text("Question:")
                    TextField("Enter question", text: $question)
                }
            }
            Section {
                Text("Answers:")
                List {
                    ForEach(0..<answers.count, id: \.self) { index in
                        TextField("Name", text: self.$answers[index])
                    }
                    Button(action:{
                        self.answers.append("")
                    }) {
                        Text("Add answer")
                    }
                }
            }
        }
    }
}

struct CreateQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        CreateQuestionView().previewDevice("iPhone 11")
    }
}
