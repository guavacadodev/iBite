//
//  StickyTabView.swift
//  iBite
//
//  Created by Eslam on 16/01/2025.
//

import SwiftUI

struct StickyTabView: View {
    @Binding var selectedTab: Int // Bind to parent state

    var body: some View {
        VStack {
            HStack {
                ForEach(0..<3) { index in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = index
                        }
                    }) {
                        VStack(spacing: 4) {
                            Text(tabTitle(for: index))
                                .foregroundColor(selectedTab == index ? Color("purple2") : Color("lightGrayNeutral").opacity(0.5))
                                .font(.custom("Fredoka-Medium", size: 16))

                            if selectedTab == index {
                                Capsule()
                                    .frame(height: 3)
                                    .foregroundColor(Color("purple2"))
                                    .transition(.scale)
                            } else {
                                Capsule()
                                    .frame(height: 3)
                                    .foregroundColor(Color("lightGrayNeutral").opacity(0.5))
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 48)
        .background(Color("grayNeutral"))
        .overlay(
            Divider()
                .background(Color("lightGrayNeutral")),
            alignment: .top
        )
    }

    private func tabTitle(for index: Int) -> String {
        switch index {
        case 0: return "Reviews"
        case 1: return "Favorites"
        case 2: return "Collection"
        default: return ""
        }
    }
}

