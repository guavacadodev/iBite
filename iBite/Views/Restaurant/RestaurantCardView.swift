//
//  RestaurantCardView.swift
//  iBite
//
//  Created by Jake Woodall on 10/29/24.
//

import SwiftUI
import CoreLocation

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

#Preview {
    RestaurantCardView(
        restaurant: Restaurant(
            name: "Sample Restaurant",
            cuisine: .Italian,
            location: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
            distance: 2.5,
            imageName: "pasta_palace",
            models: ["sample_model1", "sample_model2"],
            menuItems: [
                MenuItem(name: "Sample Dish 1", price: "$12.99", ingredients: "Ingredient A, Ingredient B"),
                MenuItem(name: "Sample Dish 2", price: "$9.99", ingredients: "Ingredient C, Ingredient D")
            ],
            reviewText: nil,
            rating: nil
        ),
        userHasLikedRestaurant: .constant(false)
    )
    .previewLayout(.sizeThatFits)
}


