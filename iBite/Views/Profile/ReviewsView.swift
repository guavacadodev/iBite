//
//  ReviewsView.swift
//  iBite
//
//  Created by Eslam on 16/01/2025.
//

import SwiftUI
import CoreLocation
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
