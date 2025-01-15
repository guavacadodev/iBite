//
//  socialMedia.swift
//  iBite
//
//  Created by Eslam on 15/01/2025.
//

import Foundation
enum socialAccounts: String, CaseIterable {
    case phone = "Phone"
    case email = "Email"
    case facebook = "Facebook"
    case google = "Google"
    case xLogo = "X"

    var iconName: String {
        switch self {
        case .phone: return "sadpurplemonster" // Replace with your phone icon asset name
        case .email: return "sadpurplemonster" // Replace with your email icon asset name
        case .facebook: return "sadpurplemonster" // Replace with your Facebook icon asset name
        case .google: return "sadpurplemonster" // Replace with your Google icon asset name
        case .xLogo: return "sadpurplemonster" // Replace with your X logo asset name
        }
    }
    
    
    func itemTapped(){
        switch self {
        case .phone:
            phoneCall()
        case .email:
            sendEmail()
        case .facebook:
            facebookLink()
        case .google:
            googleLink()
        case .xLogo:
            twitterLink()
        }
    }

    func phoneCall(){
        SocialMedia.shared.makeCallNumber(phoneNumber: "+201003189674")
    }
    
    func sendEmail(){
        Emailer().sendMail(body: "email", recipients: ["recipients"])
    }
    
    func facebookLink() {
        SocialMedia.shared.openFacebook(userName: "eslam")
    }
    
    func googleLink() {
        SocialMedia.shared.openUrl(url: "https://www.google.com")
    }
    
    func twitterLink() {
        SocialMedia.shared.openTwitter(username: "eslam")
    }
}
