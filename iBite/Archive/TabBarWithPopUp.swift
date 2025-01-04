////
////  TabBarWithPopUp.swift
////  iBite
////
////  Created by Jake Woodall on 12/28/24.
////
//
//import SwiftUI
//
//struct TabBarWithPopup: View {
//    @State private var showPopup = false // State to toggle the popup
//    @State private var selectedTab: Int = 0
//
//    var body: some View {
//        VStack {
//            Spacer() // Your main content goes here
//            
//            HStack {
//                Spacer()
//
//                // Profile Button with Pop-up Animation
//                Button(action: {
//                    withAnimation {
//                        showPopup.toggle() // Toggle the pop-up
//                    }
//                }) {
//                    Image(systemName: "person.fill") // Profile icon
//                        .font(.title)
//                        .padding()
//                        .foregroundColor(.yellow)
//                }
//
//                Spacer()
//            }
//            .frame(height: 50)
//            .background(Color.black)
//            .cornerRadius(10)
//            .padding()
//
//            // Popup VStack for Profile & Upload options
//            if showPopup {
//                VStack(spacing: 16) {
//                    Button(action: {
//                        // Navigate to Profile
//                        selectedTab = 2
//                        withAnimation { showPopup = false }
//                    }) {
//                        Text("Go to Profile")
//                            .font(.custom("Fredoka-Regular", size: 14))
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color("teal2"))
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }
//
//                    Button(action: {
//                        // Navigate to Upload
//                        // Add upload functionality here
//                        withAnimation { showPopup = false }
//                    }) {
//                        Text("Upload")
//                            .font(.custom("Fredoka-Regular", size: 14))
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color("red1"))
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }
//                }
//                .padding()
//                .background(Color.white)
//                .cornerRadius(12)
//                .shadow(radius: 10)
//                .transition(.move(edge: .bottom)) // Slide-in animation
//                .zIndex(1) // Ensure the popup appears above other content
//            }
//        }
//        .edgesIgnoringSafeArea(.bottom)
//    }
//}
//
//
//#Preview {
//    TabBarWithPopup()
//}
