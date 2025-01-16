//
//  ProfileView.swift
//  twitterui
//
//  Created by Jake Woodall on 11/8/24.
//

import SwiftUI
import MapKit


//struct ProfileContent: View {
//    var dummyUserData: UserModel = UserModel(username: "Eslam", dateCreated: Date(), birthday: 97, signedUp: true, isMember: true, followers: 1000, following: 2900)
//    @Binding var isUsersOwnProfile: Bool
//    @Environment(\.presentationMode) var presentationMode
//
//    @State private var navigateToEditProfile = false
//    @State private var navigateToChangePassword = false
//
//    var body: some View {
//        NavigationStack {
//            Group {
//                if isUsersOwnProfile {
//                    UserProfileView(user: dummyUserData)
//                        .toolbar {
//                            // Gear icon with Menu
//                            ToolbarItem(placement: .navigationBarTrailing) {
//                                Menu {
//                                    Button(action: {
//                                        navigateToEditProfile = true
//                                    }) {
//                                        Label("Update Profile", systemImage: "person")
//                                    }
//                                    Button(action: {
//                                        navigateToChangePassword = true
//                                    }) {
//                                        Label("Change Password", systemImage: "lock")
//                                    }
//                                    Button(role: .destructive, action: {
//                                        print("User signed out!")
//                                    }) {
//                                        Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.forward")
//                                    }
//                                } label: {
//                                    Image(systemName: "gearshape")
//                                        .foregroundColor(.primary)
//                                }
//                            }
//                        }
//                        .background(
////                            NavigationLink("", destination: EditProfileView(user: dummyUserData, userName: dummyUserData.username, bithdate: dummyUserData.birthday.description), isActive: $navigateToEditProfile)
////                                .hidden()
//                            
//                            NavigationLink(
//                                destination: EditProfileView(user: dummyUserData, userName: dummyUserData.username, bithdate: dummyUserData.birthday.description),
//                                isActive: $navigateToEditProfile,
//                                label: { EmptyView() }
//                            )
//                            
//                           
//                            
//                        )
//                        .background(
//                            NavigationLink("", destination: ChangePasswordView(), isActive: $navigateToChangePassword)
//                                .hidden()
//                        )
//                } else {
//                    OtherUserProfileView(user: dummyUserData)
//                        .onAppear {
//                            presentationMode.wrappedValue.dismiss()
//                        }
//                }
//            }
//            
//            .navigationBarTitleDisplayMode(.inline)
//            
//        }
//        .accentColor(.red)
//    }
//
//}

import SwiftUI

struct ProfileContent: View {
    @Environment(\.presentationMode) var presentationMode
    var dummyUserData: UserModel = UserModel(username: "Eslam", dateCreated: Date(), birthday: 97, signedUp: true, isMember: true, followers: 1000, following: 2900)
    @Binding var isUsersOwnProfile: Bool
    @State private var navigateToEditProfile = false
    @State private var navigateToChangePassword = false
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Custom background color
                Color("darkNeutral")//violet1
                    .ignoresSafeArea()

                if isUsersOwnProfile {
                    UserProfileView(user: dummyUserData)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
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
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                        .background(
                            NavigationLink("", destination: EditProfileView(user: dummyUserData, userName: dummyUserData.username, bithdate: dummyUserData.birthday.description), isActive: $navigateToEditProfile)
                                .hidden()
                        )
                        .background(
                            NavigationLink("", destination: ChangePasswordView(), isActive: $navigateToChangePassword)
                                .hidden()
                        )
                } else {
                    OtherUserProfileView(user: dummyUserData)
                }
            }
            .toolbarBackground(Color.purple1, for: .navigationBar) //this
            .toolbarBackground(.visible, for: .navigationBar) //this
            .navigationBarTitleDisplayMode(.inline)
            .accentColor(.white) // Optional: Adjust accent color for buttons
            .navigationBarItems(
                leading: Group {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundColor(Color("purple1"))
                            Text("Back")
                                .font(.custom("Fredoka-Regular", size: 16))
                                .foregroundColor(Color("purple1"))
                        }
                    }
                }
            )
            .shadow(color: .clear, radius: 0, x: 0, y: 0)

        }
        .accentColor(Color("purple1"))
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
                                .offset(y: stickyOffset < 100 ? -stickyOffset + 188 : 0)
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
