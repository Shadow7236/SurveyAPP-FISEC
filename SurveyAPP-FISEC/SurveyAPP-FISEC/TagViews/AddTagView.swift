//
//  AddTagView.swift
//  SurveyAPP-FISEC
//


import SwiftUI

/// View for adding tags
struct AddTagView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var text: String = ""
    @Binding var tags: [TagStruct]
    
    @Binding var newTags: [TagStruct]
    
    @State private var isEditing = false

    @State var errMsg = "Unexpected error."
    @State var showAlert = false
    @StateObject
    var tagModel = TagModel()
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                        newTags = []
                        presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                }
                Spacer()
                Button(action: {presentationMode.wrappedValue.dismiss()}) {
                    Text("Save")
                }
            }.padding()
            /// Created by Simon Ng
            /// Taken from https://www.appcoda.com/swiftui-search-bar/
            VStack {
                TextField("Search tags:", text: $text)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                            if isEditing {
                                Button(action: {
                                    self.text = ""
                                }) {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                    )
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        self.isEditing = true
                    }
            }
            TagView(tags: $newTags, selectedFrom: $tags).padding()
            List(tags.filter({ text.isEmpty ? true : $0.name.contains(text) }), id: \.id){ t in
                HStack {
                    Text(t.name)
                    Spacer()
                    Image(systemName: "plus")
                        .foregroundColor(.blue)
                }.onTapGesture(perform: {
                    if !newTags.contains(t) {
                        newTags.append(t)
                        if let index = tags.firstIndex(of: t) {
                            tags.remove(at: index)
                        }
                    }
                })
            }
        }.onAppear(perform: {
            loadData()
        })
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Error:"), message: Text(errMsg), dismissButton: .default(Text("Ok")))
        })
    }
    
    
    /// Loads tags 
    func loadData() {
        if tags.isEmpty {
            let group = DispatchGroup()
            group.enter()
            tagModel.loadAll(g: group)
            group.notify(queue: DispatchQueue.main){
                if let e = tagModel.error {
                    errMsg = e.description
                    showAlert = true
                } else {
                    tags = tagModel.tags ?? []
                }
            }
        }
    }

}

struct AddTagView_Previews: PreviewProvider {
    static var previews: some View {
        AddTagView(tags: .constant([]), newTags: .constant([]))
    }
}
