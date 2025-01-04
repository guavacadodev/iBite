//
//  BottomNavigationBar.swift
//  iBite
//
//  Created by Jake Woodall on 11/9/24.
//

import SwiftUI

struct BottomNavigationBar: View {
    @State private var showProfileAndUploadSelection: Bool = false
    @Binding var userIsPremium: Bool
    @Binding var isUsersOwnProfile: Bool
    @Binding var selectedTab: Int
    @Binding var showingPremiumDashboard: Bool // Bind to MainView
    //@Binding var showingPhotogrammetryView: Bool // Bind to MainView's state
    
    var body: some View {
        ZStack {
            // BottomNavigationBar
            HStack {
                // Left Tab
                Button(action: {
                    self.selectedTab = 1
                }) {
                    Image(systemName: "house.fill") // Home icon
                        .font(.title)
                }
                .foregroundColor(selectedTab == 1 ? .yellow : .gray)
                
                Spacer()
                
                // Middle (Photogrammetry) Tab
                Button(action: {
                    self.selectedTab = 3
                }) {
                    Image(systemName: "magnifyingglass.circle.fill")
                        .font(.title)
                }
                .foregroundColor(selectedTab == 3 ? .yellow : .gray)
                
                Spacer()
                
                // Right Tab (Profile)
                Button(action: {
                    withAnimation {
                        showProfileAndUploadSelection.toggle()
                    }
                }) {
                    Image(systemName: "person.fill") // Profile icon
                        .font(.title)
                }
                .foregroundColor(selectedTab == 2 ? .yellow : .gray)
            }
            .padding()
            .background(
                BlurView(style: .systemUltraThinMaterial, color: Color("darkNeutral")) // Add blur for modern transparency
                    .cornerRadius(10) // Optional: Add corner radius for rounded effect
                    .shadow(radius: 2) // Optional: Add shadow for elevation
            )
            .zIndex(0) // Ensure it remains below the popup content
            
            // Popup Content
            if showProfileAndUploadSelection {
                VStack(spacing: 16) {
                    Button(action: {
                        isUsersOwnProfile.toggle()
                        selectedTab = 2
                        withAnimation { showProfileAndUploadSelection = false }
                    }) {
                        HStack(spacing: 3) {
                            Text("Profile")
                                .font(.custom("Fredoka-Medium", size: 14))
                                .foregroundColor(.white)
                            Image(systemName: "person.fill")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("teal1"))
                        .cornerRadius(8)
                        .overlay( // Add the teal2 outline
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("teal2"), lineWidth: 2))
                    }

                    Button(action: {
                        if userIsPremium {
                            print("Navigate to Premium Dashboard")
                            showingPremiumDashboard = true
                        } else {
                            print("Show Upgrade to Premium")
                            showingPremiumDashboard = true
                            withAnimation { showProfileAndUploadSelection = false }
                        }
                    }) {
                        HStack(spacing: 3) {
                            Text(userIsPremium ? "Premium Dashboard" : "Get Premium")
                                .font(.custom("Fredoka-Medium", size: 14))
                                .foregroundColor(.white)
                            Image(systemName: userIsPremium ? "star.fill" : "checkmark.shield.fill")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(userIsPremium ? Color("red1") : Color("purple1"))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(userIsPremium ? Color("red2") : Color("purple2"), lineWidth: 2)
                        )
                    }
                }
                .padding()
                .background(Color("grayNeutral"))
                .cornerRadius(12)
                .shadow(radius: 10)
                .transition(.move(edge: .bottom)) // Slide-in animation
                .zIndex(1) // Ensure it appears above the navigation bar
            }
        }
        .overlay( // Add the outline with dynamic color
            RoundedRectangle(cornerRadius: 11)
                .stroke(Color("lightGrayNeutral"), lineWidth: 3)
        .animation(.easeInOut, value: showProfileAndUploadSelection) // Smooth animation
        .fullScreenCover(isPresented: $showingPremiumDashboard) {
            PremiumDashboardView(userIsPremium: $userIsPremium)
        })
    }
}


// Helper View for Blur Effect
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    var color: Color

    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        
        // Add color overlay
        let colorView = UIView()
        colorView.backgroundColor = UIColor(color)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.alpha = 0.9 // Adjust opacity as needed
        
        view.contentView.addSubview(colorView)
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: view.contentView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: view.contentView.trailingAnchor),
            colorView.topAnchor.constraint(equalTo: view.contentView.topAnchor),
            colorView.bottomAnchor.constraint(equalTo: view.contentView.bottomAnchor)
        ])
        
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
        if let colorView = uiView.contentView.subviews.first as? UIView {
            colorView.backgroundColor = UIColor(color)
        }
    }
}


//#Preview {
//    StatefulPreviewWrapper((selectedTab: 1, showingPhotogrammetryView: false)) { state in
//        BottomNavigationBar(
//            selectedTab: state.selectedTab,
//            showingPhotogrammetryView: state.showingPhotogrammetryView
//        )
//        .previewLayout(.sizeThatFits)
//        .padding()
//    }
//}


// Helper to create a dynamic preview environment with @State
struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State private var value: Value
    private var content: (Binding<Value>) -> Content

    init(_ initialValue: Value, @ViewBuilder content: @escaping (Binding<Value>) -> Content) {
        _value = State(initialValue: initialValue)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}
