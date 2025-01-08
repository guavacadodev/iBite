//
//  MyRestaurantsHorizontalSliderView.swift
//  iBite
//
//  Created by Jake Woodall on 1/7/25.
//

import SwiftUI

struct MyRestaurantsHorizontalSliderView: View {
    @Binding var myRestaurants: [Restaurant?]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(myRestaurants.compactMap { $0 }, id: \.id) { restaurant in
                    VStack {
                        if let imagePath = getSavedImagePath(for: restaurant.imageName),
                           let uiImage = UIImage(contentsOfFile: imagePath) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .cornerRadius(8)
                        } else {
                            Image("defaultImage")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .cornerRadius(8)
                        }

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

    // Helper function to get the full path of the saved image
    private func getSavedImagePath(for fileName: String) -> String? {
        let filePath = FileManager.default.temporaryDirectory.appendingPathComponent(fileName).path
        return FileManager.default.fileExists(atPath: filePath) ? filePath : nil
    }
}

#Preview {
    MyRestaurantsHorizontalSliderView(myRestaurants: .constant([]))
}
