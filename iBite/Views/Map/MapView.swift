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
    var restaurants: [Restaurant]

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.isUserInteractionEnabled = true

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

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Update the map region and annotations
        if let location = selectedLocation {
            uiView.setRegion(MKCoordinateRegion(
                center: location,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            ), animated: true)
            
//            // Update or add the pin for the selected location
//            uiView.removeAnnotations(uiView.annotations.filter { $0 is MKPointAnnotation && $0.title == "Selected Location" })
//            let selectionAnnotation = MKPointAnnotation()
//            selectionAnnotation.coordinate = location
//            selectionAnnotation.title = "Selected Location"
//            uiView.addAnnotation(selectionAnnotation)
        }
        
        // Update restaurant annotations
        uiView.removeAnnotations(uiView.annotations.filter { $0.title != "Selected Location" })
        let restaurantAnnotations = restaurants.map { restaurant -> MKPointAnnotation in
            let annotation = MKPointAnnotation()
            annotation.title = restaurant.name
            annotation.subtitle = restaurant.cuisine.rawValue
            annotation.coordinate = restaurant.location
            return annotation
        }
        uiView.addAnnotations(restaurantAnnotations)
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
            let locationInView = gesture.location(in: gesture.view)
            if let mapView = gesture.view as? MKMapView {
                let coordinate = mapView.convert(locationInView, toCoordinateFrom: mapView)
                parent.selectedLocation = coordinate
            }
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation.title == "Selected Location" {
                let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "selectionPin")
                pinView.pinTintColor = .red
                pinView.isDraggable = true
                return pinView
            }
            return nil
        }
    }
}



