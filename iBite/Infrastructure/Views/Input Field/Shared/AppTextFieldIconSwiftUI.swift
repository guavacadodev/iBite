//
//  AppTextFieldIconSwiftUI.swift
//  3NK
//
//  Created by Eslam on 06/01/2025.
//

import SwiftUI

extension Image {
    init(fromUIImage uiImage: UIImage) {
        self.init(uiImage: uiImage)
    }
}

struct AppTextFieldIconSwiftUI: View {
    var iconField: UIImage?
    var body: some View {
        if let iconField = iconField {
            Image(fromUIImage: iconField)
            .resizable()
            .foregroundStyle(.gray)
            .frame(width: 30, height: 30)
        }
    }
}

//#Preview {
//    AppTextFieldIconSwiftUI()
//}
