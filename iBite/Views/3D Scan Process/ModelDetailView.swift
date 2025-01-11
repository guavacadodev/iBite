//
//  ModelDetailView.swift
//  iBite
//
//  Created by Jake Woodall on 12/1/24.
//

import SwiftUI

struct ModelDetailView: View {
    let model: ModelItem
    @Environment(\.presentationMode) var presentationMode
    @State private var showAddToRestaurant = false

    var body: some View {
        NavigationView {
            VStack {
                Model3DView(modelURL: model.url)
                    .frame(height: 300)
                    .padding()

                VStack(alignment: .leading, spacing: 10) {
                    Text("Name: \(model.name)")
                        .font(.title2)
                    Text("Price: \(model.price)")
                    Text("Ingredients: \(model.ingredients)")
                        .font(.body)
                        .multilineTextAlignment(.leading)
                }
                .padding()

                Spacer()

                Button(action: {
                    showAddToRestaurant = true
                }) {
                    Text("Add to Restaurant")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .sheet(isPresented: $showAddToRestaurant) {
                    AddToRestaurantView(model: model)
                }
            }
            .navigationBarTitle("Model Details", displayMode: .inline)
            .navigationBarItems(leading: Button("Back") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}



