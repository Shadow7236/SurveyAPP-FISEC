//
//  TagView.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 08/04/2021.
//

import SwiftUI

/// View for showing tags
struct TagView: View {
    @Binding var tags: [TagStruct]
    @Binding var selectedFrom: [TagStruct]
    
    var body: some View {
        if tags.count == 0 {
            HStack {
                Text("No tags added yet") 
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
            }.padding(.top, 1)
        } else {
            ScrollView (.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(tags, id: \.id) { t in
                        HStack {
                            Text(t.name)
                            Divider()
                            Button(action: {
                                if let index = tags.firstIndex(of: t) {
                                    let t = tags.remove(at: index)
                                    selectedFrom.append(t)
                                }
                            }) {
                                Image(systemName: "xmark")
                            }.foregroundColor(.black)
                        }.font(.caption)
                        .frame(width: CGFloat((t.name.count + 3)) * 10, height: 25, alignment: .center)
                        .background(Color.gray.opacity(0.4))
                        .cornerRadius(8)
                    }
                }
            }.frame(alignment: .leading)
        }
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView(tags: .constant([]), selectedFrom: .constant([]))
    }
}
