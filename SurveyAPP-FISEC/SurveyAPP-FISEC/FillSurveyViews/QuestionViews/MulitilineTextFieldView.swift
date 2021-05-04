//
//  MulitilineTextFieldView.swift
//  SurveyAPP-FISEC
//
//  Created by Kavsoft
//  Taken from https://www.youtube.com/watch?v=j-hoWW0eCHw
//
//  [Edited by Radovan Klembara (2021)]
//

import SwiftUI

/// View for multiline text field
struct MultiLineTF: UIViewRepresentable {
    @Binding var txt: String
    var placeholder: String
    
    init(txt: Binding<String>, placeholder: String) {
        self._txt = txt
        self.placeholder = placeholder
    }
    
    /// Creates coordinator
    /// - Returns: coordinator
    func makeCoordinator() -> MultiLineTF.Coordinator {
        return MultiLineTF.Coordinator(parent1: self, plc: placeholder)
    }
    
    /// Makes view
    /// - Parameter context: reresents context
    /// - Returns: view
    func makeUIView(context: UIViewRepresentableContext<MultiLineTF>) -> UITextView {
        let tview = UITextView()
        tview.isEditable = true
        tview.isUserInteractionEnabled = true
        tview.isScrollEnabled = true
        if (txt.isEmpty) {
            tview.text = placeholder
            tview.textColor = .gray
        } else {
            tview.text = txt
            tview.textColor = .label
        }
        tview.font = .systemFont(ofSize: 20)
        tview.delegate = context.coordinator
        return tview
    }
    
    /// Updates view
    /// - Parameters:
    ///   - uiView: represents view
    ///   - context: represents context
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<MultiLineTF>) {
        
    }
    
    /// View coordinator
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: MultiLineTF
        var plc: String
        var placeholderOverwritten: Bool
        
        init(parent1: MultiLineTF, plc: String){
            parent = parent1
            self.plc = plc
            placeholderOverwritten = !parent.txt.isEmpty
        }
        
        /// Defines what should be done after view changed
        /// - Parameter textView: represents text view
        func textViewDidChange(_ textView: UITextView) {
            parent.txt = textView.text
            if textView.text.isEmpty {
                placeholderOverwritten = false
                textView.text = plc
                textView.textColor = .gray
            } else {
                placeholderOverwritten = true
                textView.textColor = .label
            }
        }
        
        /// Defines what should be done after begin of editing text view
        /// - Parameter textView: represents text view
        func textViewDidBeginEditing(_ textView: UITextView)  {
            guard !placeholderOverwritten else { return }
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
