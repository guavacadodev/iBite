//
//  LocationManager.swift
//  iBite
//
//  Created by Jake Woodall on 10/29/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var userLocation: CLLocation? // Store user's current location
    @Published var userAddress: String = "" // Store user's address (default or manual)
    @Published var isManualAddress = false // Track if the address is manually set

    static let shared = LocationManager()
    private let geocoder = CLGeocoder() // For reverse geocoding

    override private init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
    }

    func requestWhenInUseAuthorization() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            print("Location services are not enabled.")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last, !isManualAddress else { return }
        DispatchQueue.main.async {
            self.userLocation = location
            self.reverseGeocode(location)
        }
    }

    private func reverseGeocode(_ location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Error reverse geocoding location: \(error.localizedDescription)")
                return
            }
            if let placemark = placemarks?.first {
                DispatchQueue.main.async {
                    self.userAddress = [placemark.name, placemark.locality, placemark.administrativeArea]
                        .compactMap { $0 }
                        .joined(separator: ", ")
                }
            }
        }
    }

    func setManualAddress(_ address: String) {
        isManualAddress = true
        userAddress = address
        geocodeAddress(address)
    }

    private func geocodeAddress(_ address: String) {
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                print("Error geocoding address: \(error.localizedDescription)")
                return
            }
            if let placemark = placemarks?.first, let location = placemark.location {
                DispatchQueue.main.async {
                    self.userLocation = location
                }
            }
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else if manager.authorizationStatus == .denied {
            print("Location permissions denied.")
        }
    }
}
