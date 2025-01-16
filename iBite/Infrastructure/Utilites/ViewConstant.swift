//
//  ViewConstant.swift
//  iBite
//
//  Created by Eslam on 14/01/2025.
//

import UIKit

struct ViewConstant {
    enum ButtonCorners: CGFloat {
        case small
        case normal
        case large
        var corner: CGFloat {
            switch self {
            case .small:
                return 4
            case .normal:
                return 6
            case .large:
                return 10
            }
        }
    }
    static let buttonHeight: CGFloat = 50
    static let fieldSapcing: CGFloat = 16
    static let fieldCornerRaduis: CGFloat = 4
}


struct InputFieldConstants {
    static let fieldSapcing: CGFloat = 16
    static let fieldCornerRaduis: CGFloat = 4
    static let containerBackground: UIColor = .systemBackground
}
