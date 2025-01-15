//
//  UserDefaultsExtensions.swift
//  iBite
//
//  Created by Eslam on 11/01/2025.
//

import Foundation
extension UserDefaults {
    private enum Keys: String {
        case themeStyle
        case googleMapKey
        case accessToken
        case pushNotificationToken
        case isFirstTime //== isSeenOnBoarding
        case isLogin
        case user
        
        case accountType
        case providerType
        
        case currentLat
        case currentLng
        //case selectedAddress
        case homeAddress
        
        case isEnableNotification
        case favoriteResturants
    }
    
    @ModelsDefault(key: Keys.favoriteResturants.rawValue, defaultValue: [])
    static var favoriteResturants: [Restaurant]
        
}
