//
//  CameraView.swift
//  iBite
//
//  Created by Jake Woodall on 10/29/24.
//

import SwiftUI
import ARKit
import UIKit

struct CameraView: UIViewRepresentable {
    @Binding var capturePoints: [SCNNode] // Tracks 3D models

    func makeUIView(context: Context) -> ARSCNView {
        let sceneView = ARSCNView()
        sceneView.delegate = context.coordinator // Use Coordinator for AR interactions
        sceneView.scene = SCNScene() // Initialize with an empty scene
        sceneView.session.run(ARWorldTrackingConfiguration()) // Start AR session
        sceneView.automaticallyUpdatesLighting = true // Adjust lighting automatically
        return sceneView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self, capturePoints: $capturePoints)
    }

    class Coordinator: NSObject, ARSCNViewDelegate {
        var parent: CameraView
        @Binding var capturePoints: [SCNNode]

        init(_ parent: CameraView, capturePoints: Binding<[SCNNode]>) {
            self.parent = parent
            self._capturePoints = capturePoints
        }

        func addModelAtCamera(sceneView: ARSCNView) {
            guard let currentFrame = sceneView.session.currentFrame else {
                print("Failed to get current AR frame")
                return
            }

            // Load the USDZ Model
            guard let modelScene = SCNScene(named: "phone_outline.usdz"),
                  let modelNode = modelScene.rootNode.childNodes.first else {
                print("Failed to load phone_outline.usdz model")
                return
            }

            // Extract the camera transform
            let cameraTransform = currentFrame.camera.transform

            // Calculate the position in front of the camera
            let forwardVector = SCNVector3(
                -cameraTransform.columns.2.x,
                -cameraTransform.columns.2.y,
                -cameraTransform.columns.2.z
            )
            let cameraPosition = SCNVector3(
                cameraTransform.columns.3.x,
                cameraTransform.columns.3.y,
                cameraTransform.columns.3.z
            )
            let modelPosition = SCNVector3(
                cameraPosition.x + forwardVector.x / 2, // 0.5 meters backward
                cameraPosition.y + forwardVector.y / 0.5,
                cameraPosition.z + forwardVector.z * 0.5
            )
            modelNode.position = modelPosition

            // Scale the model appropriately
            modelNode.scale = SCNVector3(0.01, 0.01, 0.01)

            // Add the model to the scene
            sceneView.scene.rootNode.addChildNode(modelNode)

            // Append the model node to capturePoints
            capturePoints.append(modelNode)

            print("Model added at position: \(modelNode.position), forward vector: \(forwardVector)")
        }
    }
}







