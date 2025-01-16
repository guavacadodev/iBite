//
//  AppTextFieldCases+Normal.swift
//  Dream Closet
//
//  Created by Eslam on 17/09/2024.
//

import Foundation

struct DefaultNormalFieldCase: AppNormalFieldProtocol {
    var isLeadingImage: Bool = true
    var fieldType: TextFieldType = .standard(title: nil, placeholder: nil, iconName: nil, isSecureTextEntry: false, keyboardType: .default)
}

struct UserNameFieldCase: AppNormalFieldProtocol{
    var fieldType: TextFieldType = .userName
}

struct BirthdayFieldCase: AppNormalFieldProtocol{
    var fieldType: TextFieldType = .standard(title: "Birthday", placeholder: "Enter Your Birthday", iconName: nil, isSecureTextEntry: false, keyboardType: .asciiCapableNumberPad)
}


struct NameFieldCase: AppNormalFieldProtocol{
    var fieldType: TextFieldType = .name
}

struct EmailFieldCase: AppNormalFieldProtocol{
    var fieldType: TextFieldType = .email
}

struct PasswordFieldCase: AppNormalFieldProtocol{
    var fieldType: TextFieldType = .password
}

struct CurrentPasswordFieldCase: AppNormalFieldProtocol{
    var fieldType: TextFieldType = .currentPassword
}

struct ConfirmPasswordFieldCase: AppNormalFieldProtocol{
    var fieldType: TextFieldType = .confirmPassword
}

struct NewPasswordFieldCase: AppNormalFieldProtocol{
    var fieldType: TextFieldType = .newPassword
}

struct ConfirmNewPasswordFieldCase: AppNormalFieldProtocol{
    var fieldType: TextFieldType = .confirmNewPassword
}

