//
//  ProfileView.swift
//  twitterui
//
//  Created by Jake Woodall on 11/8/24.
//

import SwiftUI
import MapKit

struct ProfileContent: View {
    @Binding var isUsersOwnProfile: Bool
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        if isUsersOwnProfile {
            UserProfileView()
        } else {
            UserProfileView()
                .onAppear {
                    presentationMode.wrappedValue.dismiss()
                }
        }
    }
}

struct UserProfileView: View {
    var body: some View {
        ProfileView(bannerTitle: "Your Profile", isUsersOwnProfile: true)
    }
}

struct OtherUserProfileView: View {
    var body: some View {
        ProfileView(bannerTitle: "Other User", isUsersOwnProfile: false)
    }
}

struct ProfileView: View {
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
                            HeaderView(offset: offset, isUsersOwnProfile: isUsersOwnProfile)
                        }
                        .offset(y: max(-offset, 0)) // Smooth slide under BannerView
                    }
                    .frame(height: 300) // Limit GeometryReader height

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
    var offset: CGFloat
    var isUsersOwnProfile: Bool // Pass the binding value here

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
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color("whiteNeutral"))
                    Image(systemName: "chevron.down.square")
                }

                ZStack {
                    VStack {
                        Image(systemName: "heart.fill")
                        Text("1,230")
                    }
                    Rectangle()
                        .cornerRadius(8)
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color("whiteNeutral"))
                    Image(systemName: "envelope")
                }

                ZStack {
                    Rectangle()
                        .cornerRadius(8)
                        .frame(width: 100, height: 40)
                        .foregroundColor(Color("whiteNeutral"))
                    HStack(spacing: nil) {
                        Text("130,112")
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
                            .overlay( // Add the teal2 outline
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("red2"), lineWidth: 2)
                            )
                        Image(systemName: "plus.square.fill")
                            .foregroundColor(Color("whiteNeutral"))
                    }
                }
            }
            .padding()

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
            FavoritesView() // Replace with your favorites content
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
                    location: CLLocationCoordinate2D(latitude: 47.6062, longitude: -122.3321),
                    distance: 1.5,
                    imageName: "pizza_palace",
                    models: [],
                    menuItems: []
               ),
               reviewText: "The best pizza in town!",
               rating: 5),
        Review(restaurantName: Restaurant(
                    //id: UUID(),
                    name: "Burger Haven",
                    cuisine: .BBQ,
                    location: CLLocationCoordinate2D(latitude: 47.608, longitude: -122.340),
                    distance: 2.3,
                    imageName: "burger_haven",
                    models: [],
                    menuItems: []
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

struct FavoritesView: View {
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
            ForEach(colors.indices, id: \.self) { index in
                Rectangle()
                    .foregroundColor(colors[index])
                    .frame(height: 150)
            }
        }
        .padding(.horizontal)
        .background(Color("darkNeutral"))
    }
}

struct CollectionView: View {
    let columns = [
        GridItem(.flexible(), spacing: 10),
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
            ForEach(colors.indices, id: \.self) { index in
                Rectangle()
                    .foregroundColor(colors[index])
                    .frame(height: 150)
            }
        }
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









