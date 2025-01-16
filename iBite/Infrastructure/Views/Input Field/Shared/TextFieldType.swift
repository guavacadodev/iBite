//
//  TextFieldType.swift
//  TestingComponents
//
//  Created by Eslam on 06/04/2024.
//

import UIKit


enum TextFieldType {
    //isSecureTextEntry
    //keyboardType
    case standard(title: String?, placeholder: String?, iconName: String?, isSecureTextEntry: Bool, keyboardType: UIKeyboardType)//validate: ValidationError
    case name
    case userName

    case email
 
    case phone
  
    case password
    case confirmPassword
    case newPassword
    case confirmNewPassword
    case currentPassword

    
    // Extend with more types as needed.
    
    var fixedTitle: String? {
        switch self {
        case .standard(let title, _, _, _, _):
            return title
        case .name:
            return "name_field_title"
        case .userName:
            return "user_name_field_title"
        case .email:
            return "email_field_title"
        case .phone:
            return "phone_field_title"
        case .password:
            return "password_field_title"
        case .confirmPassword:
            return "confirm_password_field_title"
        case .newPassword:
            return "new_password_field_title"
        case .confirmNewPassword:
            return "confirm_new_password_field_title"
        case .currentPassword:
            return "current_password_field_title"
      
        }
    }
    
    var fixedPlaceholder: String? {
        switch self {
        case .standard(_, let placeHolder, _, _, _):
            return placeHolder
        case .name:
            return "name_field_placeholder"
        case .userName:
            return "user_name_field_placeholder"
        case .email:
            return "email_field_placeholder"
    
        case .phone:
            return "phone_field_placeholder"
  
        case .password:
            return "password_field_placeholder"
        case .confirmPassword:
            return "confirm_password_field_placeholder"
        case .newPassword:
            return "new_password_field_placeholder"
        case .confirmNewPassword:
            return "confirm_new_password_field_placeholder"
        case .currentPassword:
            return "current_password_field_placeholder"
      
        }
    }
    
    var icon: UIImage?{
        switch self {
        case .standard(_, _, let icon, _, _):
            if let icon = icon {
                return UIImage(named: icon)
            } else {
                return nil
            }
           
        case .name, .userName:
            return UIImage(named: "nameIcon")
        case .email:
            return UIImage(named: "emailIcon")
        case .phone:
            return UIImage(named: "phoneIcon")
        case .password, .confirmPassword, .newPassword, .confirmNewPassword, .currentPassword:
            return UIImage(named: "passwordIcon")
    
        }
    }
  
}

extension TextFieldType{
    var isSecureTextEntry: Bool{
        switch self {
        case .standard(_, _, _, let isSecureTextEntry, _):
            return isSecureTextEntry
        case .name, .userName, .email, .phone:
            return false
        case .password, .confirmPassword, .newPassword, .confirmNewPassword, .currentPassword:
            return true
        }
    }
    
    var keyboardType: UIKeyboardType{
        switch self {
        case .standard(_, _, _, _, let keyboardType):
            return keyboardType
        case .name, .userName:
            return .default
        case .phone:
            return .asciiCapableNumberPad
        case .email:
            return .emailAddress
        case .password, .confirmPassword, .newPassword, .confirmNewPassword, .currentPassword:
            return .asciiCapable
        }
    }
    
    var autoCorrection: UITextAutocorrectionType{
        return .no
    }
    
    var autoCapitalizationType: UITextAutocapitalizationType{
        return .none
    }
}
