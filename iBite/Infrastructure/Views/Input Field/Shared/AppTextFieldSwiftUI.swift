//
//  AppTextFieldSwiftUI.swift
//  3NK
//
//  Created by Eslam on 06/01/2025.
//

import SwiftUI

struct AppTextFieldSwiftUI: View {
    @Binding var bodyTextField: String
    var placeholderField: String?
    var keyboardType: UIKeyboardType
    var isEnable: Bool = true
    var body: some View {
        TextField(placeholderField ?? "placeholder", text: $bodyTextField)
            .keyboardType(keyboardType)
            .autocorrectionDisabled(false)
            .foregroundStyle(Color(UIColor.label))
            .disabled(!isEnable)
    }
}


struct AppSecureFieldSwiftUI: View {
    @Binding var bodyTextField: String
    @Binding var isSecure: Bool
    var placeholderField: String?
    var isSecureField: Bool = false
    var keyboardType: UIKeyboardType = .default
    var isEnable: Bool = true
    var body: some View {
      
        HStack {
            if isSecureField {
                Button(action: {
                    isSecure.toggle()
                }) {
                    Image(systemName: isSecure ? "eye.slash.fill" : "eye.fill")
                        .foregroundStyle(Color(UIColor.placeholderText))
                }
            }
            
            if isSecure {
                SecureField(placeholderField ?? "placeholder", text: $bodyTextField)
                    .textFieldStyle(PlainTextFieldStyle())
            } else {
                TextField(placeholderField ?? "placeholder", text: $bodyTextField)
                    .keyboardType(keyboardType)
                    .autocorrectionDisabled(false)
                    .foregroundStyle(Color(UIColor.label))
                    .disabled(!isEnable)
            }
        }
    }
}

//MARK: - Modifier -
struct PasswordToggleModifier: ViewModifier {
    @Binding var text: String
    @State private var isSecure: Bool = true
    @FocusState private var isFocused: Bool
    
    func body(content: Content) -> some View {
        HStack {
            if isSecure {
                SecureField("Password", text: $text)
                    .focused($isFocused)
                    .textFieldStyle(PlainTextFieldStyle())
            } else {
                TextField("Password", text: $text)
                    .font(.system(size: 14, weight: .regular))
                    .focused($isFocused)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            
            Button(action: {
                isSecure.toggle()
                isFocused = true
            }) {
                Image(systemName: isSecure ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}


extension View {
    func passwordToggle(text: Binding<String>) -> some View {
        self.modifier(PasswordToggleModifier(text: text))
    }
}
