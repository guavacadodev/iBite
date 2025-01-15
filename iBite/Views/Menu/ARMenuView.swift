//
//  ARVMenuiew.swift
//  iBite
//
//  Created by Jake Woodall on 11/21/24.
//

import SwiftUI
import ARKit
import RealityKit

struct ARMenuView: UIViewRepresentable {
    var models: [String] // Array of model names
    var menuItems: [MenuItem] // Array of MenuItems
    @Binding var modelIndex: Int // Track the current model index
    @Binding var modelScale: Float // This value is actually from the ARMenuContentView

    // Creates an AR Session and places the model
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // Configure the AR session
        let config = ARWorldTrackingConfiguration()
        arView.session.run(config)
        
        // Automatically load and place the initial model
        loadModel(into: arView, withName: models[modelIndex])
        
        return arView
    }

    // loads models from the modelIndex into the AR view
    func updateUIView(_ uiView: ARView, context: Context) {
        // Clear any existing models when modelIndex changes
        uiView.scene.anchors.removeAll()
        loadModel(into: uiView, withName: models[modelIndex])
    }

    // This function loads the models from the models array variable above and puts it into the arView session.
    private func loadModel(into arView: ARView, withName modelName: String) {
        guard let modelEntity = try? ModelEntity.load(named: modelName) else {
            print("Failed to load model: \(modelName)")
            return
        }
        
        // This code scales the placed model by the modelScale value which is 0.05 ( determined by the @State property in ARMenuContentView )
        modelEntity.scale = SIMD3<Float>(modelScale, modelScale, modelScale)

        // Creates an anchor 0.5 meters in front of the camera (along the -Z axis) and attaches the 3D model to it. ( ATTACHES MODEL TO ANCHOR )
        let cameraAnchor = AnchorEntity(world: [0, 0, -0.5])
        cameraAnchor.addChild(modelEntity)
        
        // Attaches the anchor and the model to the AR scene.
        arView.scene.anchors.append(cameraAnchor)
    }
}












