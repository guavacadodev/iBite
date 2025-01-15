//
//  PhoneTextFieldSwiftUI.swift
//  3NK
//
//  Created by Eslam on 02/01/2025.
//

import SwiftUI

protocol PhoneTextFieldSwiftUIDelegate: AnyObject {
    func onClickCountryCode()
}

struct PhoneTextFieldSwiftUI: View {
    weak var delegate: PhoneTextFieldSwiftUIDelegate?
    var type: AppPhoneFieldProtocol
    @Binding var textValue: String// = ""
//    init(type: AppPhoneFieldProtocol, delegate: PhoneTextFieldSwiftUIDelegate?) {
//        self.type = type
//        self.delegate = delegate
//    }
    var body: some View {
        PhoneTFSwiftUI(bodyTextField: $textValue, type: type)
            .background(Color.clear)
    }
}

//#Preview {
//    PhoneTextFieldSwiftUI(type: PhoneFieldCase(), delegate: nil, textValue: <#Binding<String>#>)
//}

struct PhoneTFSwiftUI: View {
    weak var delegate: PhoneTextFieldSwiftUIDelegate?
    @Binding var bodyTextField: String// = ""
    @State var countryCodeValue: String = "--"
    @State var countryFlagValue: String = "logo"
    var type: AppPhoneFieldProtocol
    //@State var tintColor: Color = .main.opacity(0.4)
    //@State var isFieldEmpty: Bool = true
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
                .font(.system(size: 14, weight: .regular))
            }
            HStack {
                AppTextFieldIconSwiftUI(iconField: type.fieldType.icon)
                AppTextFieldSwiftUI(bodyTextField: $bodyTextField, placeholderField: type.fieldType.fixedPlaceholder?.inputLocalized, keyboardType: type.fieldType.keyboardType)
                countryCodeView
                
            }
            .padding()
            
            //MARK: - to Make border without hidden in four corners -
            .overlay(
                RoundedRectangle(cornerRadius: InputFieldConstants.fieldCornerRaduis)
                    .stroke(isFieldEmpty() ? .clear : .purple1, lineWidth: 1)
            )
            .background(Color(InputFieldConstants.containerBackground))
            .cornerRadius(4)
        }
        .background(Color.clear)
    }
    
    var countryCodeView: some View {
        HStack {
            Image(systemName: SFSymbol.expand.rawValue)
                .foregroundStyle(Color(UIColor.placeholderText))
            Text(countryCodeValue)
                .foregroundStyle(Color(UIColor.placeholderText))
            Image(countryFlagValue)
                .resizable()
                .frame(width: 30, height: 30)
        }
        .onTapGesture {
            self.delegate?.onClickCountryCode()
        }
    }
    
    func isFieldEmpty() -> Bool{
        if bodyTextField.count == 0{
            return true
        }
        return false
    }
}
