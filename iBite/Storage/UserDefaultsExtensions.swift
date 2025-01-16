//
//  UserDefaultsExtensions.swift
//  iBite
//
//  Created by Eslam on 11/01/2025.
//

import Foundation
extension UserDefaults {
    private enum Keys: String {
        case user
        case favoriteResturants
    }
    
    @ModelsDefault(key: Keys.user.rawValue, defaultValue: nil)
    static var user: UserModel?
    
    @ModelsDefault(key: Keys.favoriteResturants.rawValue, defaultValue: [])
    static var favoriteResturants: [Restaurant]
        
}
