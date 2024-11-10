//
//  Models.swift
//  iBite
//
//  Created by Jake Woodall on 10/29/24.
//

import Foundation
import CoreLocation

// Models.swift
struct Restaurant: Identifiable {
    let id = UUID()
    let name: String
    let cuisine: String
    var location: CLLocationCoordinate2D
    var distance: Double
    let imageName: String
    let models: [String]
    let menuItems: [MenuItem] // New property for menu items
}

// Sample data with unique models for each restaurant
let sampleRestaurants = [
    Restaurant(
        name: "Il Siciliano Ristorante Italiano",
        cuisine: "Italian",
        location: CLLocationCoordinate2D(latitude: 47.2025, longitude: -121.9915),
        distance: 0.5,
        imageName: "french_cuisine",
        models: ["croissant", "baguette"],
        menuItems: [
            MenuItem(name: "Spaghetti Carbonara", price: "$13.99", ingredients: "Pasta, Eggs, Parmesan, Bacon"),
            MenuItem(name: "Margherita Pizza", price: "$9.99", ingredients: "Tomato, Mozzarella, Basil")
        ]
    ),
    // Add more restaurants with menu items here
]

