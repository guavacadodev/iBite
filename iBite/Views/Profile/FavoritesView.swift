//
//  FavoritesView.swift
//  iBite
//
//  Created by Eslam on 16/01/2025.
//

import SwiftUI
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
