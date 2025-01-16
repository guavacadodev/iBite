//
//  HeaderView.swift
//  iBite
//
//  Created by Eslam on 16/01/2025.
//

import SwiftUI

struct HeaderView: View {
    @ObservedObject var viewModel: UserViewModel
    var offset: CGFloat
    var isUsersOwnProfile: Bool // Pass the binding value here
    @State private var isMenuPresented: Bool = false
    @State private var navigateToEditProfile = false

    var body: some View {
        VStack {
            // Profile Icon
            Image("profile_image")
                .resizable()
                .clipShape(Circle())
                .frame(width: 100, height: 100)
                .scaleEffect(offset < -60 ? 0.5 : 1.2)
                .padding(.top, offset < -20 ? 0 : -40)
                .shadow(radius: 10)
                .animation(.easeInOut, value: offset)

            HStack(spacing: 12) {
                ZStack {
                    Rectangle()
                        .cornerRadius(8)
                        .frame(width: 100, height: 40)
                        .foregroundColor(Color("whiteNeutral"))
                    HStack(spacing: nil) {
                        Text(viewModel.user.followers.description)
                            .font(.custom("Fredoka-Regular", size: 14))
                        Image(systemName: "person.fill")
                    }
                }
                
                ZStack {
                    Rectangle()
                        .cornerRadius(8)
                        .frame(width: 100, height: 40)
                        .foregroundColor(Color("whiteNeutral"))
                    HStack(spacing: nil) {
                        Text(viewModel.user.following.description)
                            .font(.custom("Fredoka-Regular", size: 14))
                        Image(systemName: "person.fill")
                    }
                }

                // Conditionally display the add button
                if !isUsersOwnProfile {
                    ZStack {
                        Rectangle()
                            .cornerRadius(10)
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color("red1"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("red2"), lineWidth: 2)
                            )
                        Image(systemName: "plus.square.fill")
                            .foregroundColor(Color("whiteNeutral"))
                    }
                    .onTapGesture {
                        isMenuPresented.toggle()
                    }
                    .popover(isPresented: $isMenuPresented) {
                        VStack(alignment: .leading, spacing: 16) {
                            // Menu Items
                            ForEach(socialAccounts.allCases, id: \.self) { method in
                                Button(action: {
                                    method.itemTapped()
                                }) {
                                    HStack {
                                        ZStack {
                                            Circle()
                                                .frame(width: 70, height: 70)
                                                .foregroundColor(.black)
                                            Circle()
                                                .frame(width: 60, height: 60)
                                                .foregroundColor(.white)
                                            Image(method.iconName)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 40, height: 40)
                                                .foregroundColor(.black)
                                        }
                                        Text(method.rawValue)
                                            .foregroundColor(.primary)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding()
                        .background(Color("whiteNeutral"))
                        .preferredColorScheme(.light)
                        .cornerRadius(12)
                        .shadow(radius: 10)
                    }
                    .background(Color("darkNeutral"))
                    .preferredColorScheme(.light)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            if isUsersOwnProfile {
//                NavigationLink(destination: EditProfileView(user: user, userName: user.username, bithdate: user.birthday.description)) {
//                    Text("Edit Profile")
//                        .foregroundColor(.darkNeutral)
//                        .padding(.vertical, 6)
//                        .padding(.horizontal, 60)
//                        .background(Color.teal1)
//                        .cornerRadius(8)
//                }
                
                Text("Edit Profile")
                    .foregroundColor(.darkNeutral)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 60)
                    .background(Color.teal1)
                    .cornerRadius(8)
                    .onTapGesture(perform: {
                        navigateToEditProfile = true
                    })
                .sheet(isPresented: $navigateToEditProfile) {
                    EditProfileView(viewModel: viewModel)
                }
                
                //.background(Color.violet1)
            }

            Text("Just a coder navigating the labyrinth of SwiftUI. \nI love building beautiful and functional apps!")
                .font(.footnote)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .frame(maxWidth: UIScreen.main.bounds.width - 40) // Constrain to screen width with padding
                .padding(.horizontal, 16)
                .foregroundColor(Color("whiteNeutral"))
        }
    }
}
