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
            TextField("SwiftUI Limited TextField", text: $text, prompt: Text("SwiftUI Limited TextField"))
                .onChange(of: text) { oldValue, newValue in
                    /// This *works* but users can replace the text at the beginning and it will truncate the text at the end
                    if newValue.count > 10 {
                        text = String(newValue.prefix(10))
                    }
                }
                
            LimitedTextField(title: "Limited TextField", limit: 10, text: $limitedText)
            
        }
        .padding()
    }
}

#if os(iOS)
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
#else
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

struct CustomTextFieldView: NSViewRepresentable {
    typealias NSViewType = NSTextField
    
    @Binding var text: String
    var characterLimit: UInt
    
    init(text: Binding<String>, characterLimit: UInt) {
        _text = text
        self.characterLimit = characterLimit
    }
    
    func makeNSView(context: Context) -> NSTextField {
        let textField = NSTextField()
        textField.formatter = CustomTextFieldFormatter(maxLength: characterLimit)
        textField.focusRingType = .none
        textField.isBordered = false
        textField.backgroundColor = .clear
        textField.alignment = .left
        textField.delegate = context.coordinator
        textField.placeholderString = "AppKit Limited TextField"
        return textField
    }
    
    func updateNSView(_ nsView: NSTextField, context: Context) {
        nsView.stringValue = text
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    class Coordinator: NSObject, NSTextFieldDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func controlTextDidChange(_ obj: Notification) {
            self.text = (obj.object as! NSTextField).stringValue
        }
    }
    
    class CustomTextFieldFormatter: Formatter {
        var maxLength: UInt
        
        init(maxLength: UInt) {
            self.maxLength = maxLength
            super.init()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func string(for obj: Any?) -> String? {
            return obj as? String
        }
        
        override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
                                     for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
            obj?.pointee = string as AnyObject
            return true
        }
        
        override func isPartialStringValid(_ partialStringPtr: AutoreleasingUnsafeMutablePointer<NSString>,
                                           proposedSelectedRange proposedSelRangePtr: NSRangePointer?,
                                           originalString origString: String,
                                           originalSelectedRange origSelRange: NSRange,
                                           errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
            
            if partialStringPtr.pointee.length > maxLength {
                return false
            }
            return true
        }
        
        override func attributedString(for obj: Any, withDefaultAttributes attrs: [NSAttributedString.Key : Any]? = nil) -> NSAttributedString? {
            return nil
        }
    }
}

#endif

#Preview {
    ContentView()
}
