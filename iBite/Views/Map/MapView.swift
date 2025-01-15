//
//  MapView.swift
//  iBite
//
//  Created by Jake Woodall on 10/29/24.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var selectedLocation: CLLocationCoordinate2D?
    @Binding var selectedRestaurant: Restaurant?
    var restaurants: [Restaurant]

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        if let location = selectedLocation {
            mapView.setRegion(MKCoordinateRegion(
                center: location,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            ), animated: false)
        }

        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTapGesture(_:)))
        mapView.addGestureRecognizer(tapGesture)
        
        return mapView
    }
    
//    func updateUIView(_ uiView: MKMapView, context: Context) {
//        if let location = selectedLocation {
//            uiView.setRegion(MKCoordinateRegion(
//                center: location,
//                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//            ), animated: true)
//        }
//        // Remove existing annotations
//        uiView.removeAnnotations(uiView.annotations)
//
//        // Add annotations for the restaurants
//        let annotations = restaurants.map { restaurant -> RestaurantAnnotation in
//            RestaurantAnnotation(
//                restaurant: restaurant,
//                coordinate: restaurant.location
//            )
//        }
//        uiView.addAnnotations(annotations)
//
//        // Highlight the marker for the selected restaurant
//        if let selectedRestaurant = selectedRestaurant {
//            if let annotation = annotations.first(where: { $0.restaurant.id == selectedRestaurant.id }) {
//               // uiView.selectAnnotation(annotation, animated: true)
//            }
//        }
//    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Update the map's region based on the selected restaurant or location
        if let selectedRestaurant = selectedRestaurant {
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: selectedRestaurant.location.latitude, longitude: selectedRestaurant.location.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            )
            uiView.setRegion(region, animated: true)
        } else if let location = selectedLocation {
            let region = MKCoordinateRegion(
                center: location,
                span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)//0.05
            )
            uiView.setRegion(region, animated: true)
        }

        // Remove existing annotations
        uiView.removeAnnotations(uiView.annotations)
        
        // Add annotations for the restaurants
        let annotations = restaurants.map { restaurant -> RestaurantAnnotation in
            RestaurantAnnotation(
                restaurant: restaurant,
                coordinate: CLLocationCoordinate2D(latitude: restaurant.location.latitude, longitude: restaurant.location.longitude)
            )
        }
        uiView.addAnnotations(annotations)
        
        // Highlight the marker for the selected restaurant
        if let selectedRestaurant = selectedRestaurant {
            if let annotation = annotations.first(where: { $0.restaurant.id == selectedRestaurant.id }) {
                //uiView.selectAnnotation(annotation, animated: true)
            }
        }
    }


    func makeCoordinator() -> Coordinator {
        return Coordinator(self, selectedLocation: selectedLocation)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var selectedLocation: CLLocationCoordinate2D?
        var parent: MapView
        
        init(_ parent: MapView, selectedLocation: CLLocationCoordinate2D?) {
            self.parent = parent
            self.selectedLocation = selectedLocation
        }

        @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
            let locationInView = gesture.location(in: gesture.view)
            if let mapView = gesture.view as? MKMapView {
                let coordinate = mapView.convert(locationInView, toCoordinateFrom: mapView)
                parent.selectedLocation = coordinate
            }
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let restaurantAnnotation = annotation as? RestaurantAnnotation else {
                return nil
            }
            
            let identifier = "RestaurantAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: restaurantAnnotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.isDraggable = true
            } else {
                annotationView?.annotation = restaurantAnnotation
            }
            
            // Set custom image for the marker
            if parent.selectedRestaurant?.id == restaurantAnnotation.restaurant.id {
                annotationView?.image = UIImage(named: "pinLocation") // Highlighted marker
            } else {
                annotationView?.image = UIImage(named: "pin") // Default marker
            }
            return annotationView
        }
         
    }
}

class RestaurantAnnotation: NSObject, MKAnnotation {
    let restaurant: Restaurant
    let coordinate: CLLocationCoordinate2D

    init(restaurant: Restaurant, coordinate: CLLocationCoordinate2D) {
        self.restaurant = restaurant
        self.coordinate = coordinate
    }

    var title: String? {
        restaurant.name
    }

    var subtitle: String? {
        restaurant.cuisine.rawValue
    }
}

/*
 //        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
 //            if annotation.title == "Selected Location" {
 //                let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "selectionPin")
 //                pinView.pinTintColor = .red
 //                pinView.isDraggable = true
 //
 //                return pinView
 //            }
 //            return nil
 //        }
         // Provide custom annotation views

 
 //    func makeUIView(context: Context) -> MKMapView {
 //        let mapView = MKMapView()
 //        mapView.delegate = context.coordinator
 //        mapView.showsUserLocation = true
 //        mapView.isUserInteractionEnabled = true
 //
 //        if let location = selectedLocation {
 //            mapView.setRegion(MKCoordinateRegion(
 //                center: location,
 //                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
 //            ), animated: false)
 //        }
 //
 //        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTapGesture(_:)))
 //        mapView.addGestureRecognizer(tapGesture)
 //
 //        return mapView
 //    }
 //
 //    func updateUIView(_ uiView: MKMapView, context: Context) {
 //        // Update the map region and annotations
 //        if let location = selectedLocation {
 //            uiView.setRegion(MKCoordinateRegion(
 //                center: location,
 //                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
 //            ), animated: true)
 //
 ////            // Update or add the pin for the selected location
 ////            uiView.removeAnnotations(uiView.annotations.filter { $0 is MKPointAnnotation && $0.title == "Selected Location" })
 ////            let selectionAnnotation = MKPointAnnotation()
 ////            selectionAnnotation.coordinate = location
 ////            selectionAnnotation.title = "Selected Location"
 ////            uiView.addAnnotation(selectionAnnotation)
 //        }
 //
 //        // Update restaurant annotations
 //        uiView.removeAnnotations(uiView.annotations.filter { $0.title != "Selected Location" })
 //        let restaurantAnnotations = restaurants.map { restaurant -> MKPointAnnotation in
 //            let annotation = MKPointAnnotation()
 //            annotation.title = restaurant.name
 //            annotation.subtitle = restaurant.cuisine.rawValue
 //            annotation.coordinate = restaurant.location
 //            return annotation
 //        }
 //        uiView.addAnnotations(restaurantAnnotations)
 //    }
 */
