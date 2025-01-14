//
//  PremiumDashboardView.swift
//  iBite
//
//  Created by Jake Woodall on 1/1/25.
//

import SwiftUI
import CoreLocation

struct PremiumDashboardView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var userIsPremium: Bool // Replace with @Binding if needed
    @State private var isEditingRestaurant = false
    let navTitleImage = Image("iBiteTransparentBackground")

    var body: some View {
        NavigationView {
            switchView()
                .background(Color("darkNeutral"))
                .navigationBarItems(
                    leading: Group {
                        if !isEditingRestaurant { // Only show the back button if not editing
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                HStack {
                                    Image(systemName: "chevron.left")
                                        .foregroundColor(userIsPremium ? Color("purple1") : Color("whiteNeutral"))
                                    Text("Back")
                                        .font(.custom("Fredoka-Regular", size: 16))
                                        .foregroundColor(userIsPremium ? Color("purple1") : Color("whiteNeutral"))
                                }
                            }
                        }
                    }
                )
        }
    }

    // This function is responsible for either displaying the UnsubscribedView or SubscribedView
    @ViewBuilder
    private func switchView() -> some View {
        if userIsPremium {
            SubscribedView(isEditingRestaurant: $isEditingRestaurant)
        } else {
            UnsubscribedView()
        }
    }
}

// MARK: - Displays if the user is not premium
struct UnsubscribedView: View {
    @State private var selectedPlan: SubscriptionPlan = .annual
    @Environment(\.presentationMode) var presentationMode
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
                        .font(.custom("Fredoka-Regular", size: 14))
                        .foregroundColor(Color("darkNeutral"))
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
                        price: "$4.99 / MO",
                        isSelected: selectedPlan == .monthly
                    )
                    .onTapGesture {
                        selectedPlan = .monthly
                    }

                    PlanOptionView(
                        title: "Annual",
                        price: "$4.24 / MO",
                        subtitle: "$50.90 billed yearly",
                        badge: "15 % OFF!",
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
                    Text("Try FREE & Subscribe")
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

// MARK: - Displays if the user is premium
struct SubscribedView: View {
    @State private var showCreateRestaurantView = false
    @State private var myRestaurants: [Restaurant?] = []
    @State var selectedRestaurant: Restaurant?
    @State private var showEditRestaurantView = false
    @Binding var isEditingRestaurant: Bool
    var body: some View {
        
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Section
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Welcome, John Doe!")
                                .font(.custom("Fredoka-Bold", size: 24))
                                .foregroundColor(Color("purple1"))
                            Text("Your Premium Dashboard")
                                .font(.custom("Fredoka-Regular", size: 16))
                                .foregroundColor(Color("lightGrayNeutral"))
                        }
                        Spacer()
                        Image("profile_image") // Replace with the actual profile image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal)
                    Divider().background(Color("lightGrayNeutral"))

                    // Restaurant Management Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Restaurant Management")
                            .font(.custom("Fredoka-Bold", size: 18))
                            .foregroundColor(Color("purple1"))
                        AddRestaurantButtonView(myRestaurants: $myRestaurants)
                    }
                    .padding(.horizontal)
                    Divider().background(Color("lightGrayNeutral"))
                    
                    // Shows the Horizontal Slider of MyRestaurants
                    if !myRestaurants.compactMap({ $0 }).isEmpty {
                        MyRestaurantsHorizontalSliderView(myRestaurants: $myRestaurants)
                            .padding(.horizontal)
                            .onTapGesture {
                                if let firstRestaurant = myRestaurants.compactMap({ $0 }).first {
                                    selectedRestaurant = firstRestaurant
                                    showEditRestaurantView = true
                                    isEditingRestaurant = true //
                                }
                            }
                            .background(
                                NavigationLink(
                                    destination: EditRestaurantDetailsView(
                                        restaurant: $selectedRestaurant
                                    ).onDisappear {
                                        isEditingRestaurant = false
                                    },
                                    isActive: $showEditRestaurantView,
                                    label: { EmptyView() }
                                )
                            )
                    // Shows No Restaurants
                    } else {
                        VStack {
                            Text("No Restaurants Found!")
                                .font(.custom("Fredoka-Regular", size: 18))
                                .padding(.top, 10)
                                .foregroundColor(Color("lightGrayNeutral"))
                            Text("Try Creating One Above")
                                .font(.custom("Fredoka-Light", size: 9))
                                .foregroundColor(Color("lightGrayNeutral"))
                            Image("sadpurplemonster")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 120)
                                .padding(.bottom, 30)
                                .scaleEffect(0.9)
                        }
                    }
                    Divider().background(Color("lightGrayNeutral"))

                    // Analytics Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Analytics Overview")
                            .font(.custom("Fredoka-Bold", size: 18))
                            .foregroundColor(Color("purple1"))

                        VStack {
                            // Example analytics cards
                            HStack {
                                AnalyticsCardView(
                                    title: "Total Clicks",
                                    value: "15,245",
                                    icon: "cursorarrow.click.2",
                                    color: Color("teal1")
                                )
                                AnalyticsCardView(
                                    title: "Daily Visitors",
                                    value: "785",
                                    icon: "person.2.fill",
                                    color: Color("purple1")
                                )
                            }

                            HStack {
                                AnalyticsCardView(
                                    title: "Sales Revenue",
                                    value: "$12,450",
                                    icon: "chart.bar.fill",
                                    color: .green
                                )
                                AnalyticsCardView(
                                    title: "Conversion Rate",
                                    value: "45%",
                                    icon: "percent",
                                    color: .orange
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                    Divider().background(Color("lightGrayNeutral"))

                    // Today's Insights Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Today's Insights")
                            .font(.custom("Fredoka-Bold", size: 18))
                            .foregroundColor(Color("purple1"))

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Meeting Scheduled at 3:00 PM")
                                .font(.custom("Fredoka-Regular", size: 16))
                                .foregroundColor(Color("lightGrayNeutral"))

                            Text("New User Feedback Available")
                                .font(.custom("Fredoka-Regular", size: 16))
                                .foregroundColor(Color("lightGrayNeutral"))
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color("darkNeutral").ignoresSafeArea())
        }
    }
}

// MARK: - AnalyticsCardView Component
struct AnalyticsCardView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundColor(color)
                Spacer()
            }
            .padding(.bottom, 5)

            HStack {
                Text(title)
                    .font(.custom("Fredoka-Regular", size: 14))
                    .foregroundColor(Color("lightGrayNeutral"))
                Spacer()
            }

            HStack {
                Text(value)
                    .font(.custom("Fredoka-Bold", size: 22))
                    .foregroundColor(color)
                Spacer()
            }
        }
        .padding()
        .background(Color("darkNeutral"))
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}



//// Preview
//struct PremiumDashboardView_Previews: PreviewProvider {
//    static var previews: some View {
//        PremiumDashboardView(userIsPremium: Bool)
//    }
//}



