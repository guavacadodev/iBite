//
//  PhoneCaller.swift
//
//  Created by MGAbouarab®
//


import UIKit
/*
 let phone: String = "+201061085541"
 let message: String = "Hello"
 let encodedMessage = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
 let urlWhats = "whatsapp://send?phone=\(phone)&text=\(encodedMessage)"

 if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
    let whatsappURL = URL(string: urlString) {
     
     if UIApplication.shared.canOpenURL(whatsappURL) {
         if #available(iOS 10.0, *) {
             UIApplication.shared.open(whatsappURL, options: [:]) { success in
                 if !success {
                     SnackView.snackPopup(msg: "Failed to open WhatsApp")
                 }
             }
         } else {
             UIApplication.shared.openURL(whatsappURL)
         }
     } else {
         SnackView.snackPopup(msg: "Install WhatsApp")
     }
 }
 */

class PhoneAction: NSObject {
//    class func call(number: String?) {
//        guard let stringNumber = number, let number = URL(string: "tel://" + stringNumber) else { return }
//        UIApplication.shared.open(number)
//    }
    
 
//    class func call(number: String?) {
//        if let url = NSURL(string: "TEL://" + (number ?? "+966123456789"))
//            , UIApplication.shared.canOpenURL(url as URL)
//            , !number!.isBlank{
//            print("url\(url)")
//            if #available(iOS 10, *) {
//                UIApplication.shared.open(url as URL)
//            } else {
//                UIApplication.shared.openURL(url as URL)
//            }
//        } else {
//            let url = NSURL(string: "TEL://+966123456789")
//            if #available(iOS 10, *) {
//                UIApplication.shared.open(url! as URL)
//            } else {
//                UIApplication.shared.openURL(url! as URL)
//            }
//        }
//    }
    
    class func call(number: String?) {
        let phoneNumber = number ?? "+966123456789"
        
