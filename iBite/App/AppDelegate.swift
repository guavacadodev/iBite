//
//  AppDelegate.swift
//  iBite
//
//  Created by Jake Woodall on 10/26/24.
//

import Foundation
import UIKit
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {  // Confirming to UIApplicationDelegate protocol
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if FirebaseApp.app() == nil {  // Ensure Firebase is only initialized once
            FirebaseApp.configure()
        }
        return true
    }
}
