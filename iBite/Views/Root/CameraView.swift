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
    func makeUIView(context: Context) -> ARSCNView {
        let sceneView = ARSCNView()
        sceneView.session.run(ARWorldTrackingConfiguration())
        sceneView.automaticallyUpdatesLighting = true
        return sceneView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {
        // No updates needed for this example
    }
}


#Preview {
    CameraView()
}
