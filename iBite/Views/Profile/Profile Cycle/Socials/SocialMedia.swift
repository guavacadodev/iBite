//
//  SocialMedia.swift
//  Start Point
//
//  Created by Eslam on 26/12/2023.
//

import UIKit
import SafariServices

protocol SocialProtocol {
    func openUrl(url:String)
    func openFacebook(userName:String)
    func openSnapchat(screenName:String)
    func openInstagram(username:String)
    func openLinkedIn(username:String)
    func openTwitter(username:String)
    func openWhatsApp(phoneNumber:String)
}

class SocialMedia : SocialProtocol {
    
    static let shared = SocialMedia()
    
    func openSnapchat(screenName:String) {
        let appURL = NSURL(string: "snapchat://add/\(screenName)")!
        let webURL = NSURL(string: "https://www.snapchat.com/add/\(screenName)")!
        
        if UIApplication.shared.canOpenURL(appURL as URL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appURL as URL)
            }
        } else {
            //redirect to safari because the user doesn't have Instagram
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(webURL as URL)
            }
        }
    }
    
    func openFacebook(userName:String){
    let appURL = URL(string: "facebook://user?screen_name=\(userName)")!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL)
        {
            application.open(appURL)
        }
        else
        {
            let webURL = URL(string: "https://www.facebook.com/\(userName)")!
            application.open(webURL)
        }
    }
    
    func openInstagram(username:String) {
        let appURL = NSURL(string: "instagram://user?screen_name=\(username)")!
        let webURL = NSURL(string: "https://instagram.com/\(username)")!
        
        if UIApplication.shared.canOpenURL(appURL as URL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appURL as URL)
            }
        } else {
            //redirect to safari because the user doesn't have Instagram
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(webURL as URL)
            }
        }
    }
    
    func openLinkedIn(username:String) {
        let appURL = URL(string: "linkedin://profile/\(username)/")!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL)
        {
            application.open(appURL)
        }
        else
        {
            let webURL = URL(string: "https://www.linkedin.com/in/\(username)/")!
            application.open(webURL)
        }
    }
    
    func openTwitter(username:String) {
        let appURL = URL(string: "twitter://user?screen_name=\(username)")!
        let webURL = URL(string: "https://twitter.com/\(username)")!
        
        if UIApplication.shared.canOpenURL(appURL as URL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appURL as URL)
            }
        } else {
            //redirect to safari because the user doesn't have Instagram
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(webURL as URL)
            }
        }
    }
    
    func openWhatsApp(phoneNumber:String) {// you need to change this number
        let appURL = URL(string: "https://api.whatsapp.com/send?phone=\(phoneNumber)")!
        if UIApplication.shared.canOpenURL(appURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(appURL)
            }
        }
    }
    
    func openTelegram(phoneNumber:String) {
        let botURL = URL.init(string: "https://t.me/\(phoneNumber)")

        if UIApplication.shared.canOpenURL(botURL!) {
            UIApplication.shared.openURL(botURL!)
        } else {
          // Telegram is not installed.
        }
    }
    
    func openTelegram(url:String) {
        let botURL = URL.init(string: url)

        if UIApplication.shared.canOpenURL(botURL!) {
            UIApplication.shared.openURL(botURL!)
        } else {
          // Telegram is not installed.
        }
    }
    
    func openUrl(url:String) {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        guard let window = window else {return}
        guard let topVC = window.topViewController() else { return }
        
        guard let url = URL(string: url)  else { return }
        let vc = SFSafariViewController(url: url)
        vc.preferredBarTintColor = .white
        vc.preferredControlTintColor = .violet1
        topVC.present(vc, animated: true)
        
    }
    
    func makeCallNumber(phoneNumber:String) {
      if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
        let application:UIApplication = UIApplication.shared
        if (application.canOpenURL(phoneCallURL)) {
            application.open(phoneCallURL, options: [:], completionHandler: nil)
        }
      }
    }
}

extension UIWindow {
//    func topViewController() -> UIViewController? {
//        var top = self.rootViewController
//        while true {
//            if let presented = top?.presentedViewController {
//                top = presented
//            } else if let nav = top as? UINavigationController {
//                top = nav.visibleViewController
//            } else if let tab = top as? UITabBarController {
//                top = tab.selectedViewController
//            } else {
//                break
//            }
//        }
//        return top
//    }
}
