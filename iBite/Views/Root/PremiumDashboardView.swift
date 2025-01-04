//
//  PremiumDashboardView.swift
//  iBite
//
//  Created by Jake Woodall on 1/1/25.
//

import SwiftUI

struct PremiumDashboardView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var userIsPremium: Bool // Replace with @Binding if needed
    let navTitleImage = Image("iBiteTransparentBackground")

    var body: some View {
        NavigationView {
            switchView()
                .background(Color("darkNeutral"))
                .navigationBarItems(
                    leading: Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundColor(Color("purple1"))
                            Text("Back")
                                .font(.custom("Fredoka-Regular", size: 16))
                                .foregroundColor(Color("purple1"))
                        }
                    }
                )
        }
    }

    @ViewBuilder
    private func switchView() -> some View {
        if userIsPremium {
            SubscribedDashboardView()
        } else {
            UnsubscribedDashboardView()
        }
    }
}

// Existing Views

struct UnsubscribedDashboardView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()

                // Header Section
                VStack(spacing: 10) {
                    Text("Unlock Premium Features")
                        .font(.custom("Fredoka-Bold", size: 24))
                        .foregroundColor(Color("purple1"))

                    Text("Access exclusive tools for model scanning, restaurant creation, advanced analytics, and more!")
                        .font(.custom("Fredoka-Regular", size: 16))
                        .foregroundColor(Color("lightGrayNeutral"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }

                Spacer()

                // Benefits Section
                VStack(spacing: 15) {
                    HStack(spacing: 15) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 24))
                        Text("Exclusive Model Scanning")
                            .font(.custom("Fredoka-Regular", size: 18))
                            .foregroundColor(Color("whiteNeutral"))
                    }

                    HStack(spacing: 15) {
                        Image(systemName: "chart.bar.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 24))
                        Text("Advanced Analytics")
                            .font(.custom("Fredoka-Regular", size: 18))
                            .foregroundColor(Color("whiteNeutral"))
                    }

                    HStack(spacing: 15) {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.purple)
                            .font(.system(size: 24))
                        Text("Priority Support")
                            .font(.custom("Fredoka-Regular", size: 18))
                            .foregroundColor(Color("whiteNeutral"))
                    }
                }

                Spacer()

                // Purchase Section
                VStack(spacing: 20) {
                    Text("Subscribe for only $2.99/month")
                        .font(.custom("Fredoka-Bold", size: 20))
                        .foregroundColor(Color("purple1"))

                    Button(action: {
                        // Add subscription logic here
                        print("Purchase premium subscription")
                    }) {
                        Text("Upgrade to Premium")
                            .font(.custom("Fredoka-Bold", size: 18))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("teal1"))
                            .foregroundColor(Color("whiteNeutral"))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .overlay( // Add the teal2 outline
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("teal2"), lineWidth: 2)
                                )
                    }
                }
                .padding(.horizontal, 20)

                Spacer()

                // Footer Section
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Not Now")
                        .font(.custom("Fredoka-Regular", size: 16))
                        .foregroundColor(Color("lightGrayNeutral"))
                }
            }
            .background(Color("darkNeutral"))
//            .navigationBarItems(
//                leading: Button(action: {
//                    presentationMode.wrappedValue.dismiss()
//                }) {
//                    HStack {
//                        Image(systemName: "chevron.left")
//                            .foregroundColor(Color("purple1"))
//                        Text("Back")
//                            .font(.custom("Fredoka-Regular", size: 16))
//                            .foregroundColor(Color("purple1"))
//                    }
//                }
//            )
        }
    }
}


struct SubscribedDashboardView: View {
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
                        Image("profilePlaceholder") // Replace with the actual profile image
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

                        HStack {
                            Button(action: {
                                print("Create a Restaurant")
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
                            }

                            Button(action: {
                                print("Access Photogrammetry View")
                            }) {
                                VStack {
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(Color("teal1"))
                                    Text("Photogrammetry Tools")
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
                    }
                    .padding(.horizontal)

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


