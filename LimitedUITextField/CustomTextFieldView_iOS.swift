//
//  CustomTextFieldView_iOS.swift
//  LimitedUITextField
//
//  Created by Javier Solorzano on 8/6/25.
//

import SwiftUI
import UIKit

struct CustomTextFieldView: UIViewRepresentable {
    typealias UIViewType = UITextField
    
    @Binding var text: String
    var characterLimit: UInt
    
    init(text: Binding<String>, characterLimit: UInt) {
        _text = text
        self.characterLimit = characterLimit
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.placeholder = "UIKit Limited TextField"
        textField.textAlignment = .left
        textField.delegate = context.coordinator
        return textField
    }
    
    /* START - SwiftUI Bridge Layer */
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text // Update SwiftUI text binding
    }
    
    func makeCoordinator() -> Coordinator {
        // Set the coordinator to handle text field delegate events
        return Coordinator(text: $text, maxLength: characterLimit)
    }
    /* END - SwiftUI Bridge Layer */

    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        let MAX_LENGTH: UInt
        
        init(text: Binding<String>, maxLength: UInt) {
            _text = text
            self.MAX_LENGTH = maxLength
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)

            return newString.count <= MAX_LENGTH
        }
    }
}
