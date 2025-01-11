//
//  EditRestaurantDetailsView.swift
//  iBite
//
//  Created by Jake Woodall on 1/7/25.
//

import SwiftUI
import CoreLocation

struct EditRestaurantDetailsView: View {
    @Binding var restaurant: Restaurant?

    @State private var localRestaurant: Restaurant? // Local mutable copy

    var body: some View {
        VStack(spacing: 20) {
            if let localRestaurant = localRestaurant {
                Text("Edit Restaurant Details")
                    .font(.title)
                    .padding()

                // Restaurant Details Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Restaurant Details")
                        .font(.custom("Fredoka-Bold", size: 20))
                        .foregroundColor(Color("purple1"))

                    TextField("Name", text: Binding(
                        get: { localRestaurant.name },
                        set: { self.localRestaurant?.name = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    Picker("Cuisine", selection: Binding(
                        get: { localRestaurant.cuisine },
                        set: { self.localRestaurant?.cuisine = $0 }
                    )) {
                        ForEach(Cuisines.allCases, id: \.self) { cuisine in
                            Text(cuisine.rawValue).tag(cuisine)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())

                    TextField("Description", text: Binding(
                        get: { localRestaurant.reviewText ?? "" },
                        set: { self.localRestaurant?.reviewText = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    Picker("Rating", selection: Binding(
                        get: { localRestaurant.rating ?? 0 },
                        set: { self.localRestaurant?.rating = $0 }
                    )) {
                        ForEach(0..<6) { rating in
                            Text("\(rating) Stars").tag(rating)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding()

                Spacer()

                // Save Button
                Button(action: saveChanges) {
                    Text("Save Changes")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("purple1"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            } else {
                Text("No Restaurant Selected")
                    .font(.headline)
            }
        }
        .padding()
        .navigationTitle(restaurant?.name ?? "Edit Restaurant")
        .onAppear {
            // Create a mutable copy of the restaurant on view appear
            self.localRestaurant = restaurant
        }
    }

    private func saveChanges() {
        // Update the binding with the edited values
        restaurant = localRestaurant
    }
}


struct EditRestaurantDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        EditRestaurantDetailsView(restaurant: .constant(Restaurant(
            name: "Sample Restaurant",
            cuisine: .Italian,
            location: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
            distance: 0.0,
            imageName: "defaultImage",
            models: [],
            menuItems: [],
            reviewText: "Great place!",
            rating: 4
        )))
    }
}


//#Preview {
//    EditRestaurantDetailsView(restaurant: <#T##Binding<Restaurant?>#>)
//}
