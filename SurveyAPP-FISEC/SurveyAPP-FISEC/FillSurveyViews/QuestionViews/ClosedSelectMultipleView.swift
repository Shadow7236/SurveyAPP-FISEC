//
//  ClosedSelectMultipleView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 26/03/2021.
//

import SwiftUI

struct ClosedSelectMultipleView: View {
    @EnvironmentObject var answers: AnswersClass
    
    var encodedOption: String
    var index: Int
    @Binding var options: [String]
    @Binding var selectedOptions: [Int]
    @State var areSelected = [Bool]()
    
    var body: some View {
        List {
            ForEach(options.indices, id: \.self) { i in
                Button(action: {
                    if i < areSelected.count {
                        if areSelected[i] {
                            if let index = selectedOptions.firstIndex(of: i) {
                                selectedOptions.remove(at: index)
                                areSelected[i] = false
                            } else {
                                areSelected[i] = false
                            }
                        } else {
                            areSelected[i] = true
                            selectedOptions.append(i)
                            selectedOptions.sort()
                        }
                    }
                }) {
                    HStack{
                        if i < areSelected.count {
                            if areSelected[i] {
                                Image(systemName: "checkmark.rectangle.fill")
                                    .foregroundColor(.blue)
                            } else {
                                Image(systemName: "square")
                                    .foregroundColor(.blue)
                            }
                        }
                        Text(options[i])
                        Spacer()
                    }
                }
            }
        }.onAppear(perform: createOption)
    }
    
    
    func createOption() {
        do {
            let a = try JSONDecoder().decode(DatabaseClosedSelectMultipleQuestion.self, from: encodedOption.data(using: .utf8)!)
            if index >= answers.answers.count{
                options = a.options
                selectedOptions = []
            } else {
                selectedOptions = answers.answers[index].selected
                options = a.options
            }
        } catch {
            options = [""]
            selectedOptions = []
        }
        var j = 0
        for i in 0..<options.count {
            if j < selectedOptions.count {
                if i == selectedOptions[j] {
                    areSelected.append(true)
                    j += 1
                } else {
                    areSelected.append(false)
                }
            } else {
                areSelected.append(false)
            }
        }
    }
}

struct ClosedSelectMultipleView_Previews: PreviewProvider {
    static var previews: some View {
        ClosedSelectMultipleView(encodedOption: "{ \n options: [\"asdf\",\n \"haha\"], \n selected: 0 \n }", index: 0, options: .constant(["a", "b"]), selectedOptions: .constant([-1]))
    }
}
