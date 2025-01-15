//
//  AppTextFieldCases+Phone.swift
//  Dream Closet
//
//  Created by Eslam on 17/09/2024.
//

import Foundation
struct PhoneFieldCase: AppPhoneFieldProtocol{
    //var selectedCountryCode: BottomSheetData?
    var fieldType: TextFieldType = .phone
}

struct PhonePreviewFieldCase: AppPhoneFieldProtocol{
    //var selectedCountryCode: BottomSheetData?
    var isActive: Bool = false
    var isBordered: Bool = false
    var fieldType: TextFieldType = .phone
}

struct NewPhoneFieldCase: AppPhoneFieldProtocol{
   // var selectedCountryCode: BottomSheetData?
    var fieldType: TextFieldType = .newPhone
}
