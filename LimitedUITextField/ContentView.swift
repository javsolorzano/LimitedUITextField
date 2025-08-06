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

#Preview {
    ContentView()
}
