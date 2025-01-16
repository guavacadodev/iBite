//
//  MainButtonSwiftUI.swift
//  3NK
//
//  Created by Eslam on 02/01/2025.
//

import SwiftUI

struct MainButtonView: View {
    let action: (()->Void)?
    @State var buttonTitle: String
    var body: some View {
        Button {
            action?()
        } label: {
            Text(buttonTitle)
                .foregroundStyle(Color(UIColor.white))
                .font(.system(size: 16, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding()
                .frame(height: 50, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.purple1)
                )
        }
        .background(Color(UIColor.clear))
    }
}

#Preview {
    MainButtonView(action: nil, buttonTitle: "Placeholder")
}
