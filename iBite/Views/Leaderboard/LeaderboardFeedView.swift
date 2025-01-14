//
//  FeedView.swift
//  iBite
//
//  Created by Jake Woodall on 11/18/24.
//

import SwiftUI

struct LeaderboardFeedView: View {
    // Sample data for leaderboard rankings
    struct UserRanking: Identifiable {
        let id = UUID()
        let rank: Int
        let username: String
        let points: Int
        let profileImageName: String // Asset name for profile image
    }

    // Example data for the leaderboard
    let leaderboardData: [UserRanking] = [
        UserRanking(rank: 1, username: "JohnDoe", points: 2500, profileImageName: "profile1"),
        UserRanking(rank: 2, username: "JaneSmith", points: 2000, profileImageName: "profile2"),
        UserRanking(rank: 3, username: "SammyJ", points: 1800, profileImageName: "profile3"),
        UserRanking(rank: 4, username: "Chris", points: 1700, profileImageName: "profile4"),
        UserRanking(rank: 5, username: "Alex89", points: 1600, profileImageName: "profile5")
    ]

    @State private var currentIndex: Int = 0 // Tracks the currently visible ranking
    @State private var searchText: String = "" // Search bar text

    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Leaderboard title
                Text("Leaderboard")
                    .font(.custom("Fredoka-SemiBold", size: 24))
                    .foregroundColor(Color("whiteNeutral"))
                Spacer()
                // Search bar
                HStack {
                    TextField("Search by restaurant name", text: $searchText)
                        .foregroundStyle(Color("darkNeutral"))
                        .accentColor(Color("darkNeutral"))
                        .padding(10)
                        .background(Color("yellow1"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("yellow2"), lineWidth: 1)
                        )
                        .padding(.horizontal)
                }
                .padding(.bottom, 10)

                Text("Show restaurant on leaderboard based on which one has the most amount of favorites")
                    .foregroundStyle(Color("whiteNeutral"))
                
                // Leaderboard Cards
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(leaderboardData) { user in
                            RankingCardView(user: user, width: geometry.size.width, height: geometry.size.height)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .clipped()
                        }
                    }
                }
                .ignoresSafeArea()
                .onAppear {
                    UIScrollView.appearance().isPagingEnabled = true // Enables snapping behavior
                }
                .onDisappear {
                    UIScrollView.appearance().isPagingEnabled = false
                }

                Spacer()
            }
        }
        .background(Color("darkNeutral"))
    }
}

struct RankingCardView: View {
    let user: LeaderboardFeedView.UserRanking
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        VStack(spacing: 16) {
            // Profile image
            Image(user.profileImageName)
                .resizable()
                .scaledToFit()
                .frame(width: width * 0.4, height: width * 0.4)
                .clipShape(Circle())
                .shadow(radius: 10)

            // Rank badge
            Text("#\(user.rank)")
                .font(.custom("Fredoka-Bold", size: 36))
                .foregroundColor(user.rank == 1 ? Color("yellow1") : user.rank == 2 ? Color("green1") : Color("bronze"))

            // Username
            Text(user.username)
                .font(.custom("Fredoka-Regular", size: 20))
                .foregroundColor(Color("lightGrayNeutral"))

            // Points
            Text("\(user.points) points")
                .font(.custom("Fredoka-Light", size: 18))
                .foregroundColor(Color("lightGrayNeutral"))
        }
        .frame(width: width * 0.9, height: height * 0.8)
        .background(Color("grayNeutral"))
        .cornerRadius(20)
        .shadow(color: Color("lightGrayNeutral"), radius: 10)
        .padding()
    }
}

#Preview {
    LeaderboardFeedView()
}




