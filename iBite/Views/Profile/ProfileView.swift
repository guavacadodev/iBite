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
    @Environment(\.presentationMode) var presentationMode

    @State private var navigateToEditProfile = false
    @State private var navigateToChangePassword = false

    var body: some View {
        NavigationView {
            if isUsersOwnProfile {
                UserProfileView(user: dummyUserData)
                    .toolbar {
                        // Gear icon with Menu
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
//                UserProfileView(user: dummyUserData)
//                    .onAppear {
//                        presentationMode.wrappedValue.dismiss()
//                    }
                OtherUserProfileView(user: dummyUserData)
                    .onAppear {
                        presentationMode.wrappedValue.dismiss()
                    }
            }
        }
    }
}


struct SettingsMenuView: View {
    var body: some View {
        List {
            NavigationLink(destination: SignOutView()) {
                Text("Sign Out")
            }
            NavigationLink(destination: ChangePasswordView()) {
                Text("Change Password")
            }
//            NavigationLink(destination: UpdateProfileView(user: )) {
//                Text("Update Profile")
//            }

        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitleTextColor(Color.violet1)
    }
}

// Example UserProfileView for demonstration

struct UserProfileView: View {
    var user: UserModel
    var body: some View {
        ProfileView(user: user, bannerTitle: "Your Profile", isUsersOwnProfile: true)
            .padding(.bottom, 20)
            .background(Color("darkNeutral"))
            .preferredColorScheme(.light)
    }
}

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
                                .offset(y: stickyOffset < 100 ? -stickyOffset + 155 : 0)
                                .zIndex(1)
                                .onChange(of: stickyOffset) { newOffset in
                                    bannerZIndex = newOffset <= 100 ? 3 : 0
                                }
                        }
                        .frame(height: 48)

                        // Display different views based on the selected tab
                        ProfileFeedView(selectedTab: selectedTab) // Pass selectedTab here
                            .zIndex(-1) // Ensure it stays behind StickyTabView and Banner
                    }
                }
            }
        }
        .background(Color("darkNeutral"))
        .preferredColorScheme(.light)
        
    }
}

struct BannerView: View {
    var bannerTitle: String

    var body: some View {
        Rectangle()
            .foregroundColor(Color("purple1"))
            .overlay {
                Text(bannerTitle)
                    .padding(.top, 50)
                    .font(.custom("Fredoka-SemiBold", size: 28))
                    .foregroundColor(.white)
            }
            .ignoresSafeArea()
    }
}

