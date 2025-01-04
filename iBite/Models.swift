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
    let cuisine: Cuisines
    var location: CLLocationCoordinate2D
    var distance: Double
    let imageName: String
    let models: [String]
    let menuItems: [MenuItem] // New property for menu items
}

// Review Model
struct Review: Identifiable {
    let id = UUID()
    let restaurantName: Restaurant
    let reviewText: String
    let rating: Int
}

struct ModelItem: Identifiable {
    let id = UUID()
    let url: URL
    let name: String
    let price: String
    let ingredients: String
}

struct MenuItem {
    let name: String
    let price: String
    let ingredients: String
}

struct UserModel {
    let username: String
    let dateCreated: Date
    let id = UUID()
    let birthday: Int
    let signedUp: Bool?
    let isMember: Bool?
    let followers: Int
    let following: Int
}

enum Cuisines: String, CaseIterable {
    case Italian
    case BarAndGrill
    case American
    case Mexican
    case Japanese
    case Chinese
    case French
    case Indian
    case Mediterranean
    case Thai
    case Korean
    case Spanish
    case Greek
    case Vietnamese
    case Caribbean
    case MiddleEastern
    case African
    case BBQ
    case Seafood
    case Vegan
    case FastFood
    case Desserts
    case Fusion
}


// Sample data with unique models for each restaurant
let sampleRestaurants = [
    Restaurant(
        name: "Il Siciliano Ristorante Italiano",
        cuisine: .Italian,
        location: CLLocationCoordinate2D(latitude: 47.2025, longitude: -121.9915),
        distance: 0.5,
        imageName: "french_cuisine",
        models: ["croissant", "baguette"],
        menuItems: [
            MenuItem(name: "Spaghetti Carbonara", price: "$13.99", ingredients: "Pasta, Eggs, Parmesan, Bacon"),
            MenuItem(name: "Margherita Pizza", price: "$9.99", ingredients: "Tomato, Mozzarella, Basil")
        ]
    ),
    Restaurant(
        name: "The Rainier Bar & Grill",
        cuisine: .BarAndGrill,
        location: CLLocationCoordinate2D(latitude: 47.2025, longitude: -121.9915),
        distance: 0.5,
        imageName: "the_rainier_bar_and_grill",
        models: ["croissant", "baguette"],
        menuItems: [
            MenuItem(name: "Spaghetti Carbonara", price: "$13.99", ingredients: "Pasta, Eggs, Parmesan, Bacon"),
            MenuItem(name: "Margherita Pizza", price: "$9.99", ingredients: "Tomato, Mozzarella, Basil")
        ]
    ),
    Restaurant(
        name: "Sushi Palace",
        cuisine: .Seafood,
        location: CLLocationCoordinate2D(latitude: 47.2025, longitude: -121.9915),
        distance: 0.5,
        imageName: "sushi_place",
        models: ["croissant", "baguette"],
        menuItems: [
            MenuItem(name: "Spaghetti Carbonara", price: "$13.99", ingredients: "Pasta, Eggs, Parmesan, Bacon"),
            MenuItem(name: "Margherita Pizza", price: "$9.99", ingredients: "Tomato, Mozzarella, Basil")
        ]
    ),
]

