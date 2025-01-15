//
//  AppTextFieldProtocol.swift
//  Dream Closet
//
//  Created by Eslam on 23/07/2024.
//
import UIKit

protocol BottomSheetData {
    
}

//MARK: - protocol for selectedData -
protocol SelectedDataFieldProtocol{
    var selectedData: [BottomSheetData]? {get set}
}

struct SelectedDataFieldCase: SelectedDataFieldProtocol{
    var selectedData: [BottomSheetData]?
}

//MARK: - protocol for Input Field cases (any view) -
/// normal
protocol AppInputFieldProtocol {
    var isActive: Bool { get }
    var isBordered: Bool { get }
    var isLeadingImage: Bool { get }
    var isMandatory: Bool { get }
    var isOptional: Bool { get }
    var fieldType: TextFieldType { get }
}

extension AppInputFieldProtocol{
    var isActive: Bool {return true}
    var isBordered: Bool {return false}
    var isLeadingImage: Bool {return true}
    var isMandatory: Bool {return true}
    var isOptional: Bool {return false}
}

protocol AppNormalFieldProtocol: AppInputFieldProtocol {}

/// phone
protocol AppPhoneFieldProtocol: AppInputFieldProtocol {
    var hasChevron: Bool { get }
    var hasDividerLine: Bool { get }
    var hasDefaultValue: Bool { get }
    //var selectedCountryCode: BottomSheetData? { get set }
}
extension AppPhoneFieldProtocol {
    var hasChevron: Bool { return true }
    var hasDividerLine: Bool { return true }
    var hasDefaultValue: Bool { return false }
}


/// Selection
//protocol AppSelectionFieldProtocol: AppInputFieldProtocol {
//    var selectedData: [BottomSheetData]?  { get set }
//}
//
///// picker
//protocol AppPickerFieldProtocol: AppInputFieldProtocol {
//    //func dateValue() -> Date?
//    var pickerType: PickerView.PickerType { get }
//    var isOlderAvailable: Bool { get }
//}

/// for next project
protocol AppTextFieldProtocol {
    var isActive: Bool { get set }
    var isBordered: Bool { get set }
    var hasIcon: Bool { get set }
    var isMandatory: Bool { get set }
    var isOptional: Bool { get }
    var leadingImage: UIImage { get set }
    var trailingImage: UIImage { get set }
    var fieldType: TextFieldType { get set }
}
