//
//  FeaturedRestaurantCardView.swift
//  iBite
//
//  Created by Jake Woodall on 11/2/24.
//

import SwiftUI
import CoreLocation

struct FeaturedRestaurantCardView: View {
    let restaurant: Restaurant
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(restaurant.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 200)
                .clipped()
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(restaurant.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text("\(restaurant.distance, specifier: "%.1f") miles away")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding([.horizontal, .bottom], 8)
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .frame(width: 300) // Fixed width for each card
    }
}


#Preview {
    FeaturedRestaurantCardView(restaurant: Restaurant(
        name: "Sample Restaurant",
        cuisine: "Italian",
        location: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
        distance: 2.5,
        imageName: "sample_image", // Use an actual image name from your assets
        models: ["sample_model1", "sample_model2"],
        menuItems: [
            MenuItem(name: "Sample Dish 1", price: "$12.99", ingredients: "Ingredient A, Ingredient B"),
            MenuItem(name: "Sample Dish 2", price: "$9.99", ingredients: "Ingredient C, Ingredient D")
        ]
    ))
}

