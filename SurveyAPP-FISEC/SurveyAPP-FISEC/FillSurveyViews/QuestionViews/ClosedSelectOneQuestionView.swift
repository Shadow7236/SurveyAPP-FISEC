//
//  ClosedSelectOneQuestionView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 24/03/2021.
//

import SwiftUI

struct ClosedSelectOneQuestionView: View {
    @EnvironmentObject var answers: AnswersClass

    
    var encodedOption: String
    var index: Int
    @Binding var selectedObject: Int
    @Binding var options: [String]

    
    
    var body: some View {
        List {
            ForEach(options.indices, id: \.self) { i in
                Button(action: {
                    if i == selectedObject {
                        selectedObject = -1
                    } else {
                        selectedObject = i
                    }
                }) {
                    HStack {
                        if i == selectedObject {
                        Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                        } else {
                            Image(systemName: "circle")
                                    .foregroundColor(.blue)
                        }
                        Text(options[i])
                    }
                }
            }
        }.onAppear(perform: {
            createOption()
        })
        
    }
    
    
    func createOption() {
        do {
            let a = try JSONDecoder().decode(DatabaseClosedSelectOneQuestion.self, from: encodedOption.data(using: .utf8)!)
            if index >= answers.answers.count {
                selectedObject = -1
                options = a.options
            } else {
                if answers.answers[index].selected.count < 1 {
                    options = a.options
                    selectedObject = -1
                } else {
                    if answers.answers[index].selected[0] < a.options.count && answers.answers[index].selected[0] >= 0 {
                        selectedObject = answers.answers[index].selected[0]
                    } else {
                        selectedObject = -1
                    }
                    options = a.options
                }
            }
        } catch {
            selectedObject = -1
            options = [""]
        }
    }
}

struct ClosedSelectOneQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        ClosedSelectOneQuestionView(encodedOption: "{ \n options: [\"asdf\",\n \"haha\"], \n selected: 0 \n }", index: 0, selectedObject: .constant(-1), options: .constant(["aaa", "bb"]))
    }
}
