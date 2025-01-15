//
//  propertyWrapper.swift
//  iBite
//
//  Created by Eslam on 11/01/2025.
//

import Foundation

@propertyWrapper
struct ValueDefault<Value> {
    
    let key: String
    let defaultValue: Value
    let container: UserDefaults = .standard
    
    var wrappedValue: Value {
        get {
            return container.value(forKey: key) as? Value ?? defaultValue
        }
        set {
            container.setValue(newValue, forKey: key)
        }
    }
}

@propertyWrapper
struct ModelsDefault<Model: Codable> {
    let key: String
    let defaultValue: Model
    let container: UserDefaults = .standard
    
    var wrappedValue: Model {
        get {
            let decoder = JSONDecoder()
            guard let decoded = container.object(forKey: key) as? Data else {return defaultValue}
            let loadedValue = try? decoder.decode(Model.self, from: decoded)
            return loadedValue ?? defaultValue
        }
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                container.set(encoded, forKey: key)
                container.synchronize()
            }
        }
    }
}

//@propertyWrapper
//struct ModelsDefaultAray<Model: Codable> {
//    let key: String
//    let defaultValue: Model
//    let container: UserDefaults = .standard
//    
//    var wrappedValue: Model {
//        get {
//            guard let data = container.data(forKey: key) else {
//                return defaultValue
//            }
//            
//            do {
//                let decoder = JSONDecoder()
//                return try decoder.decode(Model.self, from: data)
//            } catch {
//                print("Decoding error for key '\(key)': \(error)")
//                return defaultValue
//            }
//        }
//        set {
//            do {
//                let encoder = JSONEncoder()
//                let data = try encoder.encode(newValue)
//                container.set(data, forKey: key)
//                container.synchronize()
//            } catch {
//                print("Encoding error for key '\(key)': \(error)")
//            }
//        }
//    }
//}
