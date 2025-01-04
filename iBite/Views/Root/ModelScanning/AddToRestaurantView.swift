//
//  AddToRestaurantView.swift
//  iBite
//
//  Created by Jake Woodall on 12/1/24.
//

import SwiftUI

struct AddToRestaurantView: View {
    let model: ModelItem
    @State private var selectedRestaurant: String = ""
    @State private var restaurantList: [String] = ["Restaurant A", "Restaurant B"] // Example data
    @State private var newRestaurantName = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Add \(model.name) to a Restaurant")
                .font(.headline)

            Picker("Select a Restaurant", selection: $selectedRestaurant) {
                ForEach(restaurantList, id: \.self) { restaurant in
                    Text(restaurant)
                }
            }
            .pickerStyle(MenuPickerStyle())

            Text("Or Create a New Restaurant")
                .font(.subheadline)

            TextField("New Restaurant Name", text: $newRestaurantName)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                if !newRestaurantName.isEmpty {
                    restaurantList.append(newRestaurantName)
                    selectedRestaurant = newRestaurantName
                }
                print("\(model.name) added to \(selectedRestaurant)")
            }) {
                Text("Add to Restaurant")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }

            Spacer()
        }
        .padding()
    }
}


