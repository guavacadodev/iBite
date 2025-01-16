//
//  UserViewModel.swift
//  iBite
//
//  Created by Eslam on 16/01/2025.
//

import Foundation
import Combine

class UserViewModel: ObservableObject {
    @Published var user: UserModel {
        didSet {
            UserDefaults.user = user // Save to UserDefaults whenever updated
        }
    }

    init(user: UserModel) {
        self.user = user
    }
}
