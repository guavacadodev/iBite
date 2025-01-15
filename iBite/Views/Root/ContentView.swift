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

let cuisineFilters: [(name: String, icon: String)] = [
    ("All", "globe"),
    ("Italian", "fork.knife"),
    ("Mexican", "carrot"),
    ("American", "waterbottle.fill")
]

struct ContentView: View {
    @State private var navTitleImage = Image("iBiteTransparentBackground")
    @State private var searchText = "" // Used for user input to search content
    @State private var isMapView = false // Variable that determines whether the MapView is displayed or not
    @State private var selectedRestaurant: Restaurant? //variable that tracks whether user has selected a restaurant. Can be true false or nil
    @State private var showARMenuView = false // variable to toggle display of ARMenuView
    @Binding var showingARView: Bool // Binds to the MainView showingARView variable to track whether or not the ARMenuView is showing. If this variable is true, the BottomNavigationBar gets pushed down, as stated in the MainView. It means that the showingARView is showing.

    // Other state variables and ObservedObject
    @State private var selectedCuisine: String? = "All"
    @State private var modelIndex = 0 // tracks the index of the model for the restaurants
    @State private var enteredAddress = ""
    @State private var isAddressEntryPresented = false
    @State private var selectedLocation: CLLocationCoordinate2D? // selectedLocation variable that presents a coordinate
    @State private var filteredRestaurants: [Restaurant] = [] // filteredRestaurants variable that updates the array based on the user's radius
    @State private var updatedRestaurants: [Restaurant] = [] // Stores restaurants with accurate coordinates
    @State private var searchRadius: Double = 10.0
    @State private var userHasLikedRestaurant: Bool = false
    @ObservedObject private var locationManager = LocationManager.shared

    private func isCardVisible(geo: GeometryProxy) -> Bool {
          // We want to detect if the center of the card is within the bounds of the screen
          let cardMidX = geo.frame(in: .global).midX
          let screenWidth = UIScreen.main.bounds.width
          return cardMidX > 50 && cardMidX < screenWidth - 50 // Adjust with some margin for a more stable experience
      }
    
