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
        ZStack {
            Color("darkNeutral").ignoresSafeArea()

            VStack(spacing: 20) {
                if let localRestaurant = localRestaurant {
                    Text("Edit \(localRestaurant.name)")
                        .font(.custom("Fredoka-Bold", size: 24))
                        .foregroundColor(Color("purple1"))
                        .padding()

                    VStack(alignment: .leading, spacing: 15) {
                        Text("Restaurant Details")
                            .font(.custom("Fredoka-Bold", size: 20))
                            .foregroundColor(Color("teal1"))

                        TextField("Name", text: Binding(
                            get: { localRestaurant.name },
                            set: { self.localRestaurant?.name = $0 }
                        ))
                        .customTextFieldStyle(isEmpty: localRestaurant.name.isEmpty)

                        VStack(alignment: .leading, spacing: 5) {
                            Text("Cuisine")
                                .font(.custom("Fredoka-Regular", size: 16))
                                .foregroundColor(Color("lightGrayNeutral"))

                            Picker("Cuisine", selection: Binding(
                                get: { localRestaurant.cuisine },
                                set: { self.localRestaurant?.cuisine = $0 }
                            )) {
                                ForEach(Cuisines.allCases, id: \.self) { cuisine in
                                    Text(cuisine.rawValue).tag(cuisine)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .background(Color("grayNeutral"))
                            .cornerRadius(8)
                        }

                        TextField("Description", text: Binding(
                            get: { localRestaurant.reviewText ?? "" },
                            set: { self.localRestaurant?.reviewText = $0 }
                        ))
                        .customTextFieldStyle(isEmpty: localRestaurant.reviewText?.isEmpty ?? true)

                        VStack(alignment: .leading, spacing: 5) {
                            Text("Rating")
                                .font(.custom("Fredoka-Regular", size: 16))
                                .foregroundColor(Color("lightGrayNeutral"))

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
                    }
                    .padding()
                    .background(Color("grayNeutral"))
                    .cornerRadius(12)
                    .shadow(radius: 5)

                    Spacer()

                    // Photo and 3D Scan Buttons
                    HStack(spacing: 20) {
                        // display PhotoCaptureView()
                        Button(action: {
                            print("Take A Photo")
                        }) {
                            VStack {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(Color("teal1"))
                                Text("Take a Photo")
                                    .font(.custom("Fredoka-Medium", size: 14))
                                    .foregroundColor(Color("lightGrayNeutral"))
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("darkNeutral"))
                            .cornerRadius(12)
                            .shadow(radius: 5)
                        }

                        // 3D Scan
                        Button(action: {
                            // display PhotogrammetryView()
                        }) {
                            VStack {
                                Image(systemName: "camera.viewfinder")
                                    .font(.system(size: 40))
                                    .foregroundColor(Color("teal1"))
                                Text("3D Scan")
                                    .font(.custom("Fredoka-Medium", size: 14))
                                    .foregroundColor(Color("lightGrayNeutral"))
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("darkNeutral"))
                            .cornerRadius(12)
                            .shadow(radius: 5)
                        }
                    }
                    .padding(.horizontal)

                    // Save Button
                    Button(action: saveChanges) {
                        Text("Save Changes")
                            .font(.custom("Fredoka-Bold", size: 18))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("purple1"))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                } else {
                    Text("No Restaurant Selected")
                        .font(.custom("Fredoka-SemiBold", size: 18))
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
        .onAppear {
            self.localRestaurant = restaurant
        }
    }

    private func saveChanges() {
        restaurant = localRestaurant
    }
}





//#Preview {
//    EditRestaurantDetailsView(restaurant: <#T##Binding<Restaurant?>#>)
//}
