//
//  MainView.swift
//  iBite
//
//  Created by Jake Woodall on 11/9/24.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab: Int = 1
    @State private var showingARView: Bool = false // Track ARMenuView visibility
    @State private var showingPhotogrammetryView: Bool = false // Track PhotogrammetryView visibility
    @State private var showingFeedView: Bool = false // Track whether the FeedView is showing or not.
    @State private var showingSearchView: Bool = false // Track whether or not the SearchView is showing
    @State private var showingPremiumDashboard: Bool = false
    @State private var isUsersOwnProfile: Bool = false // Track whether the user is looking at their own profile or another user's profile.
    @State private var userIsPremium: Bool = false // Track whether the user has a premium subscription
    @State private var userIsLoggedIn: Bool = false // Track whether the user is logged in or not. Send them to onboarding if they are not.
    @State private var selectedRestaurant: Restaurant?
    @State private var showProfileAndUploadSelection: Bool = false

    var body: some View {
         ZStack {
            // Use ZStack to manage tab content
            Group {
                switch selectedTab {
                case 0:
                    SearchView()
                        .ignoresSafeArea() // Ensure it extends to edges
                case 1:
                    if showingFeedView {
                        SearchView()
                            .transition(.move(edge: .leading))
                            .gesture(
                                DragGesture()
                                    .onEnded { value in
                                        if value.translation.width < -50 { // Swipe left
                                            withAnimation {
                                                showingFeedView = false
                                            }
                                        }
                                    }
                            )
                    } else {
                        ContentView(showingARView: $showingARView)
                            .ignoresSafeArea()
                            .transition(.move(edge: .trailing))
                            .gesture(
                                DragGesture()
                                    .onEnded { value in
                                        if value.translation.width > 50 { // Swipe right
                                            withAnimation {
                                                showingFeedView = true
                                            }
                                        }
                                    }
                            )
                    }
                case 2:
                    ProfileContent(isUsersOwnProfile: $isUsersOwnProfile)
                case 3:
                    LeaderboardFeedView()
                default:
                    ContentView(showingARView: $showingARView)
                        .ignoresSafeArea()
                }
            }
             // This code manages the BottomNavigationBar visibility on given views. If the ARMenuView is showing, the BottomNavigationBar gets pushed down, as stated in the MainView.
            /* If the ARView or Photogrammetry Views ( or any other views I want to add here ) are true, then the Spacer() will push the BottomNavigationBar() down and render it invisible for those given views. We just need to add a @Binding bool on the view we want the BottomNavigationBar to not show, and set it to true like this:
                @Binding var showingARView: Bool
             */
             if !showingARView && !showingPhotogrammetryView && !showingFeedView {
                VStack {
                    Spacer() // Push the bar to the bottom
                    BottomNavigationBar(showProfileAndUploadSelection: $showProfileAndUploadSelection, userIsPremium: $userIsPremium, isUsersOwnProfile: $isUsersOwnProfile, selectedTab: $selectedTab, showingPremiumDashboard: $showingPremiumDashboard)
                        .scaleEffect(0.85)
                }
            }
        }
        .preferredColorScheme(.light) // Set light mode for consistency
        .fullScreenCover(isPresented: $showingPremiumDashboard) {
            PremiumDashboardView(userIsPremium: $userIsPremium)
            
        }
        .onTapGesture {
            withAnimation {
                showProfileAndUploadSelection = false // Dismiss the popup
            }
        }
    }
}


