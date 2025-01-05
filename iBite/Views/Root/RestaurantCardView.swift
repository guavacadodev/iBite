//
//  RestaurantCardView.swift
//  iBite
//
//  Created by Jake Woodall on 10/29/24.
//

import SwiftUI

struct RestaurantCardView: View {
    var restaurant: Restaurant
    @Binding var userHasLikedRestaurant: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Image(restaurant.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: .infinity, height: 120)
                .clipped()
                .scaleEffect(1.1)

            VStack(alignment: .leading) {
                HStack {
                    Text(restaurant.name)
                        .font(.custom("Fredoka-Medium", size: 18))
                        .foregroundColor(Color("whiteNeutral"))
                    Spacer()
                }
                .overlay {
                    Button(action: {
                        userHasLikedRestaurant.toggle()
                    }) {
                        Spacer()
                        Image(systemName: userHasLikedRestaurant ? "heart.fill" : "heart")
                            .padding(.top, 15)
                            .font(.system(size: 24)) // Adjust size as needed
                            .foregroundColor(userHasLikedRestaurant ? Color("red1") : Color("whiteNeutral"))
                    }
                }
                Text(restaurant.cuisine.rawValue)
                    .font(.custom("Fredoka-Light", size: 13))
                    .foregroundColor(Color("yellow1"))
                Text("\(restaurant.distance, specifier: "%.1f") miles away") // Display real distance
                    .font(.custom("Fredoka-SemiBold", size: 12)) // Updated font to Fredoka-SemiBold
                    .foregroundColor(Color("lightGrayNeutral"))
            }
            .padding([.leading, .bottom, .trailing], 8)
        }
        .background(Color("grayNeutral"))
        .cornerRadius(10)
        .shadow(color: Color("lightGrayNeutral"), radius: 5, x: 0, y: 0)
        .padding()
    }
}

