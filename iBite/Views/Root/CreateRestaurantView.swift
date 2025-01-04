//
//  CreateRestaurantView.swift
//  iBite
//
//  Created by Jake Woodall on 1/3/25.
//

import SwiftUI
import CoreLocation

struct CreateRestaurantView: View {
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var location: String = ""
    @State private var cuisine: Cuisines = .American // Default cuisine
    @Binding var myRestaurants: [Restaurant]
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Restaurant Details")) {
                    TextField("Restaurant Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Description", text: $description)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Location", text: $location)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Picker("Cuisine", selection: $cuisine) {
                        ForEach(Cuisines.allCases, id: \ .self) { cuisine in
                            Text(cuisine.rawValue).tag(cuisine)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }

                Button(action: saveRestaurant) {
                    Text("Save Restaurant")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .navigationTitle("Create Restaurant")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func saveRestaurant() {
        guard !name.isEmpty, !location.isEmpty else {
            print("Error: Name and location cannot be empty.")
            return
        }

        let newRestaurant = Restaurant(
            //id: UUID(),
            name: name,
            cuisine: cuisine,
            location: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), // Placeholder for location
            distance: 0.0,
            imageName: "defaultImage",
            models: [],
            menuItems: []
        )
        myRestaurants.append(newRestaurant)
        print("Created Restaurant: \(newRestaurant)")
        presentationMode.wrappedValue.dismiss()
    }
}

struct MyRestaurantsView: View {
    @State private var showCreateRestaurantView: Bool = false
    @State private var myRestaurants: [Restaurant] = []
    var body: some View {
        Button(action: {
            showCreateRestaurantView = true
        }) {
            VStack {
                Image(systemName: "plus.app.fill")
                    .font(.system(size: 40))
                    .foregroundColor(Color("teal1"))
                Text("Create a Restaurant")
                    .font(.custom("Fredoka-Medium", size: 14))
                    .foregroundColor(Color("lightGrayNeutral"))
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color("darkNeutral"))
            .cornerRadius(12)
            .shadow(radius: 5)
            .padding(.horizontal)
        }
        .sheet(isPresented: $showCreateRestaurantView) {
            CreateRestaurantView(myRestaurants: $myRestaurants)
        }
    }
}

struct MyRestaurantsHorizontalSliderView: View {
    @Binding var myRestaurants: [Restaurant]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(myRestaurants, id: \ .id) { restaurant in
                    VStack {
                        Image(restaurant.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .cornerRadius(8)

                        Text(restaurant.name)
                            .font(.custom("Fredoka-Regular", size: 16))
                            .foregroundColor(Color("lightGrayNeutral"))

                        Text(restaurant.cuisine.rawValue)
                            .font(.custom("Fredoka-Regular", size: 14))
                            .foregroundColor(Color("teal1"))
                    }
                    .padding()
                    .background(Color("darkNeutral"))
                    .cornerRadius(12)
                    .shadow(radius: 5)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    CreateRestaurantView(myRestaurants: .constant([]))
}
