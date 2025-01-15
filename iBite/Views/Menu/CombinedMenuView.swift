//
//  CombinedMenuView.swift
//  iBite
//
//  Created by Jake Woodall on 1/14/25.
//

import SwiftUI

struct CombinedMenuView: View {
    var models: [String]
    var menuItems: [MenuItem]
    @Binding var showingARView: Bool // Pass the binding to control visibility of BottomNavigationBar

    var body: some View {
        TabView {
            // AR Menu Overlay View
            ARMenuOverlayView(models: models, menuItems: menuItems)
                .tabItem {
                    Label("AR Menu", systemImage: "arkit")
                        .foregroundColor(Color("yellow1"))
                }

            // Flat Menu View
            FlatMenuView(menuItems: menuItems)
                .tabItem {
                    Label("Flat Menu", systemImage: "list.bullet.rectangle")
                        .foregroundColor(Color("yellow1"))
                }
        }
        .ignoresSafeArea()
        .onAppear {
            showingARView = true
        }
        .onDisappear {
            showingARView = false
        }
        .background(
            VStack {
                Image("sushi_place")
                    .resizable()
                    .scaledToFit()
                    .frame(width: .infinity, height: .infinity)
                    .clipped()
                    .ignoresSafeArea()
                Spacer()
            },
            alignment: .top // Aligns the background to the top
        )
        .navigationBarBackButtonHidden(true) // Hide the default back button
        .tabViewStyle(.page(indexDisplayMode: .automatic)) // Enable horizontal swiping
    }
}
