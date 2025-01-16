//
//  Emailer.swift
//
//  Created by MGAbouarab®
//


import MessageUI

class Emailer: NSObject {
    func sendMail(body: String, recipients: [String]) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.delegate = self
            mail.setToRecipients(recipients)
            mail.setMessageBody(body, isHTML: true)
            
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            guard let window = window else {return}
            window.topViewController()?.present(mail, animated: true, completion: nil)
        }
    }
}

extension Emailer: MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}


extension UIWindow {
    func topViewController() -> UIViewController? {
        var top = self.rootViewController
        while true {
            if let presented = top?.presentedViewController {
                top = presented
            } else if let nav = top as? UINavigationController {
                top = nav.visibleViewController
            } else if let tab = top as? UITabBarController {
                top = tab.selectedViewController
            } else {
                break
            }
        }
        return top
    }
}

