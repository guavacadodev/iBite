//
//  String+InputView.swift
//  MyApp
//
//  Created by Eslam on 18/06/2024.
//

import Foundation

extension String {
    var inputLocalized: String{
        return NSLocalizedString(self, tableName: "InputViewLocalizable", bundle: Bundle.main, value: "", comment: "")
    }
}

extension String {
    func trimWhiteSpace() -> String {
        let newValue = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return newValue
    }
}
