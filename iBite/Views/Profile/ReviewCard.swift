//
//  ReviewCard.swift
//  iBite
//
//  Created by Eslam on 16/01/2025.
//

import SwiftUI

struct ReviewCard: View {
    let review: Review

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Display restaurant details
            HStack {
                Image(review.restaurantName.imageName)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading) {
                    Text(review.restaurantName.name)
                        .font(.headline)
                        .foregroundColor(Color("purple2"))
                    Text("\(review.restaurantName.cuisine.rawValue) • \(String(format: "%.1f", review.restaurantName.distance)) mi")
                        .font(.subheadline)
                        .foregroundColor(Color("lightGrayNeutral"))
                }

                Spacer()

                // Display star rating
                HStack(spacing: 2) {
                    ForEach(0..<5) { starIndex in
                        Image(systemName: starIndex < review.rating ? "star.fill" : "star")
                            .foregroundColor(starIndex < review.rating ? Color("teal1") : Color.gray)
                            .font(.system(size: 14))
                    }
                }
            }

            // Display review text
            Text(review.reviewText)
                .font(.body)
                .foregroundColor(Color("lightGrayNeutral"))

            Divider()
                .background(Color("grayNeutral"))
        }
        .padding()
        .background(Color("yellow1"))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