    var body: some View {
        NavigationView {
            // -- Main UI -- //
            ZStack {
                // Base UI code for all elements of this screen:
                VStack {
                    // Location, List & Map Picker, Radius Slider //
                    VStack {
                        // My address text with change button
                        HStack {
                            Text("My Address: ")
                                .font(.custom("Fredoka-SemiBold", size: 12))
                                .foregroundColor(Color("whiteNeutral")) +
                            Text(locationManager.userAddress.isEmpty ? "Not Added" : locationManager.userAddress)
                                .font(.custom("Fredoka-Regular", size: 12))
                                .foregroundColor(Color("lightGrayNeutral"))
                            Spacer()
                            // MARK: - Update Address Entry Button here @Eslam //
//                            Button("Change") {
//                                isAddressEntryPresented = true
//                            }
//                            .font(.custom("Fredoka-Bold", size: 9))
//                            .padding(.horizontal, 14) // Add padding around the text
//                            .padding(.vertical, 5)
//                            .background(Color("teal1"))
//                            .foregroundColor(Color("whiteNeutral"))
//                            .cornerRadius(10)
//                            .shadow(radius: 5)
//                            .overlay( // Add the teal2 outline
//                                RoundedRectangle(cornerRadius: 8)
//                                    .stroke(Color("teal2"), lineWidth: 2)
//                            )
//                            //.shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 5) // Add a shadow for depth
//                            .scaleEffect(isAddressEntryPresented ? 1.1 : 1.0) // Add scale animation
//                            .animation(.easeInOut(duration: 0.2), value: isAddressEntryPresented) // Smooth animation
//                            
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .onTapGesture {
                            isAddressEntryPresented = true
                        }
                        // list and map picker
                        HStack {
                            Button(action: { isMapView = false }) {
                                Text("List")
                                    .frame(maxWidth: .infinity)
                                    .font(.custom("Fredoka-Bold", size: 24))
                                    .padding()
                                    .background(isMapView ? Color("grayNeutral").opacity(0.4) : Color("purple1"))
                                    .foregroundColor(isMapView ? Color("lightGrayNeutral").opacity(0.4) : Color("whiteNeutral"))
                                    .cornerRadius(8)
                                    .overlay( // Add the outline with dynamic color
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(isMapView ? Color("lightGrayNeutral").opacity(0.4) : Color("purple2"), lineWidth: 2)
                                    )
                            }
                            
                            Button(action: { isMapView = true }) {
                                Text("Map")
                                    .frame(maxWidth: .infinity)
                                    .font(.custom("Fredoka-Bold", size: 24))
                                    .padding()
                                    .background(isMapView ? Color("purple1") : Color("grayNeutral").opacity(0.4))
                                    .foregroundColor(isMapView ? Color("whiteNeutral") : Color("lightGrayNeutral").opacity(0.4))
                                    .cornerRadius(8)
                                    .overlay( // Add the outline with dynamic color
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(isMapView ? Color("purple2") : Color("lightGrayNeutral").opacity(0.4), lineWidth: 2)
                                    )
                            }
                        }
                        .padding(.horizontal)
                        // Radius slider and display
                        HStack {
                            Text("Radius: ")
                                .font(.custom("Fredoka-SemiBold", size: 12))
                                .foregroundColor(Color("whiteNeutral")) +
                            Text("\(Int(searchRadius)) miles")
                                .font(.custom("Fredoka-Regular", size: 12))
                                .foregroundColor(Color("lightGrayNeutral"))
                            
                            Slider(value: $searchRadius, in: 1...50, step: 1)
                                .tint(Color("yellow1")) // Change the slider bar color to yellow
                                .onChange(of: searchRadius) { _ in
                                    onSelectedLocationChange()
                                }
                        }
                        .padding(.horizontal)
                    }
                    .background(Color("darkNeutral"))
                    // Picker content for either List or Map. If the selection is on MapView, then execute the if statement, else execute the content in the else statement for the List picker.
//                    if isMapView {
//                        // Map View VStack with optional Featured Restaurants carousel and No Featured Restaurant content.
//                        VStack {
//
//                            MapView(selectedLocation: $selectedLocation, selectedRestaurant: self.$selectedRestaurant, restaurants: filteredRestaurants)
//                            Text(filteredRestaurants.isEmpty ? "No Results Found" : "Featured Restaurants")
//                                .padding(.top, 20)
//                            
//                            
//                                .frame(height: 300)
//                            // If there are no featured restaurants within the user's radius, show the "No Featured Restaurants" text otherwise, default to "Featured Restaurants"
//                            Text(filteredRestaurants.isEmpty ? "No Results!" : "Featured Restaurants")
//                                .font(.custom("Fredoka-Regular", size: 18))
//                                .padding(.top, 10)
//                                .foregroundColor(Color("lightGrayNeutral"))
//                            Text(filteredRestaurants.isEmpty ? "Try Updating Your Address" : "")
//                                .font(.custom("Fredoka-Light", size: 9))
//                                .foregroundColor(Color("lightGrayNeutral"))
//                            // This code displays the purple monster below the "No Featured Restaurants" text in the scenario there are no restaurants nearby.
//                            if filteredRestaurants.isEmpty {
//                                Image("sadpurplemonster")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(height: 120)
//                                    .padding(.top, 20)
//                                // This else statement will show nearby restaurants in the form of a slideable horizontal carousel in the case that there are restaurants near the user's location.
//                            } else {
//                                ScrollView(.horizontal, showsIndicators: false) {
//                                    HStack(spacing: 16) {
//                                        ForEach(filteredRestaurants.prefix(5)) { restaurant in
//                                            FeaturedRestaurantCardView(restaurant: restaurant)
//                                                .frame(width: 250)
//                                                .onTapGesture {
//                                                    self.selectedRestaurant = restaurant
//                                                    self.showARMenuView = true
//                                                }
//                                        }
//                                    }
//                                    .padding()
//                                }
//                                .scaleEffect(0.9)
//                            }
//                        }
                    if isMapView {
                                            // Map View VStack with optional Featured Restaurants carousel and No Featured Restaurant content.
                                            VStack {
                                                //MapView(selectedLocation: $selectedLocation, restaurants: filteredRestaurants)
                                                MapView(selectedLocation: $selectedLocation, selectedRestaurant: self.$selectedRestaurant, restaurants: filteredRestaurants)
                                                    .frame(height: 300)
                                                // If there are no featured restaurants within the user's radius, show the "No Featured Restaurants" text otherwise, default to "Featured Restaurants"
                                                Text(filteredRestaurants.isEmpty ? "No Results Found" : "Featured Restaurants")
                                                    .font(.custom("Fredoka-Regular", size: 18))
                                                    .padding(.top, 10)
                                                    .foregroundColor(Color("lightGrayNeutral"))
                                                Text(filteredRestaurants.isEmpty ? "Try Updating Your Address" : "")
                                                    .font(.custom("Fredoka-Light", size: 9))
                                                    .foregroundColor(Color("lightGrayNeutral"))
                                                // This code displays the purple monster below the "No Featured Restaurants" text in the scenario there are no restaurants nearby.
                                                if filteredRestaurants.isEmpty {
                                                    Image("sadpurplemonster")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(height: 120)
                                                        .padding(.top, 20)
                                                // This else statement will show nearby restaurants in the form of a slideable horizontal carousel in the case that there are restaurants near the user's location.
                                                } else {
                    //                                ScrollView(.horizontal, showsIndicators: false) {
                    //                                    HStack(spacing: 16) {
                    //                                        ForEach(filteredRestaurants.prefix(5)) { restaurant in
                    //                                            FeaturedRestaurantCardView(restaurant: restaurant)
                    //                                                .frame(width: 250)
                    //                                                .onTapGesture {
                    //                                                    self.selectedRestaurant = restaurant
                    //                                                   // self.showARMenuView = true
                    //                                                }
                    //                                        }
                    //                                    }
                    //                                    .padding(.horizontal)
                    //                                }
                                                    ScrollView(.horizontal, showsIndicators: false) {
                                                        HStack(spacing: 16) {
                                                            ForEach(filteredRestaurants.prefix(5)) { restaurant in
                                                                FeaturedRestaurantCardView(restaurant: restaurant)
                                                                    .frame(width: 250)
                                                                FeaturedRestaurantCardView(restaurant: restaurant, dynamicWidth: UIScreen.main.bounds.width - 50)
                                                                    .frame(width: UIScreen.main.bounds.width - 50)
                                                                    .background(GeometryReader { geo in
                                                                        Color.clear
                                                                            .onAppear {
                                                                                // Detect if the restaurant card is in view (position)
                                                                                if geo.frame(in: .global).minX >= 0 && geo.frame(in: .global).minX <= UIScreen.main.bounds.width {
                                                                                    self.selectedRestaurant = restaurant
                                                                                }
                                                                            }
                                                                            .onChange(of: geo.frame(in: .global)) { newFrame in
                                                                                // Detect if the restaurant card is still in view (position)
                                                                                //DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                                                                                    if newFrame.minX >= 0 && newFrame.minX <= UIScreen.main.bounds.width {
                                                                                        self.selectedRestaurant = restaurant
                                                                                    }
                                                                                //}

                                                                            }
                    //                                                        .onAppear {
                    //                                                            // Detect when the restaurant card is centered
                    //                                                            if isCardVisible(geo: geo) {
                    //                                                                self.selectedRestaurant = restaurant
                    //                                                            }
                    //                                                        }
                    //                                                        .onChange(of: geo.frame(in: .global)) { newFrame in
                    //                                                            // Detect when the restaurant card is centered during scrolling
                    //                                                            if isCardVisible(geo: geo) {
                    //                                                                self.selectedRestaurant = restaurant
                    //                                                            }
                    //                                                        }
                                                                    })
                                                                    .onTapGesture {
                                                                        self.selectedRestaurant = restaurant
                                                                        self.showARMenuView = true
                                                                        //self.selectedRestaurant = restaurant
                                                                         self.showARMenuView = true
                                                                    }
                                                            }
                                                        }
                                                        .padding(.horizontal)
                                                    }

                                                }
                                            }
                        // Content for the list tab.
                    } else {
                        ZStack {
                            ScrollView {
                                VStack {
                                    // CUISINE FILTER
                                    HStack(spacing: 10) {
                                        ForEach(cuisineFilters, id: \.name) { filter in
                                            Button(action: {
                                                // Update the selected cuisine
                                                selectedCuisine = filter.name
                                                updateFilteredRestaurants()
                                            }) {
                                                VStack {
                                                    Image(systemName: filter.icon) // Add SF Symbol
                                                        .font(.system(size: 20))
                                                        .foregroundColor(selectedCuisine == filter.name ? .white : .black)
                                                    Text(filter.name)
                                                        .font(.custom("Fredoka-Regular", size: 14))
                                                        .foregroundColor(selectedCuisine == filter.name ? .white : .black)
                                                }
                                                .padding(8)
                                                .background(selectedCuisine == filter.name ? Color("purple1") : Color.gray.opacity(0.2))
                                                .cornerRadius(8)
                                                .overlay( // Add the outline with dynamic color
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .stroke(selectedCuisine == filter.name ? Color("purple2") : Color.gray.opacity(0.4), lineWidth: 2)
                                                )
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                    .frame(height: 100)
                                    if filteredRestaurants.isEmpty {
                                        // Display "No Results Found" text and sadpurplemonster image
                                        VStack {
                                            Text("No Results!")
                                                .font(.custom("Fredoka-Regular", size: 18))
                                                .foregroundColor(Color("lightGrayNeutral"))
                                            Text("Try Updating Your Address")
                                                .font(.custom("Fredoka-Light", size: 9))
                                                .foregroundColor(Color("lightGrayNeutral"))
                                            Image("sadpurplemonster")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 125)
                                                .padding(.top, 20)
                                        }
                                    } else {
                                        // Display LIST content
                                        ScrollView {
                                            VStack {
                                                ScrollView {
                                                    VStack {
                                                        Divider().background(Color("lightGrayNeutral"))
                                                        //POPULAR CATEGORY
                                                        ScrollView {
                                                            HStack(spacing: 3) {
                                                                //Spacer()
                                                                Image(systemName: "star.fill")
                                                                //.padding(.leading, 15)
                                                                    .font(.custom("Fredoka-SemiBold", size: 24))
                                                                    .foregroundColor(Color("orange1"))
                                                                    .overlay(
                                                                        Image(systemName: "star")
                                                                            .font(.custom("Fredoka-SemiBold", size: 24))
                                                                            .foregroundColor(Color("yellow1"))
                                                                    )
                                                                Text("Popular")
                                                                //.padding(.leading, 15)
                                                                    .font(.custom("Fredoka-Medium", size: 24))
                                                                    .foregroundColor(Color("yellow1"))
                                                                Image(systemName: "star.fill")
                                                                //.padding(.leading, 15)
                                                                    .font(.custom("Fredoka-SemiBold", size: 24))
                                                                    .foregroundColor(Color("orange1"))
                                                                    .overlay(
                                                                        Image(systemName: "star")
                                                                            .font(.custom("Fredoka-SemiBold", size: 24))
                                                                            .foregroundColor(Color("yellow1"))
                                                                    )
                                                                //Spacer()
                                                            }
                                                            .padding(.leading, 15)
                                                            ScrollView(.horizontal, showsIndicators: false) {
                                                                HStack(spacing: 16) {
                                                                    ForEach(filteredRestaurants.prefix(5)) { restaurant in
                                                                        FeaturedRestaurantCardView(restaurant: restaurant)
                                                                            .frame(width: 250)
                                                                            .onTapGesture {
                                                                                self.selectedRestaurant = restaurant
                                                                                self.showARMenuView = true
                                                                            }
                                                                    }
                                                                }
                                                                .padding()
                                                            }
                                                        }
                                                        //MARK: - Jack code -
//                                                        Divider().background(Color("lightGrayNeutral"))
//                                                        //NEAR YOU CATEGORY
//                                                        HStack {
//                                                            Text("Near You")
//                                                                .padding(.leading, 15)
//                                                                .font(.custom("Fredoka-Medium", size: 24))
//                                                                .foregroundColor(Color("whiteNeutral"))
//                                                            Spacer()
//                                                        }
//                                                        ScrollView {
//                                                            ForEach(filteredRestaurants) { restaurant in
//                                                                RestaurantCardView(restaurant: restaurant, userHasLikedRestaurant: $userHasLikedRestaurant)
//                                                                    .onTapGesture {
//                                                                        self.selectedRestaurant = restaurant
//                                                                        self.showARMenuView = true
//                                                                    }
//                                                                    .padding(.horizontal)
//                                                            }
//                                                        }
//                                                        Divider().background(Color("lightGrayNeutral"))
                                                        HStack {
                                                            Text("Near You")
                                                                .padding(.leading, 15)
                                                                .font(.custom("Fredoka-Medium", size: 24))
                                                                .foregroundColor(Color("whiteNeutral"))
                                                            Spacer()
                                                        }
                                                        ScrollView {
                                                            ForEach(filteredRestaurants.indices, id: \.self) { index in
                                                                let restaurant = filteredRestaurants[index]
                                                                RestaurantCardView(restaurant: restaurant, isFavorite: restaurant.favorite, onClickFavoriteButton: {
                                                                    filteredRestaurants[index].favorite.toggle()
                                                                    UserDefaults.favoriteResturants = []
                                                                    let favoriteRestaurants = filteredRestaurants.filter { $0.favorite }
                                                                    UserDefaults.favoriteResturants = favoriteRestaurants
                                                                })
                                                                .onTapGesture {
                                                                    self.selectedRestaurant = restaurant
                                                                    self.showARMenuView = true
                                                                }
                                                                .padding(.horizontal)
                                                            }
                                                        }
                                                        Divider().background(Color("lightGrayNeutral"))
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .background(Color("darkNeutral"))
                // If the user selects a restaurant from the List tab, capture it in the restaurant variable.
                // Then pass the associated models and menuItems of the selected restaurant to the ARMenuOverlayView.
                if let restaurant = selectedRestaurant {
                    NavigationLink(
                        destination: CombinedMenuView(
                            models: restaurant.models,
                            menuItems: restaurant.menuItems,
                            showingARView: $showingARView
                        )
                        .onAppear {
                            // Set the binding showingARView to true to render the BottomNavigationBar invisible.
                            showingARView = true
                        }
                            .onDisappear {
                                // Set it back to false when the user exits, so that the BottomNavigationBar reappears.
                                showingARView = false
                            },
                        isActive: $showARMenuView
                    ) {
                        EmptyView()
                    }
                }
            }
            //.navigationTitle("iBite").navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: navTitleImage.resizable().frame(width: 80, height: 80).offset(x: 140))
            // Address Entry View Pop Up
            .sheet(isPresented: $isAddressEntryPresented) {
                AddressEntryView(enteredAddress: Binding(
                    get: { locationManager.userAddress },
                    set: {
                        locationManager.setManualAddress($0)
                        updateLocationFromManualInput()
                    }
                ))
            }
            .onAppear {
                locationManager.requestWhenInUseAuthorization()
                // Fetch real locations for all sample restaurants if `updatedRestaurants` is empty
                if updatedRestaurants.isEmpty {
                    for restaurant in sampleRestaurants {
                        fetchRealLocation(for: restaurant) { coordinate in
                            if let coordinate = coordinate {
                                var updatedRestaurant = restaurant
                                updatedRestaurant.location = Coordinate(coordinate)
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
        }
        .preferredColorScheme(.light)
    }
    
    // Function to update the filtered restaurants
    private func updateFilteredRestaurants() {
        if selectedCuisine == "All" {
            
            if UserDefaults.favoriteResturants.isEmpty {
                filteredRestaurants = sampleRestaurants // Show all cuisines
            } else {
                print("UserDefaults.favoriteResturants: \(UserDefaults.favoriteResturants)")

                var combinedRestaurants: [Restaurant] = []

                // Step 1: Take favorites from UserDefaults
                let favoriteRestaurantIds = Set(UserDefaults.favoriteResturants.map { $0.name })
                var favoriteRestaurants = sampleRestaurants.filter { favoriteRestaurantIds.contains($0.name) }

                // Ensure these restaurants are marked as favorites
                for index in favoriteRestaurants.indices {
                    if let userFavorite = UserDefaults.favoriteResturants.first(where: { $0.name == favoriteRestaurants[index].name }) {
                        favoriteRestaurants[index].favorite = userFavorite.favorite
                    }
                }
                
                print("favoriteResturantsAFterForEach: \(favoriteRestaurants)")

                combinedRestaurants.append(contentsOf: favoriteRestaurants)

                // Step 2: Append the rest of the sample restaurants that are not in UserDefaults favorites
                let nonFavoriteRestaurants = sampleRestaurants.filter { !favoriteRestaurantIds.contains($0.name) }
                combinedRestaurants.append(contentsOf: nonFavoriteRestaurants)

                // Step 3: Set the combined list as filteredRestaurants
                filteredRestaurants = combinedRestaurants
            }
        } else {
            filteredRestaurants = sampleRestaurants.filter { $0.cuisine.rawValue == selectedCuisine }
        }
    }
    
    // Changes location based on manual input
    private func updateLocationFromManualInput() {
        guard let location = locationManager.userLocation?.coordinate else { return }
        selectedLocation = location
        onSelectedLocationChange()
    }
    
    // Loads restaurants locations based on location
    private func loadRestaurantLocations() {
        if updatedRestaurants.isEmpty {
            for restaurant in sampleRestaurants {
                fetchRealLocation(for: restaurant) { coordinate in
                    if let coordinate = coordinate {
                        var updatedRestaurant = restaurant
                        updatedRestaurant.location = Coordinate(coordinate)
                        updatedRestaurants.append(updatedRestaurant)
                        if updatedRestaurants.count == sampleRestaurants.count {
                            onSelectedLocationChange()
                        }
                    }
                }
            }
        } else {
            onSelectedLocationChange()
        }
    }
    
    // Restaurant filter within a selected radius of user's location
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
    
    // Converts string address into geo coordinates & updates apps location
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










