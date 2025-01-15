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

struct ARMenuOverlayView: View {
    var models: [String] // Array of model names
    var menuItems: [MenuItem] // Array of custom data type menu items
    @Environment(\.presentationMode) var presentationMode
    @State private var modelIndex = 0 // Track the current model index
    @State private var modelScale: Float = 0.05 // Default scale for models
    var body: some View {
        VStack {
            // Header with restaurant name and logo
            HStack {
                // Custom Back Button
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 4) { // Adjust spacing between the icon and text
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color("purple1"))

                        Text("Back")
                            .font(.custom("Fredoka-Medium", size: 16))
                            .foregroundColor(Color("purple1"))
                    }
                    .padding(.horizontal, 10) // Add padding for better click area
                    .padding(.vertical, 6)
                }

                Spacer() // Add space to center the title

                // Restaurant Name (Centered)
                Text("Il Siciliano Ristorante Italiano")
                    .font(.custom("Fredoka-Bold", size: 20))
                    .foregroundColor(Color("purple2"))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)

                Spacer() // Add space to center the title

                // Profile Section (Aligned Right)
                Button(action: {
                    // Add action to direct to profile
                }) {
                    VStack(spacing: 4) {
                        Image("profile_image")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 32, height: 32) // Match the size in the screenshot
                            .shadow(radius: 5)

                        Text("Owner")
                            .font(.custom("Fredoka-SemiBold", size: 12))
                            .foregroundColor(Color("whiteNeutral"))
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal, 10) // Add padding to avoid clipping
            }
            .frame(maxWidth: .infinity, minHeight: 50) // Ensure a consistent height for the header
            .background(Color("grayNeutral").opacity(0.9))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
            .padding(.horizontal, 10)
            .padding(.bottom, 5)
            // AR View
            ZStack {
                LoadARItemView(models: models, menuItems: menuItems, modelIndex: $modelIndex, modelScale: $modelScale)
                    .edgesIgnoringSafeArea(.all)
                HStack(spacing: 0) {
                    // Left-side scrollable menu
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 12) {
                            ForEach(0..<models.count, id: \.self) { index in
                                Button(action: {
                                    modelIndex = index
                                    print("Selected index: \(modelIndex)")
                                }) {
                                    VStack {
                                        Image(systemName: "cube.fill")
                                            .font(.system(size: 18))
                                            .foregroundColor(Color("yellow1"))

                                        Text(menuItems[index].name)
                                            .font(.custom("Fredoka-Regular", size: 8))
                                            .foregroundColor(.white)
                                            .padding(.leading, 5)
                                            .lineLimit(2)
                                            //.truncationMode(.tail)
                                    }
                                    .padding()
                                    .scaleEffect(1.4)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(
                                        modelIndex == index ? Color("purple1").opacity(0.8) : Color("darkNeutral")
                                    )
                                    .cornerRadius(10)
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                    .padding(.top, 80)
                    .frame(width: UIScreen.main.bounds.width / 5) // Set menu width to 1/4 of the screen
                    .background(Color("grayNeutral").opacity(0.9))
                    .edgesIgnoringSafeArea(.vertical)

                    Spacer()
                }

                VStack {
                    Spacer()

                    // Menu Items UI Overlay
                    VStack(spacing: 8) {
                        if modelIndex < menuItems.count {
                            Text(menuItems[modelIndex].name)
                                .font(.custom("Fredoka-Bold", size: 20))
                                .foregroundColor(Color("purple1"))
                                .padding(.bottom, 5)

                            Text("Price: \(menuItems[modelIndex].price)")
                                .font(.custom("Fredoka-Regular", size: 16))
                                .foregroundColor(Color("yellow1"))
                                .padding(.bottom, 2)

                            Text("Ingredients: \(menuItems[modelIndex].ingredients)")
                                .font(.custom("Fredoka-Light", size: 14))
                                .foregroundColor(Color("lightGrayNeutral"))
                                .multilineTextAlignment(.center)
                        } else {
                            Text("No menu item available.")
                                .font(.custom("Fredoka-SemiBold", size: 18))
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                    .background(LinearGradient(
                        gradient: Gradient(colors: [Color("darkNeutral"), Color("grayNeutral").opacity(0.8)]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .cornerRadius(15)
                    .padding(.top, 10)

                    // Scale Slider
                    VStack(spacing: 10) {
                        Text("Scale: \(Int(modelScale * 1000))%")
                            .font(.custom("Fredoka-Regular", size: 14))
                            .foregroundColor(Color("yellow1"))

                        Slider(value: $modelScale, in: 0.001...0.1)
                            .accentColor(Color("purple1"))
                            .padding(.horizontal)
                    }
                    .padding(.vertical, 10)
                    .background(LinearGradient(
                        gradient: Gradient(colors: [Color("grayNeutral").opacity(0.8), Color("darkNeutral")]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .cornerRadius(15)
                    .shadow(color: Color("lightGrayNeutral").opacity(0.7), radius: 5, x: 0, y: 3)
                    .padding()

                    // Next Item Button
                    Button(action: {
                        modelIndex = (modelIndex + 1) % models.count
                        print("Switched to model index: \(modelIndex)")
                    }) {
                        Text("Next Item")
                            .font(.custom("Fredoka-Bold", size: 18))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("purple1"))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(color: Color("purple1").opacity(0.5), radius: 5, x: 0, y: 3)
                            .padding(.horizontal)
                    }
                    .padding(.bottom, 20)
                }
            }
        }
//        .background(
//            VStack {
//                Image("sushi_place")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: .infinity, height: .infinity)
//                    .clipped()
//                    .ignoresSafeArea()
//                Spacer()
//            },
//            alignment: .top // Aligns the background to the top
//        )
//        .navigationBarBackButtonHidden(true) // Hide the default back button
    }
}

#Preview {
    ARMenuOverlayView(
        models: ["croissant", "baguette", "dish_2"],
        menuItems: [
            MenuItem(name: "Croissant", price: "$3.50", ingredients: "Flour, Butter, Sugar"),
            MenuItem(name: "Baguette", price: "$2.00", ingredients: "Flour, Water, Yeast"),
            MenuItem(name: "Dish 2", price: "$12.00", ingredients: "Beef, Sauce, Spices")
        ]
    )
}



#Preview {
    ARMenuOverlayView(
        models: ["croissant", "baguette", "dish_2"],
        menuItems: [
            MenuItem(name: "Croissant", price: "$3.50", ingredients: "Flour, Butter, Sugar"),
            MenuItem(name: "Baguette", price: "$2.00", ingredients: "Flour, Water, Yeast"),
            MenuItem(name: "Dish 2", price: "$12.00", ingredients: "Beef, Sauce, Spices")
        ]
    )
}
