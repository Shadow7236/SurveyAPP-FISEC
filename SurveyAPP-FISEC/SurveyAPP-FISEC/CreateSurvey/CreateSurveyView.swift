//
//  CreateSurveyView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 17/02/2021.
//

import SwiftUI


struct CreateSurveyView: View {
    @State private var name = ""
    @State private var description = ""
    
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
                            Button(action: {}){
                                HStack {
                                    Text("Add")
                                    Image(systemName: "plus")
                                        .padding(3)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                                }
                            }.buttonStyle(BorderlessButtonStyle())
                        }
                        ScrollView (.horizontal, showsIndicators: false) {
                             HStack {
                                HStack {
                                    Text("Tag1")
                                    Divider()
                                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                                        Image(systemName: "xmark")
                                    }.foregroundColor(.black)
                                }.font(.caption)
                                .frame(width: (4 + 3) * 10, height: 25, alignment: .center)
                                .background(Color.gray.opacity(0.4))
                                .cornerRadius(8)
                                
                                HStack {
                                    Text("Tag1")
                                    Divider()
                                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                                        Image(systemName: "xmark")
                                    }.foregroundColor(.black)
                                }.font(.caption)
                                .frame(width: (4 + 3) * 10, height: 25, alignment: .center)
                                .background(Color.gray.opacity(0.4))
                                .cornerRadius(8)
                                
                                HStack {
                                    Text("Tag1")
                                    Divider()
                                    Button(action: {}) {
                                        Image(systemName: "xmark")
                                    }.foregroundColor(.black)
                                }.font(.caption)
                                .frame(width: (4 + 3) * 10, height: 25, alignment: .center)
                                .background(Color.gray.opacity(0.4))
                                .cornerRadius(8)
                                
                                HStack {
                                    Text("Tag1")
                                    Divider()
                                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                                        Image(systemName: "xmark")
                                    }.foregroundColor(.black)
                                }.font(.caption)
                                .frame(width: (4 + 3) * 10, height: 25, alignment: .center)
                                .background(Color.gray.opacity(0.4))
                                .cornerRadius(8)
                                
                                HStack {
                                    Text("Tag1")
                                    Divider()
                                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                                        Image(systemName: "xmark")
                                    }.foregroundColor(.black)
                                }.font(.caption)
                                .frame(width: (4 + 3) * 10, height: 25, alignment: .center)
                                .background(Color.gray.opacity(0.4))
                                .cornerRadius(8)
                             }
                        }.frame(alignment: .leading)
                    }
                    VStack {
                        HStack {
                            Text("Description:")
                            Spacer()
                        }
                        TextEditor(text: $description)
                    }
                    Text("Number of questions: 0")
                }
                Section {
                    NavigationLink(destination: CreateQuestionView()){
                        Text("Add question")
                    } .frame(alignment: .center)
                    .foregroundColor(.blue)
                    
                }
                Section {
                    List {
                        NavigationLink(destination: Text("QUESTION")){
                            QuestionPreviewView()
                        }
                        NavigationLink(destination: Text("QUESTION")){
                            QuestionPreviewView()
                        }
                    }
                }
                Section {
                    Button(action: {}) {
                        Text("Save and open survey")
                            .font(.headline)
                    }
                }
                Section {
                    Button(action: {}) {
                        Text("Reset")
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                }
            }.navigationBarItems(leading: HStack {
                Text("400")
                Image(systemName: "circlebadge.2.fill")
                }.foregroundColor(.blue))
            .navigationBarTitle("Create survey", displayMode: .inline)
            
            Spacer()
        }
    }
}

struct CreateSurveyView_Previews: PreviewProvider {
    static var previews: some View {
        CreateSurveyView().previewDevice("iPhone 12")
    }
}
