//
//  EditRestaurantDetailsView.swift
//  iBite
//
//  Created by Jake Woodall on 1/7/25.
//

import SwiftUI

struct EditRestaurantDetailsView: View {
    @Binding var restaurant: Restaurant?

    var body: some View {
        VStack(spacing: 20) {
            if let restaurant = restaurant {
                Text("Edit Restaurant Details")
                    .font(.title)
                    .padding()

                // Edit form content here
            } else {
                Text("No Restaurant Selected")
                    .font(.headline)
            }
        }
        .padding()
        .navigationTitle(restaurant?.name ?? "Edit Restaurant")
    }
}

//#Preview {
//    EditRestaurantDetailsView(restaurant: <#T##Binding<Restaurant?>#>)
//}
