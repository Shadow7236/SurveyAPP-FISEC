//
//  CombinedSelectOneView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 26/03/2021.
//

import SwiftUI

class IsSpecialSelectedModel: ObservableObject {
    @Published
    var isSpecialSelected = false
}

struct CombinedSelectOneView: View {
    @EnvironmentObject var answers: AnswersClass
    
    var encodedOption: String
    var index: Int
    
    @Binding
    var isSpecialSelected: Bool
    
    @Binding var selectedObject: Int
    @Binding var options: [String]
    @Binding var newA: String
    @Binding var defaultVal: String
    @Binding var specialOptionName: String
    
    @State var tmp: String = ""
    
    @State var showOther: Bool = false
    
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
            Button(action: {
                if selectedObject == options.count {
                    isSpecialSelected = false
                    selectedObject = -1
                } else {
                    isSpecialSelected = true
                    selectedObject = options.count
                }
            }){
                VStack {
                    Text("a \(isSpecialSelected.description)")
                    HStack {
                        if selectedObject == options.count {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                        } else {
                            Image(systemName: "circle")
                                .foregroundColor(.blue)
                        }
                        Text(specialOptionName)
                        Spacer()
//                        if showOther {
//                            Spacer()
//                        }
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
                let a = try JSONDecoder().decode(DatabaseCombinedSelectOneQuestion.self, from: val)
                if index >= answers.answers.count {
                    selectedObject = -1
                    options = a.options
                } else {
                    if answers.answers[index].selected.count > 0{
                        if answers.answers[index].selected[0] <= a.options.count && answers.answers[index].selected[0] >= 0 {
                            selectedObject = answers.answers[index].selected[0]
                            if answers.answers[index].selected[0] == options.count {
                                newA = answers.answers[index].answer
                            }
                        } else {
                            selectedObject = -1
                        }
                    } else {
                        selectedObject = -1
                    }
                    options = a.options
                }
                defaultVal = a.def
                specialOptionName = a.otherOptionName
            } else {
                throw DataError.jsonError("Combined select one options can't be decoded.")
            }
        } catch {
            selectedObject = -1
            options = [""]
            defaultVal = ""
            specialOptionName = ""
        }
    }
}





struct CombinedSelectOneView_Previews: PreviewProvider {
    static var previews: some View {
        CombinedSelectOneView(encodedOption: "something", index: 0, isSpecialSelected: .constant(false), selectedObject: .constant(-1), options: .constant(["aaa","bbb"]), newA: .constant("new"), defaultVal: .constant("here put answer"), specialOptionName: .constant("Name"))
    }
}