struct HeaderView: View {
    var user: UserModel
    var offset: CGFloat
    var isUsersOwnProfile: Bool // Pass the binding value here
    @State private var isMenuPresented: Bool = false
    var body: some View {
        VStack {
            // Profile Icon
            Image("profile_image")
                .resizable()
                .clipShape(Circle())
                .frame(width: 100, height: 100)
                .scaleEffect(offset < -60 ? 0.5 : 1.2)
                .padding(.top, offset < -20 ? 0 : -40)
                .shadow(radius: 10)
                .animation(.easeInOut, value: offset)

            HStack(spacing: 12) {
                ZStack {
                    Rectangle()
                        .cornerRadius(8)
                        .frame(width: 100, height: 40)
                        .foregroundColor(Color("whiteNeutral"))
                    HStack(spacing: nil) {
                        Text(user.followers.description)
                            .font(.custom("Fredoka-Regular", size: 14))
                        Image(systemName: "person.fill")
                    }
                }
                
                ZStack {
                    Rectangle()
                        .cornerRadius(8)
                        .frame(width: 100, height: 40)
                        .foregroundColor(Color("whiteNeutral"))
                    HStack(spacing: nil) {
                        Text(user.following.description)
                            .font(.custom("Fredoka-Regular", size: 14))
                        Image(systemName: "person.fill")
                    }
                }

                // Conditionally display the add button
                if !isUsersOwnProfile {
                    ZStack {
                        Rectangle()
                            .cornerRadius(10)
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color("red1"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("red2"), lineWidth: 2)
                            )
                        Image(systemName: "plus.square.fill")
                            .foregroundColor(Color("whiteNeutral"))
                    }
                    .onTapGesture {
                        isMenuPresented.toggle()
                    }
                    .popover(isPresented: $isMenuPresented) {
                        VStack(alignment: .leading, spacing: 16) {
                            // Menu Items
                            ForEach(socialAccounts.allCases, id: \.self) { method in
                                Button(action: {
                                    method.itemTapped()
                                }) {
                                    HStack {
                                        ZStack {
                                            Circle()
                                                .frame(width: 70, height: 70)
                                                .foregroundColor(.black)
                                            Circle()
                                                .frame(width: 60, height: 60)
                                                .foregroundColor(.white)
                                            Image(method.iconName)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 40, height: 40)
                                                .foregroundColor(.black)
                                        }
                                        Text(method.rawValue)
                                            .foregroundColor(.primary)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding()
                        .background(Color("whiteNeutral"))
                        .preferredColorScheme(.light)
                        .cornerRadius(12)
                        .shadow(radius: 10)
                    }
                    .background(Color("darkNeutral"))
                    .preferredColorScheme(.light)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            if isUsersOwnProfile {
                NavigationLink(destination: EditProfileView(user: user, userName: user.username, bithdate: user.birthday.description)) {
                    Text("Edit Profile")
                        .foregroundColor(.darkNeutral)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 60)
                        .background(Color.teal1)
                        .cornerRadius(8)
                }
            }

            Text("Just a coder navigating the labyrinth of SwiftUI. \nI love building beautiful and functional apps!")
                .font(.footnote)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .frame(maxWidth: UIScreen.main.bounds.width - 40) // Constrain to screen width with padding
                .padding(.horizontal, 16)
                .foregroundColor(Color("whiteNeutral"))
        }
    }
}





struct StickyTabView: View {
    @Binding var selectedTab: Int // Bind to parent state

    var body: some View {
        VStack {
            HStack {
                ForEach(0..<3) { index in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = index
                        }
                    }) {
                        VStack(spacing: 4) {
                            Text(tabTitle(for: index))
                                .foregroundColor(selectedTab == index ? Color("purple2") : Color("lightGrayNeutral").opacity(0.5))
                                .font(.custom("Fredoka-Medium", size: 16))

                            if selectedTab == index {
                                Capsule()
                                    .frame(height: 3)
                                    .foregroundColor(Color("purple2"))
                                    .transition(.scale)
                            } else {
                                Capsule()
                                    .frame(height: 3)
                                    .foregroundColor(Color("lightGrayNeutral").opacity(0.5))
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 48)
        .background(Color("grayNeutral"))
        .overlay(
            Divider()
                .background(Color("lightGrayNeutral")),
            alignment: .top
        )
    }

    private func tabTitle(for index: Int) -> String {
        switch index {
        case 0: return "Reviews"
        case 1: return "Favorites"
        case 2: return "Collection"
        default: return ""
        }
    }
}

struct ProfileFeedView: View {
    var selectedTab: Int

    var body: some View {
        switch selectedTab {
        case 0:
            ReviewsView() // Replace with your reviews content
                .background(Color("grayNeutral"))
        case 1:
            FavoritesView(favoriteItems: UserDefaults.favoriteResturants) // Replace with your favorites content
                .background(Color("grayNeutral"))
        case 2:
            CollectionView() // Replace with your collection content
                .background(Color("grayNeutral"))
        default:
            EmptyView()
        }
    }
}

// Example content views for each tab
struct ReviewsView: View {
    // Mock data for reviews
    let reviews: [Review] = [
        Review(restaurantName: Restaurant(
                    //id: UUID(),
                    name: "Pizza Palace",
                    cuisine: .Italian,
                    location: Coordinate(CLLocationCoordinate2D(latitude: 47.6062, longitude: -122.3321)),
                    distance: 1.5,
                    imageName: "pizza_palace",
                    models: [],
                    menuItems: [],
                    favorite: false
               ),
               reviewText: "The best pizza in town!",
               rating: 5),
        Review(restaurantName: Restaurant(
                    //id: UUID(),
                    name: "Burger Haven",
                    cuisine: .BBQ,
                    location: Coordinate(CLLocationCoordinate2D(latitude: 47.608, longitude: -122.340)),
                    distance: 2.3,
                    imageName: "burger_haven",
                    models: [],
                    menuItems: [],
                    favorite: false
               ),
               reviewText: "Juicy and delicious burgers.",
               rating: 4)
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(reviews) { review in
                    ReviewCard(review: review)
                }
            }
            .padding(.horizontal)
        }
        .background(Color("darkNeutral"))
    }
}

struct ReviewCard: View {
    let review: Review

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Display restaurant details
            HStack {
                Image(review.restaurantName.imageName)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading) {
                    Text(review.restaurantName.name)
                        .font(.headline)
                        .foregroundColor(Color("purple2"))
                    Text("\(review.restaurantName.cuisine.rawValue) • \(String(format: "%.1f", review.restaurantName.distance)) mi")
                        .font(.subheadline)
                        .foregroundColor(Color("lightGrayNeutral"))
                }

                Spacer()

                // Display star rating
                HStack(spacing: 2) {
                    ForEach(0..<5) { starIndex in
                        Image(systemName: starIndex < review.rating ? "star.fill" : "star")
                            .foregroundColor(starIndex < review.rating ? Color("teal1") : Color.gray)
                            .font(.system(size: 14))
                    }
                }
            }

            // Display review text
            Text(review.reviewText)
                .font(.body)
                .foregroundColor(Color("lightGrayNeutral"))

            Divider()
                .background(Color("grayNeutral"))
        }
        .padding()
        .background(Color("yellow1"))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
//UserDefaults.favoriteResturants
struct FavoritesView: View {
    @State var favoriteItems: [Restaurant]
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    let colors: [Color] = (0..<30).map { _ in
        Color(red: Double.random(in: 0...1),
              green: Double.random(in: 0...1),
              blue: Double.random(in: 0...1))
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(favoriteItems.indices, id: \.self) { index in
                let restaurant = favoriteItems[index]
                RestaurantCardView(restaurant: restaurant, isFavorite: restaurant.favorite, onClickFavoriteButton: {
                    favoriteItems[index].favorite.toggle()
                    UserDefaults.favoriteResturants = []
                    let favoriteRestaurants = favoriteItems.filter { $0.favorite }
                    UserDefaults.favoriteResturants = favoriteRestaurants
                })
            }
        }
        .padding(.horizontal)
        .background(Color("darkNeutral"))
    }
}

struct CollectionView: View {
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
        //GridItem(.flexible(), spacing: 10)
    ]
    
    let colors: [Color] = (0..<30).map { _ in
        Color(red: Double.random(in: 0...1),
              green: Double.random(in: 0...1),
              blue: Double.random(in: 0...1))
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach((0..<30), id: \.self) { _ in
                Rectangle()
                    .foregroundColor(.primary)
                    .frame(height: 100)
                    .overlay(
                        Text("Coming Soon!")
                            .foregroundColor(.white)
                    )
//                ZStack {
//                    Text("Coming Soon!")
//                }
                    .background(Color.primary)
            }
        }
        .padding(.top, 20)
        .padding(.horizontal)
        .background(Color("darkNeutral"))
    }
}

//#Preview {
//    StickyTabView()
//}

#Preview {
    StatefulPreviewWrapper(false) { state in
        ProfileContent(isUsersOwnProfile: state)
    }
}
