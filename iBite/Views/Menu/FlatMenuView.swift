//
//  FlatMenuView.swift
//  iBite
//
//  Created by Jake Woodall on 1/14/25.
//

import SwiftUI

// FlatMenuView example
struct FlatMenuView: View {
    var menuItems: [MenuItem]

    var body: some View {
        List(menuItems, id: \.name) { menuItem in
            VStack(alignment: .leading, spacing: 8) {
                Text(menuItem.name)
                    .font(.headline)
                Text(menuItem.ingredients)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(menuItem.price)
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            .padding()
        }
    }
}
