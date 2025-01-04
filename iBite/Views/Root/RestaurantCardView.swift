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
                .scaledToFill()
                .frame(width: .infinity, height: 120)
                .clipped()
                .scaleEffect(1.1)

            VStack(alignment: .leading) {
                HStack {
                    Text(restaurant.name)
                        .font(.custom("Fredoka-Regular", size: 18))
                        .foregroundColor(Color("whiteNeutral"))
                    Spacer()
                    Button(action: {
                        // Add action here
                    }) {
                        Image(systemName: "heart")
                            .font(.system(size: 18)) // Adjust size as needed
                            .foregroundColor(Color("whiteNeutral"))
                    }
                }
                Text(restaurant.cuisine.rawValue)
                    .font(.custom("Fredoka-Light", size: 13))
                    .foregroundColor(Color("lightGrayNeutral"))
                Text("\(restaurant.distance, specifier: "%.1f") miles away") // Display real distance
                    .font(.custom("Fredoka-Medium", size: 12)) // Updated font to Fredoka-SemiBold
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