        if let url = NSURL(string: "TEL://" + phoneNumber),
            UIApplication.shared.canOpenURL(url as URL),
            !phoneNumber.isEmpty {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url as URL) { success in
                    if !success {
                     //   AppAlert.showErrorAlert(error: "\("PleaseCallThisNumber".localized) \("+966123456789")")
                    }
                }
            } else {
                let success = UIApplication.shared.openURL(url as URL)
                if !success {
                   // AppAlert.showErrorAlert(error: "\("PleaseCallThisNumber".localized) \("+966123456789")")
                }
            }
        } else {
            let url = NSURL(string: "TEL://+966123456789")
            if #available(iOS 10, *) {
                UIApplication.shared.open(url! as URL) { success in
                    if !success {
                      //  AppAlert.showErrorAlert(error: "\("PleaseCallThisNumber".localized) \("+966123456789")")
                    }
                }
            } else {
                let success = UIApplication.shared.openURL(url! as URL)
                if !success {
                   // AppAlert.showErrorAlert(error: "\("PleaseCallThisNumber".localized) \("+966123456789")")
                }
            }
        }
    }

  
    class func open(whatsApp: String) {
        let appURL = URL(string: "https://wa.me/\(whatsApp)")!
        if UIApplication.shared.canOpenURL(appURL) {
            // TikTok app is installed, open it directly
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else {
            // TikTok app is not installed, open App Store page for TikTok
            if let appStoreURL = URL(string: "https://apps.apple.com/us/app/whatsapp-messenger/id310633997") {
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
            }
        }
    }
    
//    class func openTikTok() {
//        let tiktokURL = URL(string: "tiktok://")!
//        let safariURL = URL(string: "https://www.tiktok.com/")!
//        
//        if UIApplication.shared.canOpenURL(tiktokURL) {
//            UIApplication.shared.open(tiktokURL, options: [:], completionHandler: nil)
//        } else {
//            // TikTok app is not installed, open TikTok website in Safari
//            UIApplication.shared.open(safariURL, options: [:], completionHandler: nil)
//        }
//    }
    
    class func openTikTok(link tiktokLink: String) {
        let tiktokURL = URL(string: "tiktok://\(tiktokLink)")!
        
        if UIApplication.shared.canOpenURL(tiktokURL) {
            // TikTok app is installed, open it directly
            UIApplication.shared.open(tiktokURL, options: [:], completionHandler: nil)
        } else {
            // TikTok app is not installed, open App Store page for TikTok
            if let appStoreURL = URL(string: "https://apps.apple.com/us/app/tiktok/id835599320") {
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
            }
        }
    }

    
    //    class func openInstagram() {
    //        let instagramURL = URL(string: "instagram://app")!
    //        let safariURL = URL(string: "https://www.instagram.com/")!
    //
    //        if UIApplication.shared.canOpenURL(instagramURL) {
    //            UIApplication.shared.open(instagramURL, options: [:], completionHandler: nil)
    //        } else {
    //            // Instagram app is not installed, open Instagram website in Safari
    //            UIApplication.shared.open(safariURL, options: [:], completionHandler: nil)
    //        }
    //    }
    
//    class func openInstagram(instagramHandle: String) {
//        //link instaLink: String
//        let instagramURL = URL(string: "instagram://user?username=\(instagramHandle)")! // Replace USERNAME with the Instagram username you want to open
//        
//        if UIApplication.shared.canOpenURL(instagramURL) {
//            // Instagram app is installed, open it directly
//            UIApplication.shared.open(instagramURL, options: [:], completionHandler: nil)
//        } else {
//            // Instagram app is not installed, open App Store page for Instagram
//            if let appStoreURL = URL(string: "https://apps.apple.com/us/app/instagram/id389801252") {
//                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
//            }
//        }
//    }
    class func openInstagram(instagramHandle: String) {
      //  let instagram = URL(string: "instagram://")!
        let instagramAppURL = URL(string: "instagram://\(instagramHandle)")!
        if UIApplication.shared.canOpenURL(instagramAppURL) {
            UIApplication.shared.open(instagramAppURL, options: [:], completionHandler: nil)
        } else {
            let instagramAppStoreID = "389801252"
            if let appStoreURL = URL(string: "https://apps.apple.com/us/app/instagram/id\(instagramAppStoreID)") {
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
            }
        }
    }
    

    
//    class func openTwitter() {
//        let twitterURL = URL(string: "twitter://")!
//        let safariURL = URL(string: "https://twitter.com/")!
//        
//        if UIApplication.shared.canOpenURL(twitterURL) {
//            UIApplication.shared.open(twitterURL, options: [:], completionHandler: nil)
//        } else {
//            // Twitter app is not installed, open Twitter website in Safari
//            UIApplication.shared.open(safariURL, options: [:], completionHandler: nil)
//        }
//    }
    
    class func openTwitter(link: String) {
        let twitterURL = URL(string: "twitter://\(link)")!
        if UIApplication.shared.canOpenURL(twitterURL) {
            UIApplication.shared.open(twitterURL, options: [:], completionHandler: nil)
        } else {
            if let appStoreURL = URL(string: "https://apps.apple.com/us/app/twitter/id333903271") {
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
            }
        }
    }

    
//    class func openSnapchat() {
//        let snapchatURL = URL(string: "snapchat://")!
//        let safariURL = URL(string: "https://www.snapchat.com/")!
//        
//        if UIApplication.shared.canOpenURL(snapchatURL) {
//            UIApplication.shared.open(snapchatURL, options: [:], completionHandler: nil)
//        } else {
//            // Snapchat app is not installed, open Snapchat website in Safari
//            UIApplication.shared.open(safariURL, options: [:], completionHandler: nil)
//        }
//    }
    
    class func openSnapchat(link snapLink: String) {
        let snapchatURL = URL(string: "snapchat://\(snapLink)")!
        if UIApplication.shared.canOpenURL(snapchatURL) {
            // Snapchat app is installed, open it directly
            UIApplication.shared.open(snapchatURL, options: [:], completionHandler: nil)
        } else {
            // Snapchat app is not installed, open App Store page for Snapchat
            if let appStoreURL = URL(string: "https://apps.apple.com/us/app/snapchat/id447188370") {
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
            }
        }
    }


    class func openWebBrowser(_ urlString: String) {
        let url = URL(string: urlString)
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:])
        } else {
            UIApplication.shared.openURL(url!)
        }
    }
    /*
     don't forget to add this to info.plist
     
     <key>LSApplicationQueriesSchemes</key>
     <array>
         <string>whatsapp</string>
     </array>
     
     */
}
