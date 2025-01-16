//
//  ProfileCollectionView.swift
//  iBite
//
//  Created by Eslam on 16/01/2025.
//

import SwiftUI

struct CollectionView: View {
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
        //GridItem(.flexible(), spacing: 10)
    ]
    
    let colors: [Color] = (0..<30).map { _ in
        Color(red: Double.random(in: 0...1),
              green: Double.random(in: 0...1),
              blue: Double.random(in: 0...1))
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach((0..<30), id: \.self) { _ in
                Rectangle()
                    .foregroundColor(.primary)
                    .frame(height: 100)
                    .overlay(
                        Text("Coming Soon!")
                            .foregroundColor(.white)
                    )
//                ZStack {
//                    Text("Coming Soon!")
//                }
                    .background(Color.primary)
            }
        }
        .padding(.top, 20)
        .padding(.horizontal)
        .background(Color("darkNeutral"))
    }
}
