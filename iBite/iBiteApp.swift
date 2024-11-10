//
//  iBiteApp.swift
//  iBite
//
//  Created by Jake Woodall on 10/25/24.
//

import SwiftUI
import Firebase
import FirebaseAppCheck

@main
struct iBiteApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        FirebaseApp.configure()
        AppCheck.setAppCheckProviderFactory(DeviceCheckProviderFactory())
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


