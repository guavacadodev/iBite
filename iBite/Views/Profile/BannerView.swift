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
            .ignoresSafeArea()
    }
}
