//
//  ContentView.swift
//  iBite
//
//  Created by Jake Woodall on 10/25/24.
//

import SwiftUI
import ARKit
import SceneKit
import MapKit

struct ContentView: View {
    @State private var searchText = ""
    @State private var isMapView = false
    @State private var selectedRestaurant: Restaurant?
    @State private var showARMenuView = false
    @State private var modelIndex = 0
    @State private var enteredAddress = ""
    @State private var isAddressEntryPresented = false
    @State private var selectedLocation: CLLocationCoordinate2D?
    @State private var filteredRestaurants: [Restaurant] = []
    @State private var updatedRestaurants: [Restaurant] = [] // Stores restaurants with accurate coordinates
    @State private var searchRadius: Double = 10.0

    @ObservedObject private var locationManager = LocationManager.shared

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    // Location and Search Bar
                    VStack {
                        HStack {
                            Text("My Address: \(enteredAddress.isEmpty ? "Not Added" : enteredAddress)")
                                .font(.caption)
                            Spacer()
                            Button("Change") {
                                isAddressEntryPresented = true
                            }
                            .font(.caption)
                        }
                        .padding(.horizontal)
                        
                        Picker("View Mode", selection: $isMapView) {
                            Text("List").tag(false)
                            Text("Map").tag(true)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                        
                        // Radius slider and display
                        HStack {
                            Text("Radius: \(Int(searchRadius)) miles")
                            Slider(value: $searchRadius, in: 1...50, step: 1)
                                .onChange(of: searchRadius) { _ in
                                    onSelectedLocationChange()
                                }
                        }
                        .padding(.horizontal)
                    }
                    .background(Color.white.opacity(0.9))
                    
                    // Map or List View based on picker
                    if isMapView {
                        VStack {
                            MapView(selectedLocation: $selectedLocation, restaurants: filteredRestaurants)
                                .frame(height: 300)
                            
                            // Dynamically change the text based on the availability of nearby restaurants
                            Text(filteredRestaurants.isEmpty ? "No Featured Restaurants" : "Featured Restaurants")
                                .font(.headline)
                                .padding(.top, 10)
                            
                            if filteredRestaurants.isEmpty {
                                // Show 'no featured restaurants' image if no restaurants are nearby
                                Image("no_featured_restaurants")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                    .padding(.top, 20)
                            } else {
                                // Show restaurant carousel if there are nearby restaurants
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(filteredRestaurants.prefix(5)) { restaurant in
                                            FeaturedRestaurantCardView(restaurant: restaurant)
                                                .frame(width: 300)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    } else {
                        ScrollView {
                            ForEach(filteredRestaurants) { restaurant in
                                RestaurantCardView(restaurant: restaurant)
                                    .onTapGesture {
                                        self.selectedRestaurant = restaurant
                                        self.showARMenuView = true
                                    }
                                    .padding(.horizontal)
                            }
                        }
                    }
                    Spacer()
                }
                
                // NavigationLink to ARMenuContainerView
                if let restaurant = selectedRestaurant {
                    NavigationLink(
                        destination: ARMenuContainerView(
                            models: restaurant.models,
                            menuItems: restaurant.menuItems, // Pass menu items here
                            modelIndex: $modelIndex
                        ),
                        isActive: $showARMenuView
                    ) {
                        EmptyView()
                    }
                }
            }
            .navigationTitle("iBite").navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isAddressEntryPresented) {
                AddressEntryView(enteredAddress: $enteredAddress)
            }
            .onAppear {
                locationManager.requestWhenInUseAuthorization()
                
                // Fetch real locations for all sample restaurants if `updatedRestaurants` is empty
                if updatedRestaurants.isEmpty {
                    for restaurant in sampleRestaurants {
                        fetchRealLocation(for: restaurant) { coordinate in
                            if let coordinate = coordinate {
                                var updatedRestaurant = restaurant
                                updatedRestaurant.location = coordinate
                                updatedRestaurants.append(updatedRestaurant)
                                // Update filtered restaurants once all coordinates are updated
                                if updatedRestaurants.count == sampleRestaurants.count {
                                    onSelectedLocationChange()
                                }
                            }
                        }
                    }
                } else {
                    // Use already populated updatedRestaurants
                    onSelectedLocationChange()
                }
            }
            // Detect location updates and re-filter restaurants as user moves
            .onReceive(locationManager.$userLocation) { newLocation in
                if let location = newLocation?.coordinate {
                    selectedLocation = location
                    onSelectedLocationChange()
                }
            }
            .onChange(of: enteredAddress) { newAddress in
                onEnteredAddressChange(newAddress)
            }
        }
        .preferredColorScheme(.light)
    }
    
    // Geocode address and update selectedLocation
    private func onEnteredAddressChange(_ address: String) {
        guard !address.isEmpty else { return }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location {
                selectedLocation = location.coordinate
                onSelectedLocationChange()
            } else {
                print("Geocoding failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    // Filter restaurants within the selected radius
    private func onSelectedLocationChange() {
        guard let location = selectedLocation else {
            filteredRestaurants = [] // Clear if no location
            return
        }
        
        let userLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        // Use unique updatedRestaurants and filter based on distance
        filteredRestaurants = updatedRestaurants.map { restaurant in
            var updatedRestaurant = restaurant
            let restaurantLocation = CLLocation(latitude: restaurant.location.latitude, longitude: restaurant.location.longitude)
            let distanceInMiles = userLocation.distance(from: restaurantLocation) / 1609.34
            updatedRestaurant.distance = distanceInMiles
            return updatedRestaurant
        }
        .filter { $0.distance <= searchRadius }
    }
}


// MARK: - Extension for fetching real location of restaurants
extension ContentView {
    func fetchRealLocation(for restaurant: Restaurant, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = restaurant.name
        request.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 47.2025, longitude: -121.9915), // Enumclaw general area
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let coordinate = response?.mapItems.first?.placemark.coordinate {
                completion(coordinate)
            } else {
                print("Error finding location for \(restaurant.name): \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }
    }
}

#Preview {
    ContentView()
}









