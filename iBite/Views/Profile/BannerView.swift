//
//  BannerView.swift
//  iBite
//
//  Created by Eslam on 16/01/2025.
//

import SwiftUI

struct BannerView: View {
    var bannerTitle: String

    var body: some View {
        Rectangle()
            .foregroundColor(Color("purple1"))
            .overlay {
                Text(bannerTitle)
                    .padding(.top, 50)
                    .font(.custom("Fredoka-SemiBold", size: 28))
                    .foregroundColor(.white)
            }
//            .background(
//                HStack() {
//                    Spacer()
////                        Menu {
////                            Button(action: {
////                                navigateToEditProfile = true
////                            }) {
////                                Label("Update Profile", systemImage: "person")
////                            }
////                            Button(action: {
////                                navigateToChangePassword = true
////                            }) {
////                                Label("Change Password", systemImage: "lock")
////                            }
////                            Button(role: .destructive, action: {
////                                print("User signed out!")
////                            }) {
////                                Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.forward")
////                            }
////                        } label: {
////                            Image(systemName: "gearshape")
////                                .foregroundColor(Color.white)
////                                .padding()
////                        }
//                    Button {
//                        //navigateToEditProfile = true
//                        print("gearshape Tapped")
//                    } label: {
//                        Image(systemName: "gearshape")
//                            .foregroundColor(Color.white)
//                    }
//                }
//                    .padding(.horizontal, 16)
//            )
            .ignoresSafeArea()
    }
}
