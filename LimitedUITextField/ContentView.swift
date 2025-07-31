//
//  ContentView.swift
//  LimitedUITextField
//
//  Created by Javier Solorzano on 7/31/25.
//

import SwiftUI

struct ContentView: View {
    @State private var text: String = ""
    @State private var limitedText: String = ""
    var body: some View {
        VStack {
            TextField("Name TextField", text: $text, prompt: Text("TextField"))
                .onChange(of: text) { oldValue, newValue in
                    if newValue.count > 10 {
                        text = String(newValue.prefix(10))
                    }
                }
            LimitedTextField(title: "LimitedTextField", limit: 10, text: $limitedText)
            
        }
        .padding()
    }
}

struct LimitedTextField: View {
    var title: String
    var textLimit: UInt
    @Binding public var text: String
    
    init(title: String, limit: UInt, text: Binding<String>) {
        self.title = title
        self.textLimit = limit
        _text = text
    }
    
    var body: some View {
        HStack(spacing: 0) {
            CustomTextFieldView(text: $text, characterLimit: textLimit)
        }
    }
}

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
        textField.placeholder = "CustomTextField"
        textField.textAlignment = .left
        textField.delegate = context.coordinator
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, maxLength: characterLimit)
    }
    
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


#Preview {
    ContentView()
}
