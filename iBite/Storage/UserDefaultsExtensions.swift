//
//  UserDefaultsExtensions.swift
//  iBite
//
//  Created by Eslam on 11/01/2025.
//

import Foundation
extension UserDefaults {
    private enum Keys: String {
        case favoriteResturants
    }
    
    @ModelsDefault(key: Keys.favoriteResturants.rawValue, defaultValue: [])
    static var favoriteResturants: [Restaurant]
        
}
