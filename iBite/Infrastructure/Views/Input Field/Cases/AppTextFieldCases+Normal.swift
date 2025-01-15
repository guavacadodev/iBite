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

struct OtpFieldCase: AppNormalFieldProtocol{
    var fieldType: TextFieldType = .otp
}

//MARK: - Provider Cases -
struct StoreArabicNameFieldCase: AppNormalFieldProtocol{
    var fieldType: TextFieldType = .standard(title: "store_name_with_arabic_lang_title", placeholder: "store_name_with_arabic_lang_placeholder", iconName: "storeNameIcon", isSecureTextEntry: false, keyboardType: .default)
}

struct StoreEnglishNameFieldCase: AppNormalFieldProtocol{
    var fieldType: TextFieldType = .standard(title: "store_name_with_english_lang_title", placeholder: "store_name_with_english_lang_placeholder", iconName: "storeNameIcon", isSecureTextEntry: false, keyboardType: .default)
}

struct BankAccountNumberFieldCase: AppNormalFieldProtocol{
    var fieldType: TextFieldType = .bankAccountNumber
}

struct BankNameFieldCase: AppNormalFieldProtocol{
    var fieldType: TextFieldType = .bankName
}

struct IpanNumberFieldCase: AppNormalFieldProtocol{
    var fieldType: TextFieldType = .bankIpanNumber
}

struct CommercialNumberFieldCase: AppNormalFieldProtocol{
    var fieldType: TextFieldType = .commercialNumber
}

struct NationalIDNumberFieldCase: AppNormalFieldProtocol{
    var fieldType: TextFieldType = .nationalIDNumber
}

struct TaxNumberFieldCase: AppNormalFieldProtocol{
    var fieldType: TextFieldType = .taxNumber
}

//MARK: - Provider Add Product -
struct ProductArabicNameFieldCase: AppNormalFieldProtocol{
    var fieldType: TextFieldType = .standard(title: "product_arabic_name_field_title", placeholder: "product_arabic_name_field_Placeholder", iconName: nil, isSecureTextEntry: false, keyboardType: .default)
}

struct ProductEnglishNameFieldCase: AppNormalFieldProtocol{
    var fieldType: TextFieldType = .standard(title: "product_english_name_field_title", placeholder: "product_english_name_field_Placeholder", iconName: nil, isSecureTextEntry: false, keyboardType: .default)
}

struct NumberOfUsageProductFieldCase: AppNormalFieldProtocol{
    var fieldType: TextFieldType = .standard(title: "number_of_usage_product_field_title", placeholder: "number_of_usage_product_field_Placeholder", iconName: nil, isSecureTextEntry: false, keyboardType: .asciiCapableNumberPad)
}

struct QuantityInStockFieldCase: AppNormalFieldProtocol{
    var fieldType: TextFieldType = .standard(title: "quantity_in_stock_field_title", placeholder: "quantity_in_stock_field_Placeholder", iconName: nil, isSecureTextEntry: false, keyboardType: .asciiCapableNumberPad)
}

//MARK: -  Create Announcement -
struct AnnouncementTitleFieldCase: AppNormalFieldProtocol{
    var fieldType: TextFieldType = .standard(title: "announcement_title_field_title", placeholder: "announcement_title_field_Placeholder", iconName: nil, isSecureTextEntry: false, keyboardType: .default)
}

struct PreviewAnnouncementNumberOfDaysFieldCase: AppNormalFieldProtocol{
    var fieldType: TextFieldType = .standard(title: "PreviewAnnouncementNumberOfDays_field_title", placeholder: "PreviewAnnouncementNumberOfDays_field_Placeholder", iconName: nil, isSecureTextEntry: false, keyboardType: .asciiCapableNumberPad)
}
