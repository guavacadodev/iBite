//
//  RestaurantCardView.swift
//  iBite
//
//  Created by Jake Woodall on 10/29/24.
//

import SwiftUI

struct RestaurantCardView: View {
    var restaurant: Restaurant

    var body: some View {
        VStack(alignment: .leading) {
            Image(restaurant.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 120)
                .clipped()

            VStack(alignment: .leading) {
                Text(restaurant.name)
                    .font(.headline)
                Text(restaurant.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("\(restaurant.distance, specifier: "%.1f") miles away") // Display real distance
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding([.leading, .bottom, .trailing], 8)
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

