//
//  CombinedSelectMultipleView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 26/03/2021.
//

import SwiftUI

struct CombinedSelectMultipleView: View {
    @EnvironmentObject var answers: AnswersClass

    var encodedOption: String
    var index: Int
    @Binding var isSpecialSelected: Bool
    @Binding var selectedObjects: [Int]
    @Binding var options: [String]
    @Binding var newA: String
    @Binding var defaultVal: String
    @Binding var specialOptionName: String
    @State var areSelected: [Bool] = []
    
    @State var tmp: String = ""

    
    var body: some View {
        List {
            ForEach(options.indices, id: \.self) { i in
                Button(action: {
                    if areSelected[i] {
                        areSelected[i] = false
                        if let index = selectedObjects.firstIndex(of: i) {
                            selectedObjects.remove(at: index)
                        }
                    } else {
                        areSelected[i] = true
                        selectedObjects.append(i)
                        selectedObjects.sort()
                    }
                }) {
                    HStack {
                        if areSelected.count <= 0 || areSelected[i] {
                            Image(systemName: "checkmark.rectangle.fill")
                                        .foregroundColor(.blue)
                            } else {
                                Image(systemName: "square")
                                        .foregroundColor(.blue)
                            }
                        Text(options[i])
                    }
                }
            }
            Button(action: {
                if areSelected[options.count] {
                    if let index = selectedObjects.firstIndex(of: options.count) {
                        selectedObjects.remove(at: index)
                    }
                    isSpecialSelected = false
                    areSelected[options.count] = false
                } else {
                    areSelected[options.count] = true
                    isSpecialSelected = true
                    selectedObjects.append(options.count)
                }
            }){
                VStack {
                    HStack {
                        if options.count > areSelected.count - 1{
                            Image(systemName: "square")
                                    .foregroundColor(.blue)
                        } else {
                            if areSelected[options.count] {
                                Image(systemName: "checkmark.rectangle.fill")
                                        .foregroundColor(.blue)
                            } else {
                                Image(systemName: "square")
                                        .foregroundColor(.blue)
                            }
                        }
                        Text(specialOptionName)
                        Spacer()
                    }
                        TextField(defaultVal, text: $tmp).onChange(of: tmp, perform: { value in
                            newA = tmp
                        })
                    
                }
            }
        }.onAppear(perform: createOption)
    }
    
    
    func createOption() {
        do {
            if let val = encodedOption.data(using: .utf8) {
                let a = try JSONDecoder().decode(DatabaseCombinedSelectMultipleQuestion.self, from: val)
                if index >= answers.answers.count {
                    selectedObjects = []
                    options = a.options
                    for _ in 0..<(options.count+1) {
                        areSelected.append(false)
                    }
                } else {
                    options = a.options
                    var j = 0
                    for i in 0..<(options.count+1) {
                        if j < answers.answers[index].selected.count{
                            if i == answers.answers[index].selected[j] {
                                areSelected.append(true)
                                j += 1
                            } else {
                                areSelected.append(false)
                            }
                        } else {
                            areSelected.append(false)
                        }
                    }
                    selectedObjects = answers.answers[index].selected
                }
                if areSelected[areSelected.count-1] {
                    if answers.answers[index].answer == "" {
                        defaultVal = a.def
                    } else {
                        defaultVal = answers.answers[index].answer
                    }
                } else {
                    defaultVal = a.def
                }
                specialOptionName = a.otherOptionName
                
            } else {
                throw DataError.jsonError("Combined select one options can't be decoded.")
            }
        } catch {
            selectedObjects = []
            areSelected = [false, false]
            options = [""]
            defaultVal = ""
            specialOptionName = ""
        }
    }
}

struct CombinedSelectMultipleView_Previews: PreviewProvider {
    static var previews: some View {
        CombinedSelectMultipleView(encodedOption: "encoded coptions", index: 0, isSpecialSelected: .constant(false), selectedObjects: .constant([0]), options: .constant(["aaa","bbb"]), newA: .constant("new answer"), defaultVal: .constant("def val"), specialOptionName: .constant("name"))
    }
}
