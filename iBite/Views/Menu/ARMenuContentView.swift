//
//  ARMenuContentView.swift
//  iBite
//
//  Created by Jake Woodall on 12/21/24.
//

import SwiftUI
import ARKit
import RealityKit

/* This View is the overlay and parent of the ARMenuView. The ARMenuView simply creates the AR Session and displays the models, while this view creates the UI overlay for the AR Session and overlay for each menu item. */

struct ARMenuContentView: View {
    var models: [String] // Array of model names
    var menuItems: [MenuItem] // Array of custom data type menu items
    @State private var modelIndex = 0 // Track the current model index
    @State private var modelScale: Float = 0.05 // Default scale for models

    var body: some View {
        ZStack {
            ARMenuView(models: models, menuItems: menuItems, modelIndex: $modelIndex, modelScale: $modelScale)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                
                // Menu Items UI Overlay ( name, price, description )
                VStack {
                    if modelIndex < menuItems.count { // So if there are menuItems, then execute this:
                        Text(menuItems[modelIndex].name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom, 5)
                        Text("Price: \(menuItems[modelIndex].price)")
                            .font(.subheadline)
                            .padding(.bottom, 2)
                        Text("Ingredients: \(menuItems[modelIndex].ingredients)")
                            .font(.caption)
                            .multilineTextAlignment(.center)
                    } else {
                        Text("No menu item available.")
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.9))
                .cornerRadius(12)
                .padding(.bottom, 20)

                // Scale slider for the menu item models
                VStack {
                    Text("Scale: \(Int(modelScale * 1000))%")
                        .font(.caption)
                    Slider(value: $modelScale, in: 0.01...0.1) // Adjust the scale range as needed
                        .padding(.horizontal)
                }
                .padding(.bottom, 20)
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
                .padding()

                // Button to cycle through models
                Button(action: {
                    modelIndex = (modelIndex + 1) % models.count
                    print("Switched to model index: \(modelIndex)")
                }) {
                    Text("Next Item")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    ARMenuContentView(
        models: ["croissant", "baguette", "dish_2"],
        menuItems: [
            MenuItem(name: "Croissant", price: "$3.50", ingredients: "Flour, Butter, Sugar"),
            MenuItem(name: "Baguette", price: "$2.00", ingredients: "Flour, Water, Yeast"),
            MenuItem(name: "Dish 2", price: "$12.00", ingredients: "Beef, Sauce, Spices")
        ]
    )
}
