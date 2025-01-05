//
//  SubscriptionOfferView.swift
//  iBite
//
//  Created by Jake Woodall on 1/4/25.
//

import SwiftUI

struct SubscriptionOfferView: View {
    @State private var selectedPlan: SubscriptionPlan = .annual

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color("purple1"), Color("purple2")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {
                // Header Section
                VStack(spacing: 10) {
                    Image("happymonster")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 120)
                        //.foregroundColor(.white)
                        .padding(.top, 20)

                    Text("Unlock the full iBite Experience")
                        .font(.custom("Fredoka-Bold", size: 24))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    Text("Enjoy exclusive features to enhance your experience!")
                        .font(.custom("Fredoka-Regular", size: 16))
                        .foregroundColor(Color("lightGrayNeutral"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }

                // Features Section
                VStack(alignment: .leading, spacing: 15) {
                    FeatureRow(icon: "checkmark.circle.fill", text: "Create and manage restaurants easily.")
                    FeatureRow(icon: "checkmark.circle.fill", text: "Access advanced analytics.")
                    FeatureRow(icon: "checkmark.circle.fill", text: "Unlock photogrammetry tools.")
                    FeatureRow(icon: "checkmark.circle.fill", text: "Enjoy premium priority support.")
                }
                .padding(.horizontal, 20)

                // Subscription Plans
                VStack(spacing: 10) {
                    PlanOptionView(
                        title: "Monthly",
                        price: "$9.99 / MO",
                        isSelected: selectedPlan == .monthly
                    )
                    .onTapGesture {
                        selectedPlan = .monthly
                    }

                    PlanOptionView(
                        title: "Annual",
                        price: "$5.83 / MO",
                        subtitle: "$69.99 billed yearly",
                        badge: "POPULAR",
                        isSelected: selectedPlan == .annual
                    )
                    .onTapGesture {
                        selectedPlan = .annual
                    }
                }
                .padding(.horizontal, 20)

                // Call-to-Action Button
                Button(action: {
                    print("Subscribe to \(selectedPlan.rawValue) plan")
                }) {
                    Text("Try FREE and Subscribe")
                        .font(.custom("Fredoka-Bold", size: 18))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("yellow1"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal, 20)

                // Footer Section
                Text("7 day trial, then just $69.99 per year\nCancel anytime in the App Store")
                    .font(.custom("Fredoka-Regular", size: 12))
                    .foregroundColor(Color("lightGrayNeutral"))
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)
            }
            .padding(.vertical, 20)
        }
    }
}

// MARK: - Feature Row Component
struct FeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(Color("teal1"))
                .font(.system(size: 20))
                .background(
                    Circle() // Use a circular shape as the background
                        .fill(Color("darkNeutral"))
                        .frame(width: 10, height: 10) // Adjust the size of the circle to fit the icon
                )
            Text(text)
                .font(.custom("Fredoka-Regular", size: 16))
                .foregroundColor(.white)
        }
    }
}

// MARK: - Plan Option View
struct PlanOptionView: View {
    let title: String
    let price: String
    let subtitle: String?
    let badge: String?
    let isSelected: Bool

    init(title: String, price: String, subtitle: String? = nil, badge: String? = nil, isSelected: Bool) {
        self.title = title
        self.price = price
        self.subtitle = subtitle
        self.badge = badge
        self.isSelected = isSelected
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(title)
                    .font(.custom("Fredoka-Bold", size: 18))
                    .foregroundColor(isSelected ? .white : Color("lightGrayNeutral"))

                if let badge = badge {
                    Text(badge)
                        .font(.custom("Fredoka-Medium", size: 12))
                        .padding(5)
                        .background(Color("yellow1"))
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
                Spacer()
            }

            Text(price)
                .font(.custom("Fredoka-Regular", size: 16))
                .foregroundColor(isSelected ? Color("purple2") : Color("lightGrayNeutral"))

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.custom("Fredoka-Light", size: 12))
                    .foregroundColor(isSelected ? Color("purple2") : Color("lightGrayNeutral"))
            }
        }
        .padding()
        .background(
            isSelected
                ? LinearGradient(colors: [Color("teal1"), Color("teal2")], startPoint: .top, endPoint: .bottom)
                : LinearGradient(colors: [Color("grayNeutral"), Color("darkNeutral")], startPoint: .top, endPoint: .bottom)
        )
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color("whiteNeutral") : Color.clear, lineWidth: 2)
        )
        .shadow(radius: isSelected ? 10 : 5)
    }
}

// MARK: - Subscription Plan Enum
enum SubscriptionPlan: String {
    case monthly = "Monthly"
    case annual = "Annual"
}

// MARK: - Preview
struct SubscriptionOfferView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionOfferView()
    }
}

