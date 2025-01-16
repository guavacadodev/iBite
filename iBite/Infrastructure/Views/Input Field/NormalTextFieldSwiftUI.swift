//
//  NormalTextFieldSwiftUI.swift
//  3NK
//
//  Created by Eslam on 02/01/2025.
//

import SwiftUI

struct SecureFieldViewSwiftUI: View {
    var type: AppNormalFieldProtocol
    @Binding var textValue: String
    @Binding var isSecure: Bool
    var isSecureField: Bool = true

    var body: some View {
        NormalTFSwiftUI(bodyTextField: $textValue, isSecureField: isSecureField, isSecure: $isSecure, type: type)
            .background(Color.clear)
    }
}

struct NormalTextFieldSwiftUI: View {
    var type: AppNormalFieldProtocol
    @Binding var textValue: String
    var isSecureField: Bool = false
    @State var isSecure: Bool = false

    var body: some View {
        NormalTFSwiftUI(bodyTextField: $textValue, isSecureField: isSecureField, isSecure: $isSecure, type: type)
            .background(Color.clear)
    }
}


struct NormalTFSwiftUI: View {
    @Binding var bodyTextField: String
    var isSecureField: Bool
    @Binding var isSecure: Bool
    
    var type: AppNormalFieldProtocol
    var body: some View {
        VStack(alignment: .leading, spacing: InputFieldConstants.fieldSapcing) {
            Group {
                HStack(spacing: 4){
                    if let titleText = type.fieldType.fixedTitle, !titleText.trimWhiteSpace().isEmpty {
                        Text(titleText.inputLocalized)
                            .foregroundColor(Color.whiteNeutral)
                    }
                    if type.isMandatory {
                        Text("*")
                            .foregroundStyle(.red)
                    }
                    
                    if type.isOptional {
                        Text("(Optional)")
                            .foregroundStyle(Color(UIColor.placeholderText))
                    }
                    Spacer()
                }
            }
           
            HStack {
                AppTextFieldIconSwiftUI(iconField: type.fieldType.icon)
                if isSecureField {
                    AppSecureFieldSwiftUI(bodyTextField: $bodyTextField, isSecure: $isSecure, placeholderField: type.fieldType.fixedPlaceholder?.inputLocalized, isSecureField: isSecureField, keyboardType: type.fieldType.keyboardType)

                } else {
                    AppTextFieldSwiftUI(bodyTextField: $bodyTextField, placeholderField: type.fieldType.fixedPlaceholder?.inputLocalized, keyboardType: type.fieldType.keyboardType)
                }
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: InputFieldConstants.fieldCornerRaduis)
                    .stroke(isFieldEmpty() ? .clear : .purple1, lineWidth: 1)
                
            )
            .background(Color(InputFieldConstants.containerBackground))
            .cornerRadius(4)
        }
        .background(Color.clear)
    }
    
    func isFieldEmpty() -> Bool{
        if bodyTextField.count == 0{
            return true
        }
        return false
    }
}
