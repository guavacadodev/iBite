//
//  ProfileView.swift
//  twitterui
//
//  Created by Jake Woodall on 11/8/24.
//

import SwiftUI
import MapKit

struct ProfileContent: View {
    var dummyUserData: UserModel = UserModel(username: "Eslam", dateCreated: Date(), birthday: 97, signedUp: true, isMember: true, followers: 1000, following: 2900)
    @Binding var isUsersOwnProfile: Bool
    var body: some View {
        ZStack {
            Color("darkNeutral")
                .ignoresSafeArea()
            if isUsersOwnProfile {
                UserProfileView(user: dummyUserData)
            } else {
                OtherUserProfileView(user: dummyUserData)
            }
        }
    }
}

// Example UserProfileView for demonstration
struct UserProfileView: View {
    var user: UserModel
    var body: some View {
        ProfileView(user: user, bannerTitle: user.username, isUsersOwnProfile: true)
            .padding(.bottom, 20)
            .background(Color("darkNeutral"))
            .preferredColorScheme(.light)
    }
}

//MARK: - appear on Sreach from LeaderboardFeedView -
struct OtherUserProfileView: View {
    var user: UserModel
    var body: some View {
        ProfileView(user: user, bannerTitle: "Other User", isUsersOwnProfile: false)
            .padding(.bottom, 20)
            .background(Color("darkNeutral"))
            .preferredColorScheme(.light)
    }
}

struct ProfileView: View {
    var user: UserModel
    var bannerTitle: String
    @State private var bannerZIndex: Double = 0 // Track zIndex of BannerView dynamically
    var isUsersOwnProfile: Bool // Pass this from the parent view
    @State private var selectedTab = 0 // Track selected tab
    @State private var navigateToEditProfile = false
    @State private var navigateToChangePassword = false

    var body: some View {
        ZStack(alignment: .top) {
            // BannerView with dynamic zIndex
            BannerView(bannerTitle: bannerTitle)
                .frame(height: 100)
                .zIndex(bannerZIndex)
            VStack {
                ScrollView {
                    // Header section below Banner
                    GeometryReader { geometry in
                        let offset = geometry.frame(in: .global).minY
                        VStack(spacing: 20) {
                            Color.clear.frame(height: 100) // Spacer for smooth transition
                            // Pass the `isUsersOwnProfile` argument to HeaderView
                            HeaderView(user: user, offset: offset, isUsersOwnProfile: isUsersOwnProfile)
                        }
                        .offset(y: max(-offset, 0)) // Smooth slide under BannerView
                    }
                    .frame(height: 350) // Limit GeometryReader height
                    VStack(spacing: 0) {
                        // StickyTabView with zIndex update logic
                        GeometryReader { geometry in
                            let stickyOffset = geometry.frame(in: .global).minY
                            StickyTabView(selectedTab: $selectedTab) // Pass selectedTab binding
                                .background(Color.white)
                                .offset(y: stickyOffset < 100 ? -stickyOffset + 144 : 0)
                                .zIndex(1)
                                .onChange(of: stickyOffset) { newOffset in
                                    bannerZIndex = newOffset <= 100 ? 3 : 0
                                }
                        }
                        .frame(height: 48)
                        ProfileFeedView(selectedTab: selectedTab)
                            .zIndex(-1) // Ensure it stays behind StickyTabView and Banner
                    }
                }
            }
            HStack {
                Spacer()
                Menu {
                    Button(action: {
                        navigateToEditProfile = true
                    }) {
                        Label("Update Profile", systemImage: "person")
                    }
                    
                    Button(action: {
                        navigateToChangePassword = true
                    }) {
                        Label("Change Password", systemImage: "lock")
                    }
                    Button(role: .destructive, action: {
                        print("User signed out!")
                    }) {
                        Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.forward")
                    }
                } label: {
                    Image(systemName: "gearshape")
                        .font(.body)
                        .foregroundColor(.white)
                }
            }
            .sheet(isPresented: $navigateToEditProfile) {
               EditProfileView(user: user, userName: user.username, bithdate: user.birthday.description)
            }
            .sheet(isPresented: $navigateToChangePassword) {
                ChangePasswordView()
            }
            
            .padding(.horizontal, 16)
            .padding(.top, 40)
            .zIndex(10) // Ensure button stays on top
            
        }
        .background(Color("darkNeutral"))
        .preferredColorScheme(.light)
    }
}

#Preview {
    StatefulPreviewWrapper(false) { state in
        ProfileContent(isUsersOwnProfile: state)
    }
}
