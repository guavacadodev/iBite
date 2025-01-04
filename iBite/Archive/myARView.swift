////
////  myARView.swift
////  iBite
////
////  Created by Jake Woodall on 11/21/24.
////
//
//import SwiftUI
//import ARKit
//import RealityKit
//import Combine
//
//
//// A SwiftUI View wrapper for ARView
//struct myARView: UIViewRepresentable {
//    var models: [String]
//    var menuItems: [MenuItem]
//    @Binding var modelIndex: Int
//    @Binding var modelScale: Float // Bind the scale value from the slider
//    
//    // This function creates and returns the ARView
//    func makeUIView(context: Context) -> ARView {
//        let arView = ARView(frame: .zero)
//        
//        // Configure the AR session with a world tracking configuration
//        let configuration = ARWorldTrackingConfiguration()
//        configuration.planeDetection = [.horizontal] // Detect horizontal planes only
//        configuration.environmentTexturing = .automatic // Enable realistic environment texturing
//        arView.session.run(configuration) // Start the AR session with this configuration
//        
//        // Add a coaching overlay to help users find planes
//        let coachingOverlay = ARCoachingOverlayView()
//        coachingOverlay.session = arView.session
//        coachingOverlay.goal = .horizontalPlane // Encourage finding horizontal planes
//        coachingOverlay.activatesAutomatically = true
//        arView.addSubview(coachingOverlay)
//        
//        // Add gesture recognizer for placing models
//        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
//        arView.addGestureRecognizer(tapGesture)
//        
//        return arView
//    }
//    
//    // This function updates the ARView when the SwiftUI state changes
//    func updateUIView(_ uiView: ARView, context: Context) {
//        // No state-driven updates in this simple example
//    }
//    
//    // Make a coordinator to handle UIKit events
//    func makeCoordinator() -> Coordinator {
//        return Coordinator()
//    }
//    
//    // Coordinator class to handle gestures and interactions
//    class Coordinator: NSObject {
//        // Handle tap gestures to place a model
//        @objc func handleTap(_ sender: UITapGestureRecognizer) {
//            guard let arView = sender.view as? ARView else { return }
//            
//            // Get the touch location in the ARView
//            let location = sender.location(in: arView)
//            
//            // Perform a raycast to find a plane at the touch location
//            let results = arView.raycast(from: location, allowing: .existingPlaneGeometry, alignment: .horizontal)
//            if let firstResult = results.first {
//                // Create an anchor at the raycast result
//                let anchor = AnchorEntity(world: firstResult.worldTransform)
//                
//                // Load a .usdz model
//                if let modelEntity = try? Entity.load(named: "exampleModel") { // Replace with your .usdz file name
//                    anchor.addChild(modelEntity) // Attach the model to the anchor
//                    arView.scene.addAnchor(anchor) // Add the anchor to the AR scene
//                } else {
//                    print("Failed to load model.")
//                }
//            }
//        }
//    }
//}
//
//// A SwiftUI View to use the ARView
//struct myARView1: View {
//    var body: some View {
//        // Embed the ARView in a SwiftUI view
//        myARView()
//            .edgesIgnoringSafeArea(.all) // Make ARView take up the full screen
//    }
//}
//
//// Preview for the SwiftUI View
//#Preview {
//    myARView1()
//}

