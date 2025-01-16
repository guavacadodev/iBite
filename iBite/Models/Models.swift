//
//  Models.swift
//  iBite
//
//  Created by Jake Woodall on 10/29/24.
//

import Foundation
import CoreLocation

// Models.swift
struct Restaurant: Identifiable, Codable {
    var id = UUID()
    var name: String
    var cuisine: Cuisines
    var location: Coordinate
    var distance: Double
    let imageName: String
    let models: [String]
    let menuItems: [MenuItem]
    var reviewText: String?
    var rating: Int?
    var favorite: Bool
    var isSelected: Bool = false
}

struct Coordinate: Codable {
    var latitude: Double
    var longitude: Double
    
    // Initializer for convenience
    init(_ coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
    
    // Convert back to CLLocationCoordinate2D
    var clLocationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
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

struct MenuItem: Codable {
    let name: String
    let price: String
    let ingredients: String
}

struct UserModel: Codable {
    var id = UUID()
    var username: String
    var dateCreated: Date
    var birthday: String
    var signedUp: Bool?
    var isMember: Bool?
    var followers: Int
    var following: Int
}

enum Cuisines: String, CaseIterable, Codable {
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
        location: Coordinate(CLLocationCoordinate2D(latitude: 47.2025, longitude: -121.9915)),
        distance: 0.5,
        imageName: "french_cuisine",
        models: ["croissant", "baguette"],
        menuItems: [
            MenuItem(name: "Spaghetti Carbonara", price: "$13.99", ingredients: "Pasta, Eggs, Parmesan, Bacon"),
            MenuItem(name: "Margherita Pizza", price: "$9.99", ingredients: "Tomato, Mozzarella, Basil")
        ],
        reviewText: nil,
        rating: nil,
        favorite: false
    ),
    Restaurant(
        name: "The Rainier Bar & Grill",
        cuisine: .BarAndGrill,
        location: Coordinate(CLLocationCoordinate2D(latitude: 47.2025, longitude: -121.9915)),
        distance: 0.5,
        imageName: "the_rainier_bar_and_grill",
        models: ["croissant", "baguette"],
        menuItems: [
            MenuItem(name: "Spaghetti Carbonara", price: "$13.99", ingredients: "Pasta, Eggs, Parmesan, Bacon"),
            MenuItem(name: "Margherita Pizza", price: "$9.99", ingredients: "Tomato, Mozzarella, Basil")
        ],
        reviewText: nil,
        rating: nil,
        favorite: false
    ),
    Restaurant(
        name: "Sushi Palace",
        cuisine: .Seafood,
        location: Coordinate(CLLocationCoordinate2D(latitude: 47.2025, longitude: -121.9915)),
        distance: 0.5,
        imageName: "sushi_place",
        models: ["croissant", "baguette"],
        menuItems: [
            MenuItem(name: "Spaghetti Carbonara", price: "$13.99", ingredients: "Pasta, Eggs, Parmesan, Bacon"),
            MenuItem(name: "Margherita Pizza", price: "$9.99", ingredients: "Tomato, Mozzarella, Basil")
        ],
        reviewText: nil,
        rating: nil,
        favorite: false
    ),
]

