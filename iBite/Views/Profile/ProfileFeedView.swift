//
//  ProfileFeedView.swift
//  iBite
//
//  Created by Eslam on 16/01/2025.
//

import SwiftUI

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
