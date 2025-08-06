//
//  CustomTextFieldView_macOS.swift
//  LimitedUITextField
//
//  Created by Javier Solorzano on 8/6/25.
//

import AppKit
import SwiftUI

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
