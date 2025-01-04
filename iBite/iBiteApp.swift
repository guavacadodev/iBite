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
    @State private var modelIndex = 0 // Manage the state at the app level
    @StateObject private var modelManager = ModelManager()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        FirebaseApp.configure()
        AppCheck.setAppCheckProviderFactory(DeviceCheckProviderFactory())
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(modelManager) // Pass ModelManager to all views
        }
    }
}


