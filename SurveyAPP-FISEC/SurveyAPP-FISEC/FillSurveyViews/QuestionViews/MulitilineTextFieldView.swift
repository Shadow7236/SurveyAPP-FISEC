//
//  MulitilineTextFieldView.swift
//  SurveyAPP-FISEC
//
//  Created by Kavsoft
//  Taken from https://www.youtube.com/watch?v=j-hoWW0eCHw
//

import SwiftUI

struct MultiLineTF: UIViewRepresentable {
    @Binding var txt: String
    var placeholder: String
    
    func makeCoordinator() -> MultiLineTF.Coordinator {
        return MultiLineTF.Coordinator(parent1: self, plc: placeholder)
    }
    
    func makeUIView(context: UIViewRepresentableContext<MultiLineTF>) -> UITextView {
        let tview = UITextView()
        tview.isEditable = true
        tview.isUserInteractionEnabled = true
        tview.isScrollEnabled = true
        tview.text = placeholder
        tview.textColor = .gray
        tview.font = .systemFont(ofSize: 20)
        tview.delegate = context.coordinator
        return tview
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<MultiLineTF>) {
        
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: MultiLineTF
        var plc: String
        
        init(parent1: MultiLineTF, plc: String){
            parent = parent1
            self.plc = plc
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.parent.txt = textView.text
        }
        
        func textViewDidBeginEditing(_ textView: UITextView)  {
            textView.text = ""
            textView.textColor = .label
        }
    }
}

struct MulitilineTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        MultiLineTF(txt: .constant(""), placeholder: "")
    }
}
