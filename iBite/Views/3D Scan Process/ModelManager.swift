//
//  ModelManager.swift
//  iBite
//
//  Created by Jake Woodall on 12/1/24.
//

import Foundation
import SwiftUI

class ModelManager: ObservableObject {
    @Published var models: [ModelItem] = []
}
