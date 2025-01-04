////
////  ARMenuView.swift
////  iBite
////
////  Created by Jake Woodall on 10/29/24.
////
//
//import SwiftUI
//import ARKit
//import RealityKit
//import Combine
//
//struct ARMenuView: UIViewRepresentable {
//    var models: [String]
//    var menuItems: [MenuItem]
//    @Binding var modelIndex: Int
//    @Binding var modelScale: Float // Bind the scale value from the slider
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(self)
//    }
//
//    func makeUIView(context: Context) -> ARView {
//        let arView = ARView(frame: .zero)
//        arView.session.delegate = context.coordinator
//        setupARSession(for: arView)
//
//        // Add tap gesture recognizer
//        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
//        arView.addGestureRecognizer(tapGesture)
//
//        return arView
//    }
//
//    func updateUIView(_ uiView: ARView, context: Context) {
//        // Update the scale of the loaded model
//        if let modelEntity = context.coordinator.modelEntity {
//            modelEntity.scale = SIMD3<Float>(repeating: modelScale)
//        }
//    }
//
//    private func setupARSession(for arView: ARView) {
//        let config = ARWorldTrackingConfiguration()
//        config.planeDetection = [.horizontal] // Enable horizontal plane detection
//        config.environmentTexturing = .automatic // Enhance visuals with realistic lighting
//        arView.session.run(config)
//    }
//
//    class Coordinator: NSObject, ARSessionDelegate {
//        var parent: ARMenuView
//        var modelEntity: ModelEntity?
//        var cancellables = Set<AnyCancellable>()
//        
//        init(_ parent: ARMenuView) {
//            self.parent = parent
//        }
//        
//        @objc func handleTap(_ sender: UITapGestureRecognizer) {
//            guard let arView = sender.view as? ARView else { return }
//            let location = sender.location(in: arView)
//            
//            // Perform a raycast to find a plane where the user tapped
//            if let raycastResult = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal).first {
//                let transform = Transform(matrix: raycastResult.worldTransform)
//                addModel(to: transform, in: arView)
//            } else {
//                print("Raycast did not hit any surface.")
//            }
//        }
//        
//        private func addModel(to transform: Transform, in arView: ARView) {
//            guard parent.modelIndex < parent.models.count else {
//                print("Model index out of range.")
//                return
//            }
//            let modelName = parent.models[parent.modelIndex]
//            print("Attempting to load model: \(modelName)")
//            
//            // Load the 3D model asynchronously
//            ModelEntity.loadAsync(named: modelName)
//                .sink(receiveCompletion: { completion in
//                    if case let .failure(error) = completion {
//                        print("Failed to load model \(modelName): \(error.localizedDescription)")
//                        // Attempt to load the entity as a generic Entity
//                        Entity.loadAsync(named: modelName)
//                            .sink(receiveCompletion: { innerCompletion in
//                                if case let .failure(innerError) = innerCompletion {
//                                    print("Failed to load entity \(modelName): \(innerError.localizedDescription)")
//                                }
//                            }, receiveValue: { [weak self] entity in
//                                guard let self = self else { return }
//                                print("Entity \(modelName) loaded successfully as a generic Entity.")
//                                
//                                // Attach generic Entity to an Anchor
//                                let anchor = AnchorEntity(world: transform.matrix)
//                                anchor.addChild(entity)
//                                arView.scene.addAnchor(anchor)
//                            })
//                            .store(in: &self.cancellables)
//                    }
//                }, receiveValue: { [weak self] entity in
//                    guard let self = self else { return }
//                    
//                    // Check if the loaded entity is a ModelEntity
//                    if let modelEntity = entity as? ModelEntity {
//                        print("Successfully loaded model: \(modelName)")
//                        
//                        // Save reference to ModelEntity and attach it to the scene
//                        self.modelEntity = modelEntity
//                        modelEntity.scale = SIMD3<Float>(repeating: self.parent.modelScale)
//                        let anchor = AnchorEntity(world: transform.matrix)
//                        anchor.addChild(modelEntity)
//                        arView.scene.addAnchor(anchor)
//                    } else {
//                        print("Loaded entity is not a ModelEntity. Rendering it as a generic entity.")
//                        
//                        // Attach the generic Entity to an Anchor
//                        let anchor = AnchorEntity(world: transform.matrix)
//                        anchor.addChild(entity)
//                        arView.scene.addAnchor(anchor)
//                    }
//                })
//                .store(in: &cancellables)
//        }
//    }
//}
//
//struct ARMenuContainerView: View {
//    var models: [String]
//    var menuItems: [MenuItem]
//    @Binding var modelIndex: Int
//
//    @State private var modelScale: Float = 0.005 // Default scale for models
//
//    var body: some View {
//        ZStack {
//            ARMenuView(models: models, menuItems: menuItems, modelIndex: $modelIndex, modelScale: $modelScale)
//                .edgesIgnoringSafeArea(.all)
//
//            VStack {
//                Spacer()
//
//                // Scale slider
//                VStack {
//                    Text("Scale: \(Int(modelScale * 1000))%")
//                        .font(.caption)
//                    Slider(value: $modelScale, in: 0.001...0.01)
//                        .padding(.horizontal)
//                }
//                .padding(.bottom, 20)
//                .background(Color.white.opacity(0.8))
//                .cornerRadius(10)
//                .padding()
//
//                // Button to cycle through models
//                Button(action: {
//                    modelIndex = (modelIndex + 1) % models.count
//                    print("Switched to model index: \(modelIndex)")
//                }) {
//                    Text("Next Model")
//                        .font(.headline)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                        .padding(.horizontal)
//                }
//                .padding(.bottom, 20)
//            }
//        }
//    }
//}
//
//
//
//


















