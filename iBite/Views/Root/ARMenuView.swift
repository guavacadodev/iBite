//
//  ARMenuView.swift
//  iBite
//
//  Created by Jake Woodall on 10/29/24.
//

import SwiftUI
import ARKit
import RealityKit
import Combine

// Struct for holding menu item information
struct MenuItem {
    let name: String
    let price: String
    let ingredients: String
}

struct ARMenuView: UIViewRepresentable {
    var models: [String]
    var menuItems: [MenuItem]
    @Binding var modelIndex: Int
    @Binding var detectedQRName: String?
    @Binding var modelScale: Float // Bind the scale value from the slider

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.session.delegate = context.coordinator
        setupARSession(with: arView)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        if let detectedName = detectedQRName {
            uiView.scene.anchors.removeAll() // Clear previous anchors
            addARContent(for: detectedName, to: uiView, coordinator: context.coordinator)
        }
        
        // Update model scale if modelEntity is set in the coordinator
        if let modelEntity = context.coordinator.modelEntity {
            modelEntity.scale = SIMD3<Float>(repeating: modelScale)
        }
    }

    private func setupARSession(with arView: ARView) {
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "QRImages", bundle: nil) else {
            print("Failed to load reference images from QRImages")
            return
        }

        let config = ARImageTrackingConfiguration()
        config.trackingImages = referenceImages
        config.maximumNumberOfTrackedImages = 1

        arView.session.run(config)
    }

    private func addARContent(for qrCodeName: String, to arView: ARView, coordinator: Coordinator) {
        guard modelIndex < models.count else { return }
        let modelName = models[modelIndex]
        print("Attempting to load model: \(modelName)")

        // Try loading the model entity
        ModelEntity.loadAsync(named: modelName)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Failed to load model as ModelEntity: \(modelName) - \(error.localizedDescription)")
                    // Try loading it as a generic Entity instead
                    Entity.loadAsync(named: modelName)
                        .sink(receiveCompletion: { completion in
                            if case let .failure(error) = completion {
                                print("Failed to load model as Entity: \(modelName) - \(error.localizedDescription)")
                            }
                        }, receiveValue: { entity in
                            // Add the generic Entity to the AR scene
                            self.addEntityToScene(entity: entity, qrCodeName: qrCodeName, arView: arView, coordinator: coordinator)
                        })
                        .store(in: &coordinator.cancellables)
                }
            }, receiveValue: { modelEntity in
                // If loading as ModelEntity succeeds, add it to the scene
                self.addEntityToScene(entity: modelEntity, qrCodeName: qrCodeName, arView: arView, coordinator: coordinator)
            })
            .store(in: &coordinator.cancellables)
    }

    private func addEntityToScene(entity: Entity, qrCodeName: String, arView: ARView, coordinator: Coordinator) {
        entity.scale = SIMD3<Float>(modelScale, modelScale, modelScale)
        let anchorEntity = AnchorEntity(.image(group: "QRImages", name: qrCodeName))
        anchorEntity.addChild(entity)
        arView.scene.anchors.append(anchorEntity)

        // If it's a ModelEntity, assign it to the coordinator for scaling adjustments
        if let modelEntity = entity as? ModelEntity {
            coordinator.modelEntity = modelEntity
        }
        print("Successfully loaded and added entity: \(models[modelIndex])")
    }

    class Coordinator: NSObject, ARSessionDelegate {
        var parent: ARMenuView
        var modelEntity: ModelEntity?
        var cancellables = Set<AnyCancellable>()

        init(_ parent: ARMenuView) {
            self.parent = parent
        }

        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            for anchor in anchors {
                guard let imageAnchor = anchor as? ARImageAnchor else { continue }
                let detectedQRName = imageAnchor.referenceImage.name
                print("Detected QR code: \(detectedQRName ?? "Unknown")")

                // Update detectedQRName and refresh the view
                DispatchQueue.main.async {
                    self.parent.detectedQRName = detectedQRName
                }
            }
        }
    }
}

// SwiftUI wrapper to include ARMenuView, Next button, and item details overlay
struct ARMenuContainerView: View {
    var models: [String]
    var menuItems: [MenuItem]
    @Binding var modelIndex: Int
    @State private var detectedQRName: String? // Track the detected QR code name
    @State private var modelScale: Float = 0.05 // Initial scale value for the slider

    var body: some View {
        ZStack {
            ARMenuView(models: models, menuItems: menuItems, modelIndex: $modelIndex, detectedQRName: $detectedQRName, modelScale: $modelScale)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                if let detectedQRName = detectedQRName {
                    // Display overlay with detected QR code's menu item details
                    VStack(alignment: .leading, spacing: 8) {
                        Text(menuItems[modelIndex].name)
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("Price: \(menuItems[modelIndex].price)")
                            .font(.headline)

                        Text("Ingredients: \(menuItems[modelIndex].ingredients)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }

                // Slider to control the model scale
                VStack {
                    Text("Scale: \(Int(modelScale * 100))%")
                        .font(.caption)
                    Slider(value: $modelScale, in: 0.01...1.0)
                        .padding(.horizontal)
                }
                .padding(.bottom, 20)
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
                .padding()

                // Next button
                Button(action: {
                    modelIndex = (modelIndex + 1) % models.count
                }) {
                    Text("Next")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
        }
    }
}














